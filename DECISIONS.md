# DECISIONS.md

Running log of confirmed architectural/product decisions for MetaboLoop, and
the reasoning behind each. Updated at every checkpoint sign-off.

Format per entry: **Decision** — what was chosen · **Alternatives considered**
· **Rationale** · **Date**.

---

## Checkpoint 1 — Tech Stack

**Status: Confirmed 2026-08-06.**

Primary constraint driving this checkpoint: minimize cost (especially fixed
infra cost pre-revenue) while keeping the stack extendable/portable for the
future. Both app stores (Apple App Store, Google Play) are confirmed
distribution targets.

- **Client**: Flutter. One codebase for iOS, Android, and (later) web — no
  duplicated engineering cost across platforms. Native builds are producible
  for both app stores.
- **Backend / DB / Auth / Storage / Serverless functions**: Supabase
  (hosted Postgres). Chosen over a custom NestJS + Cloud SQL/GCP setup and
  over Firebase. Free tier to start, flat $25/mo Pro tier when outgrown —
  avoids stacking per-service GCP bills (Cloud Run + Cloud SQL + separate
  auth). It's standard open-source Postgres underneath, so there's no real
  lock-in: can self-host or migrate to any Postgres-speaking backend later
  without a rewrite. Includes Auth (incl. Apple/Google sign-in), file
  storage (progress photos), and Edge Functions (weekly coaching
  recalculation job, webhooks).
- **Database**: PostgreSQL, via Supabase. Relational model fits the
  versioned target history, weight-trend time-series, and audit-trail
  requirements of the coaching algorithm better than a document store.
- **AI (photo & natural-language food logging)**: Gemini API, called
  directly (not via Vertex AI) from Supabase Edge Functions. Pay-per-call
  with a free tier; avoids standing up a separate GCP project/backend.
- **Food database**: USDA FoodData Central + Open Food Facts, blended.
  Both free — USDA for authoritative/micronutrient data, Open Food Facts
  for branded/barcode coverage. A commercial provider (e.g. Nutritionix)
  is deferred until product-market fit justifies the licensing cost.
- **Auth**: Supabase Auth (included). Supports email + Apple/Google
  sign-in without a separate identity provider.
- **Subscriptions**: RevenueCat, layered on native App Store Connect and
  Google Play Billing (required by both platforms' review policies).
  Free up to $2.5k/mo tracked revenue, then a small percentage — avoids
  building receipt validation/entitlement sync in-house.
- **Hosting/infra**: No separate cloud project — Supabase is the managed
  platform for backend/DB/auth/storage/functions. Removes the need for a
  standalone GCP/AWS/Azure account for the MVP.
- **Health data integrations**: Apple HealthKit + Google Health Connect,
  via Flutter's `health` plugin (covers both under one API). Required for
  feature parity regardless of other choices.

**Deferred/not yet decided**: Apple Developer Program ($99/yr) and Google
Play Console ($25 one-time) accounts are required to publish and to test
real in-app purchases — these must be set up by the project owner
(m.mehabadi@gmail.com), not provisionable by the assistant.

## Checkpoint 2 — Architecture & Data Model

**Status: Confirmed 2026-08-06.**

- **Overall architecture pattern**: modular monolith, expressed as
  domain-organized Postgres schemas/tables (`auth`, `logging`, `foods`,
  `coaching`, `analytics`, `billing`) with Supabase Edge Functions grouped
  by the same domains. Chosen over microservices (operational overhead not
  justified pre-revenue) and over ungrouped fully-serverless functions
  (gets unwieldy as feature count grows). Matches the phased build plan and
  keeps cost/ops minimal.
- **Core data model** (high level):
  - `users` — profile, sex, height, DOB, activity level, unit preference,
    coaching mode.
  - `body_stats_history` — time-series of weight/height/body-fat estimate;
    feeds the weight-trend smoothing.
  - `daily_logs` / `log_entries` — timeline-style entries (not fixed meal
    slots), each referencing a food/recipe with quantity, timestamp, and
    log method (manual/barcode/photo/NL/quick-add).
  - `foods` — normalized nutrition data (USDA + Open Food Facts + custom),
    with `source` and `verified` flags.
  - `recipes` / `recipe_ingredients` — supports nesting (an ingredient can
    itself be a recipe).
  - `targets` — **versioned**: one row per change
    (`user_id, effective_date, calories, protein, carbs, fat, reasoning,
    created_by`), never mutated in place — enables the transparency
    requirement in Phase 3.
  - `coaching_runs` — one row per weekly recalculation job execution:
    inputs used, computed TDEE, resulting target change, coaching mode at
    the time — the audit trail.
  - `day_overrides` — per-day custom targets (e.g. training days).
  - `subscription_state` — synced from RevenueCat webhooks.
- **Adaptive coaching algorithm placement**: server-side, as a scheduled
  Supabase Edge Function (pg_cron-triggered) running weekly per user. Reads
  `daily_logs` + `body_stats_history`, writes a `coaching_runs` row and,
  if the coaching mode allows it, a new `targets` row. Chosen over
  client-side computation, which is unreliable (depends on the app being
  opened) and complicates the audit trail.
- **Offline-first strategy**: local SQLite (via `drift`) as the on-device
  source of truth for logging, with a background sync queue to Supabase.
  Writes always succeed locally first; sync reconciles when connectivity
  returns. Chosen over relying on the Supabase client SDK's default
  caching or requiring connectivity outright — offline logging is a hard
  requirement for a food-logging app, not a nice-to-have.

## Checkpoint 3 — Design System & UX

**Status: Confirmed 2026-08-06.**

- **Design/component library**: Material 3, heavily themed (custom color
  scheme, typography, and a small set of custom components for macro rings,
  trend charts, and the timeline log). Chosen over building a custom design
  system from scratch (expensive, slows every future feature) and over a
  Cupertino-adaptive hybrid (roughly doubles component work for marginal
  benefit in a data-dense app). Cheapest to build/maintain and accessible
  by default.
- **Navigation pattern & IA**: bottom tab bar with four tabs — **Today**
  (timeline log), **Trends** (dashboard/analytics), **Coach** (targets,
  recalibration history, coaching mode), **Settings**. Chosen over a drawer,
  which adds friction to core actions in an app used many times a day.
- **Visual identity direction**: Direction A, clinical/minimal — neutral
  grays plus one signal accent color, system-native sans typography —
  as the base, with a dark-mode-first execution on the Trends screen
  specifically (borrowed from the data-dense direction). Chosen because
  it's the cheapest direction to theme well, fits a trust-first app whose
  core value prop is accurate numbers rather than gamification, and is
  easy to extend later without a redesign.
- **Onboarding flow structure**: goal selection → body stats (age, sex,
  height, weight, activity level) → initial macro estimate (labeled as a
  starting estimate) → account creation → trial/paywall. Lets users see
  their estimate before being asked to pay.

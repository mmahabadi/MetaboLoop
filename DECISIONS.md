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

_Pending confirmation._

## Checkpoint 3 — Design System & UX

_Pending confirmation._

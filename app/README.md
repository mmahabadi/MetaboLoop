# MetaboLoop (Flutter app)

Client app for MetaboLoop. See the repo root [`README.md`](../README.md) and
[`DECISIONS.md`](../DECISIONS.md) for product/architecture context.

## Structure

Feature-based, matching the confirmed modular-monolith architecture
(Checkpoint 2):

```
lib/
  core/            # theme, router, config — shared across features
  features/
    onboarding/    # goal, body stats, activity, macro estimate
    auth/          # sign-up/sign-in, Supabase-backed
    paywall/       # subscription tiers, RevenueCat-backed
    home/          # bottom-tab shell (Today/Trends/Coach/Settings)
```

Each feature is split into `domain/` (pure Dart, testable), `application/`
(state/controllers), and `presentation/` (widgets).

## Running locally

```
flutter pub get
flutter run -d chrome   # or an attached device/simulator
```

## Connecting a real backend

This build has no live Supabase project or RevenueCat app configured — the
sign-in and paywall screens work but show a "not configured" notice and
can't reach a real backend. To connect one:

1. Create a project at [supabase.com](https://supabase.com/dashboard) and an
   app at [RevenueCat](https://app.revenuecat.com).
2. Copy `.env.example` to `.env` and fill in the values.
3. Run with the values passed as `--dart-define`s, e.g.:

   ```
   flutter run \
     --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=xxxx \
     --dart-define=REVENUECAT_API_KEY=xxxx
   ```

   (`.env` itself isn't read automatically — it's just a place to keep the
   values; wire up `--dart-define-from-file=.env` or your CI secrets
   accordingly.)

## Tests

```
flutter analyze
flutter test
dart format --output=none --set-exit-if-changed .
```

## Notes on this environment

- `web/` is configured to fetch Roboto and other fonts as needed; no other
  web-specific configuration is required for normal development machines
  with internet access. (This repo bundles Roboto locally under
  `assets/fonts/` specifically to avoid a runtime dependency on
  `fonts.gstatic.com`, per the project's privacy-first requirement — this
  is unrelated to any particular development environment.)

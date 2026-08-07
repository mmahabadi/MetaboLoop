/// Reads backend/service configuration from `--dart-define` values supplied
/// at build/run time. None of these are committed to the repo — see
/// `.env.example` and the README for how to provide real values once a
/// Supabase project and RevenueCat app exist.
abstract final class AppConfig {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const revenueCatApiKey = String.fromEnvironment('REVENUECAT_API_KEY');

  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static bool get isRevenueCatConfigured => revenueCatApiKey.isNotEmpty;
}

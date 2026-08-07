import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/app_config.dart';

/// Thin wrapper around Supabase Auth. Kept as its own service (rather than
/// calling `Supabase.instance` directly from widgets) so the coaching/data
/// layers can depend on this instead of the Supabase SDK directly.
class AuthService {
  SupabaseClient get _client => Supabase.instance.client;

  bool get isConfigured => AppConfig.isSupabaseConfigured;

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) {
    return _client.auth.signUp(email: email, password: password);
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signInWithApple() {
    return _client.auth.signInWithOAuth(OAuthProvider.apple);
  }

  Future<void> signInWithGoogle() {
    return _client.auth.signInWithOAuth(OAuthProvider.google);
  }
}

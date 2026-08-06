import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../application/auth_service.dart';

enum _Mode { signUp, signIn }

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  _Mode _mode = _Mode.signUp;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      if (_mode == _Mode.signUp) {
        await _authService.signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await _authService.signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
      if (mounted) context.go(AppRoutes.paywall);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSignUp = _mode == _Mode.signUp;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isSignUp ? 'Create your account' : 'Welcome back',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: _submitting ? null : _authService.signInWithApple,
                icon: const Icon(Icons.apple),
                label: const Text('Continue with Apple'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _submitting ? null : _authService.signInWithGoogle,
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('Continue with Google'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or', style: theme.textTheme.bodySmall),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) =>
                          (value == null || !value.contains('@'))
                          ? 'Enter a valid email'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) => (value == null || value.length < 8)
                          ? 'At least 8 characters'
                          : null,
                    ),
                  ],
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
              ],
              if (!_authService.isConfigured) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'No Supabase project is configured in this build, so '
                    'sign-in cannot reach a real backend yet. Set '
                    'SUPABASE_URL / SUPABASE_ANON_KEY to connect one.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submitting ? null : _submitEmail,
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isSignUp ? 'Sign up' : 'Sign in'),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => setState(
                    () => _mode = isSignUp ? _Mode.signIn : _Mode.signUp,
                  ),
                  child: Text(
                    isSignUp
                        ? 'Already have an account? Sign in'
                        : "Don't have an account? Sign up",
                  ),
                ),
              ),
              if (!_authService.isConfigured && kDebugMode)
                Center(
                  child: TextButton(
                    onPressed: () => context.go(AppRoutes.paywall),
                    child: const Text('Continue without account (dev preview)'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

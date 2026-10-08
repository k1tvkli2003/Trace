import 'package:flutter/material.dart';
import 'package:trace_design/trace_design.dart';

import '../services/trace_auth_client.dart';
import '../services/trace_auth_messages.dart';

/// Single email/password screen. Unified login-or-signup per product brief:
/// existing account signs in, otherwise an account is created (unique email
/// enforced server-side). Reports the signed-in session via [onSignedIn].
class SignInPage extends StatefulWidget {
  const SignInPage({super.key, required this.signIn, required this.onSignedIn});

  final Future<TraceAuthTokens> Function(String email, String password) signIn;
  final ValueChanged<TraceAuthTokens> onSignedIn;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscured = true;
  bool _busy = false;
  String? _error;
  bool _canRetry = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
      _canRetry = false;
    });
    try {
      final tokens = await widget.signIn(_email.text, _password.text);
      if (!mounted) return;
      widget.onSignedIn(tokens);
    } on TraceAuthFailure catch (failure) {
      if (!mounted) return;
      final copy = traceAuthMessage(failure.code);
      setState(() {
        _error = copy.message;
        _canRetry = copy.retryable;
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Trace',
                  style: TextStyle(
                    color: TraceColors.onCanvas,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in with your email to continue. New here? An account is created for you.',
                  style: TextStyle(color: TraceColors.muted, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  enabled: !_busy,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'you@example.com',
                  ),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _password,
                  obscureText: _obscured,
                  autofillHints: const [AutofillHints.password],
                  enabled: !_busy,
                  onSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'At least 6 characters',
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscured = !_obscured),
                      icon: Icon(
                        _obscured
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Color(0xffef9a9a),
                      fontSize: 13,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _busy ? null : _submit,
                  child: _busy
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_canRetry ? 'Retry' : 'Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Email and password are required.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      if (mounted) {
        _showMessage('Signed in successfully.');
      }
    } on AuthException catch (error) {
      if (mounted) {
        if (_isEmailNotConfirmedError(error)) {
          await _showEmailVerificationDialog(email);
        } else {
          _showMessage(error.message);
        }
      }
    } catch (_) {
      if (mounted) {
        _showMessage('Something went wrong. Please try again.');
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      await _authService.signInWithGoogle();
    } on AuthException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    } catch (_) {
      if (mounted) {
        _showMessage('Google sign-in could not be started.');
      }
    }

    if (mounted) {
      setState(() {
        _isGoogleLoading = false;
      });
    }
  }

  bool _isEmailNotConfirmedError(AuthException error) {
    final message = error.message.toLowerCase();

    return message.contains('email not confirmed') ||
        message.contains('email_not_confirmed');
  }

  Future<void> _showEmailVerificationDialog(String email) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        bool isResending = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> resend() async {
              setDialogState(() {
                isResending = true;
              });

              try {
                await _authService.resendVerificationEmail(
                  email: email,
                );

                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }

                if (mounted) {
                  _showMessage('Verification email sent again.');
                }
              } on AuthException catch (error) {
                if (dialogContext.mounted) {
                  _showMessage(error.message);
                }
              } catch (_) {
                if (dialogContext.mounted) {
                  _showMessage(
                    'Something went wrong. Please try again.',
                  );
                }
              }

              if (dialogContext.mounted) {
                setDialogState(() {
                  isResending = false;
                });
              }
            }

            return AlertDialog(
              title: const Text('Email not verified'),
              content: Text(
                'Please verify $email before signing in. '
                'Check your inbox for the verification email.',
              ),
              actions: [
                TextButton(
                  onPressed: isResending
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Close'),
                ),
                FilledButton(
                  onPressed: isResending ? null : resend,
                  child: isResending
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Resend email'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _openRegister() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = _isLoading || _isGoogleLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !isBusy,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                enabled: !isBusy,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isBusy ? null : _signIn,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Sign in'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: isBusy ? null : _signInWithGoogle,
                  child: _isGoogleLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Continue with Google'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: isBusy ? null : _openRegister,
                child: const Text('Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

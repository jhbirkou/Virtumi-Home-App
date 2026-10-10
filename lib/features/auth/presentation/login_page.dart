import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../../../core/auth/auth_providers.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

/// Email/password sign-in screen.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).signIn(
            email: _email.text.trim(),
            password: _password.text,
          );
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anmeldung fehlgeschlagen: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: AppScrollView(
        children: [
          SizedBox(height: AppSpacing.sectionMargin),
          SectionHeaderCard(
            title: 'Virtumi Home',
            subtitle: 'Melde dich an, um deine Geräte zu verwalten',
            icon: Symbols.home,
            filled: true,
          ),
          SizedBox(height: AppSpacing.sectionMargin),
          AppCard(
            child: Column(
              children: [
                SettingsInputRow(
                  icon: Symbols.mail,
                  label: 'E-Mail',
                  controller: _email,
                  iconColor: context.palette.accentBlue,
                  keyboardType: TextInputType.emailAddress,
                ),
                const Divider(height: 1),
                SettingsInputRow(
                  icon: Symbols.lock,
                  label: 'Passwort',
                  controller: _password,
                  iconColor: context.palette.accentOrange,
                  obscure: _obscure,
                  onToggleObscure: () => setState(() => _obscure = !_obscure),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.gutter),
          FilledButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Anmelden'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => context.go('/register'),
            child: const Text('Noch kein Konto? Registrieren'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/auth/auth_providers.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

/// Email/password registration screen.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;

    if (_password.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwort muss mindestens 8 Zeichen haben')),
      );
      return;
    }
    if (_password.text != _confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwörter stimmen nicht überein')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).signUp(
            email: _email.text.trim(),
            password: _password.text,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrierung erfolgreich. Bitte E-Mail bestätigen.'),
          ),
        );
        context.go('/login');
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrierung fehlgeschlagen: $e')),
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
            title: 'Konto erstellen',
            subtitle: 'Registriere dich für Virtumi Home',
            icon: Symbols.person_add,
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
                const Divider(height: 1),
                SettingsInputRow(
                  icon: Symbols.lock_reset,
                  label: 'Passwort bestätigen',
                  controller: _confirm,
                  iconColor: context.palette.accentGreen,
                  obscure: _obscure,
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
                : const Text('Registrieren'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => context.go('/login'),
            child: const Text('Bereits registriert? Anmelden'),
          ),
        ],
      ),
    );
  }
}

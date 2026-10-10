import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../core/widgets/widgets.dart';

class WizardPasswordForm extends StatefulWidget {
  const WizardPasswordForm({
    super.key,
    required this.changePassword,
    required this.onChangePassword,
    required this.onPasswordsChanged,
    required this.onSave,
    required this.onSkip,
    this.isBusy = false,
  });

  final bool changePassword;
  final ValueChanged<bool> onChangePassword;
  final void Function(String newPassword, String confirm) onPasswordsChanged;
  final VoidCallback onSave;
  final VoidCallback onSkip;
  final bool isBusy;

  @override
  State<WizardPasswordForm> createState() => _WizardPasswordFormState();
}

class _WizardPasswordFormState extends State<WizardPasswordForm> {
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  var _obscureNew = true;
  var _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _newPassword.addListener(_emitPasswords);
    _confirmPassword.addListener(_emitPasswords);
  }

  @override
  void dispose() {
    _newPassword.removeListener(_emitPasswords);
    _confirmPassword.removeListener(_emitPasswords);
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _emitPasswords() {
    widget.onPasswordsChanged(_newPassword.text, _confirmPassword.text);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeaderCard(
          title: 'Passwort ändern',
          subtitle: 'Geräte-Zugang absichern',
          icon: Symbols.lock,
          filled: true,
        ),
        const AppSectionLabel('Sicherheit'),
        GroupedListCard(
          children: [
            SettingsRow.toggle(
              icon: Symbols.lock_reset,
              title: 'Geräte-Passwort ändern',
              iconColor: p.accentOrange,
              value: widget.changePassword,
              onChanged: widget.onChangePassword,
            ),
          ],
        ),
        if (widget.changePassword) ...[
          const SizedBox(height: AppSpacing.md),
          GroupedListCard(
            children: [
              SettingsInputRow(
                icon: Symbols.password,
                label: 'Neues Passwort',
                controller: _newPassword,
                iconColor: p.accentBlue,
                obscure: _obscureNew,
                enabled: !widget.isBusy,
                onToggleObscure: () =>
                    setState(() => _obscureNew = !_obscureNew),
              ),
              SettingsInputRow(
                icon: Symbols.check_circle,
                label: 'Bestätigen',
                controller: _confirmPassword,
                iconColor: p.accentGreen,
                obscure: _obscureConfirm,
                enabled: !widget.isBusy,
                onToggleObscure: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ],
          ),
        ],
        SaveCancelCard(
          saveLabel: 'Weiter',
          cancelLabel: 'Überspringen',
          onSave: widget.isBusy ? () {} : widget.onSave,
          onCancel: widget.isBusy ? () {} : widget.onSkip,
        ),
      ],
    );
  }
}

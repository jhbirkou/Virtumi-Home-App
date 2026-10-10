import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/theme.dart';
import 'icon_box.dart';

/// A grouped-list row with an inline text field: a tinted icon, a small label,
/// and an editable value. Used in network / cloud / location forms.
class SettingsInputRow extends StatelessWidget {
  const SettingsInputRow({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    required this.iconColor,
    this.enabled = true,
    this.obscure = false,
    this.onToggleObscure,
    this.keyboardType,
    this.hint,
  });

  final IconData icon;
  final String label;
  final TextEditingController controller;
  final Color iconColor;
  final bool enabled;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final TextInputType? keyboardType;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconBox(icon: icon, color: iconColor),
          const SizedBox(width: AppSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label.toUpperCase(), style: context.text.labelSmall),
                TextField(
                  controller: controller,
                  enabled: enabled,
                  obscureText: obscure,
                  keyboardType: keyboardType,
                  style: context.text.bodyLarge,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: hint,
                  ),
                ),
              ],
            ),
          ),
          if (onToggleObscure != null)
            IconButton(
              onPressed: onToggleObscure,
              icon: Icon(
                obscure ? Symbols.visibility_off : Symbols.visibility,
                color: context.colors.onSurfaceVariant,
              ),
              tooltip: obscure ? 'Anzeigen' : 'Verbergen',
            ),
        ],
      ),
    );
  }
}

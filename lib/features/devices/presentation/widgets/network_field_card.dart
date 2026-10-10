import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// Single network setting card with icon, label and text input.
class NetworkFieldCard extends StatelessWidget {
  const NetworkFieldCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.controller,
    this.enabled = true,
    this.obscure = false,
    this.onToggleObscure,
    this.keyboardType,
    this.hint,
    this.compactValue = false,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final TextInputType? keyboardType;
  final String? hint;
  final bool compactValue;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconBox(icon: icon, color: iconColor),
          const SizedBox(width: AppSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label.toUpperCase(), style: context.text.labelSmall),
                TextField(
                  controller: controller,
                  enabled: enabled,
                  obscureText: obscure,
                  keyboardType: keyboardType,
                  style: compactValue
                      ? context.text.bodySmall?.copyWith(
                          fontSize: 11,
                          height: 1.25,
                          letterSpacing: 0,
                        )
                      : context.text.bodyLarge,
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

/// Single network setting card with a tappable picker value.
class NetworkPickerCard extends StatelessWidget {
  const NetworkPickerCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final picker = NeumorphicContainer(
      style: NeumorphicStyle.sunken,
      borderRadius: AppRadius.smAll,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.gutter,
        vertical: AppSpacing.sm + 2,
      ),
      child: Row(
        children: [
          Expanded(child: Text(value, style: context.text.bodyLarge)),
          Icon(
            Symbols.expand_more,
            color: context.colors.onSurfaceVariant,
            size: 22,
          ),
        ],
      ),
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBox(icon: icon, color: iconColor),
              const SizedBox(width: AppSpacing.gutter),
              Text(label.toUpperCase(), style: context.text.labelSmall),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (onTap == null)
            picker
          else
            Semantics(
              button: true,
              label: '$label: $value',
              child: InkWell(
                onTap: onTap,
                borderRadius: AppRadius.smAll,
                splashColor: Colors.transparent,
                child: picker,
              ),
            ),
        ],
      ),
    );
  }
}

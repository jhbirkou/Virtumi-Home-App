import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/theme.dart';

/// Numeric keypad for PIN entry (0–9, backspace).
class PinKeypad extends StatelessWidget {
  const PinKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.enabled = true,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in rows) ...[
          Row(
            children: [
              for (final digit in row)
                Expanded(
                  child: _KeyButton(
                    label: digit,
                    enabled: enabled,
                    onTap: () => onDigit(digit),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Row(
          children: [
            const Spacer(),
            Expanded(
              child: _KeyButton(
                label: '0',
                enabled: enabled,
                onTap: () => onDigit('0'),
              ),
            ),
            Expanded(
              child: _KeyButton(
                icon: Symbols.backspace,
                enabled: enabled,
                onTap: onBackspace,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    this.label,
    this.icon,
    required this.onTap,
    required this.enabled,
  });

  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: AppRadius.full,
          child: Container(
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.palette.controlSurface,
              borderRadius: AppRadius.full,
              border: context.palette.flatElevation
                  ? Border.all(color: context.palette.cardBorder)
                  : null,
              boxShadow: context.palette.flatElevation
                  ? null
                  : context.palette.raisedSmall,
            ),
            child: icon != null
                ? Icon(icon, color: context.colors.onSurface)
                : Text(
                    label!,
                    style: context.text.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Visual indicator for entered PIN digits.
class PinDots extends StatelessWidget {
  const PinDots({
    super.key,
    required this.filled,
    this.pinLength = 4,
    this.hasError = false,
  });

  final int filled;
  final int pinLength;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final color =
        hasError ? context.colors.error : context.colors.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pinLength, (index) {
        final isFilled = index < filled;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFilled ? color : Colors.transparent,
              border: Border.all(color: color, width: 2),
            ),
          ),
        );
      }),
    );
  }
}

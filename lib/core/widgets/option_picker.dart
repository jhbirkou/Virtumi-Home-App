import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/theme.dart';

/// Shows a neumorphic modal bottom sheet for single-select option lists and
/// returns the chosen value (or null when dismissed).
Future<T?> showOptionPicker<T>({
  required BuildContext context,
  required String title,
  required List<T> options,
  required String Function(T option) labelOf,
  required T selected,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (context) => _OptionPickerSheet<T>(
      title: title,
      options: options,
      labelOf: labelOf,
      selected: selected,
    ),
  );
}

class _OptionPickerSheet<T> extends StatelessWidget {
  const _OptionPickerSheet({
    required this.title,
    required this.options,
    required this.labelOf,
    required this.selected,
  });

  final String title;
  final List<T> options;
  final String Function(T option) labelOf;
  final T selected;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.7;

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.gutter),
        padding: const EdgeInsets.all(AppSpacing.md),
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: AppRadius.cardLgAll,
          boxShadow: context.palette.raised,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.gutter),
                decoration: BoxDecoration(
                  color: context.colors.outlineVariant,
                  borderRadius: AppRadius.full,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.sm,
                bottom: AppSpacing.sm,
              ),
              child: Text(title, style: context.text.titleMedium),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final option in options)
                    _OptionRow(
                      label: labelOf(option),
                      selected: option == selected,
                      onTap: () => Navigator.of(context).pop(option),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.gutter,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: context.text.bodyLarge?.copyWith(
                    color: selected ? primary : context.colors.onSurface,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (selected)
                Icon(Symbols.check_circle, color: primary, fill: 1, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

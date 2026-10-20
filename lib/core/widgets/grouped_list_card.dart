import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/theme.dart';
import 'app_card.dart';
import 'app_toggle.dart';
import 'icon_box.dart';
import 'press_scale.dart';

/// A single raised card that groups related [SettingsRow]s, separated by subtle
/// dividers, matching the "Grouped List" component from the design system.
class GroupedListCard extends StatelessWidget {
  const GroupedListCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final divider = context.palette.divider;
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      rows.add(children[i]);
      if (i != children.length - 1) {
        rows.add(Divider(height: 1, thickness: 1, color: divider));
      }
    }

    return AppCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: AppRadius.cardAll,
        child: Column(children: rows),
      ),
    );
  }
}

/// A configurable row inside a [GroupedListCard].
///
/// Use the named constructors for the common variants:
/// - [SettingsRow.navigation]: trailing value + chevron
/// - [SettingsRow.toggle]: trailing [AppToggle]
/// - [SettingsRow.new] with [trailing]: fully custom trailing widget
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
    this.onTap,
    this.trailing,
    this.danger = false,
    this.glow = false,
  });

  /// Navigation row: shows an optional [value] and a chevron.
  factory SettingsRow.navigation({
    Key? key,
    required IconData icon,
    required String title,
    required Color iconColor,
    String? value,
    VoidCallback? onTap,
    bool danger = false,
    bool glow = false,
    Widget? badge,
  }) {
    return SettingsRow(
      key: key,
      icon: icon,
      title: title,
      iconColor: iconColor,
      onTap: onTap,
      danger: danger,
      glow: glow,
      trailing: _NavigationTrailing(value: value, danger: danger, badge: badge),
    );
  }

  /// Toggle row: shows an [AppToggle] on the trailing side.
  factory SettingsRow.toggle({
    Key? key,
    required IconData icon,
    required String title,
    required Color iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool glow = false,
  }) {
    return SettingsRow(
      key: key,
      icon: icon,
      title: title,
      iconColor: iconColor,
      glow: glow,
      trailing: AppToggle(
        value: value,
        onChanged: onChanged,
        semanticLabel: title,
      ),
    );
  }

  final IconData icon;
  final String title;
  final Color iconColor;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool danger;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final titleColor =
        danger ? context.colors.error : context.colors.onSurface;

    final content = Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          IconBox(icon: icon, color: iconColor, glow: glow),
          const SizedBox(width: AppSpacing.gutter),
          Expanded(
            child: Text(
              title,
              style: context.text.bodyLarge?.copyWith(
                color: titleColor,
                fontWeight: danger ? FontWeight.w600 : null,
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.sm),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap == null) return content;

    return PressScale(
      onTap: onTap,
      semanticLabel: title,
      child: content,
    );
  }
}

class _NavigationTrailing extends StatelessWidget {
  const _NavigationTrailing({this.value, this.badge, this.danger = false});

  final String? value;
  final Widget? badge;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final chevronColor = danger
        ? context.colors.error.withValues(alpha: 0.7)
        : context.colors.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (badge != null) ...[badge!, const SizedBox(width: AppSpacing.sm)],
        if (value != null)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: Text(
              value!,
              style: context.text.bodyMedium
                  ?.copyWith(color: context.colors.onSurfaceVariant),
            ),
          ),
        Icon(Symbols.chevron_right, color: chevronColor, size: 24),
      ],
    );
  }
}

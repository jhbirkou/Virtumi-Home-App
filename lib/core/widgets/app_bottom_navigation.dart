import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/theme.dart';
import 'press_scale.dart';

/// A bottom navigation destination definition.
class AppNavDestination {
  const AppNavDestination({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

/// Floating glassmorphic bottom navigation bar, identical on every tab screen.
///
/// The active tab is highlighted with a primary, filled icon inside a soft
/// circle plus a blurred glow behind it.
class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<AppNavDestination> destinations = [
    AppNavDestination(icon: Symbols.home, label: 'Home'),
    AppNavDestination(icon: Symbols.bolt, label: 'Szenen'),
    AppNavDestination(icon: Symbols.group, label: 'Personen'),
    AppNavDestination(icon: Symbols.settings, label: 'Einstellungen'),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      child: ClipRRect(
        borderRadius: AppRadius.full,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
            decoration: BoxDecoration(
              color: palette.flatElevation
                  ? colors.surfaceContainerHighest.withValues(alpha: 0.6)
                  : palette.neuSurface.withValues(alpha: 0.55),
              borderRadius: AppRadius.full,
              border: Border.all(
                color: palette.flatElevation
                    ? Colors.white.withValues(alpha: 0.1)
                    : palette.shadowLight.withValues(alpha: 0.6),
              ),
              boxShadow: palette.flatElevation ? null : palette.floating,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < destinations.length; i++)
                  _NavItem(
                    destination: destinations[i],
                    active: i == currentIndex,
                    onTap: () => onTap(i),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.active,
    required this.onTap,
  });

  final AppNavDestination destination;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final inactive = context.colors.onSurfaceVariant.withValues(alpha: 0.6);
    final palette = context.palette;

    return PressScale(
      onTap: onTap,
      semanticLabel: destination.label,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48,
              height: 44,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (active)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: palette.flatElevation
                            ? primary.withValues(alpha: 0.15)
                            : context.colors.surfaceContainerHighest
                                .withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: palette.flatElevation
                            ? Border.all(
                                color: primary.withValues(alpha: 0.35),
                              )
                            : null,
                        boxShadow: palette.flatElevation
                            ? null
                            : [
                                BoxShadow(
                                  color: primary.withValues(alpha: 0.25),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                      ),
                    ),
                  Icon(
                    destination.icon,
                    size: 24,
                    fill: active ? 1 : 0,
                    color: active ? primary : inactive,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              destination.label,
              style: context.text.labelSmall?.copyWith(
                color: active ? primary : inactive,
                fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

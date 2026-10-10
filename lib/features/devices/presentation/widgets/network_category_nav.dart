import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/theme.dart';
import '../../../../shared/models/models.dart';

/// Horizontal main category selector for the network settings page.
class NetworkCategoryNav extends StatelessWidget {
  const NetworkCategoryNav({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final NetworkMainCategory selected;
  final ValueChanged<NetworkMainCategory> onSelected;

  static const _icons = {
    NetworkMainCategory.modePort: Symbols.settings,
    NetworkMainCategory.wifiAp: Symbols.wifi,
    NetworkMainCategory.wifiStation: Symbols.router,
  };

  static const _shortLabels = {
    NetworkMainCategory.modePort: 'Mode/Port',
    NetworkMainCategory.wifiAp: 'WiFi AP',
    NetworkMainCategory.wifiStation: 'Station',
  };

  @override
  Widget build(BuildContext context) {
    return _SegmentedNavShell(
      children: [
        for (var i = 0; i < NetworkMainCategory.values.length; i++) ...[
          if (i > 0) const SizedBox(width: 3),
          Expanded(
            child: _CompactSegment(
              icon: _icons[NetworkMainCategory.values[i]]!,
              label: _shortLabels[NetworkMainCategory.values[i]]!,
              semanticLabel: NetworkMainCategory.values[i].label,
              selected: NetworkMainCategory.values[i] == selected,
              onTap: () => onSelected(NetworkMainCategory.values[i]),
            ),
          ),
        ],
      ],
    );
  }
}

/// Sub-category selector shown for WiFi AP and WiFi Station.
class NetworkSubCategoryNav extends StatelessWidget {
  const NetworkSubCategoryNav({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final NetworkSubCategory selected;
  final ValueChanged<NetworkSubCategory> onSelected;

  static const _shortLabels = {
    NetworkSubCategory.general: 'Allgemein',
    NetworkSubCategory.details: 'Details',
  };

  @override
  Widget build(BuildContext context) {
    return _SegmentedNavShell(
      children: [
        for (var i = 0; i < NetworkSubCategory.values.length; i++) ...[
          if (i > 0) const SizedBox(width: 3),
          Expanded(
            child: _CompactSegment(
              label: _shortLabels[NetworkSubCategory.values[i]]!,
              semanticLabel: NetworkSubCategory.values[i].label,
              selected: NetworkSubCategory.values[i] == selected,
              onTap: () => onSelected(NetworkSubCategory.values[i]),
            ),
          ),
        ],
      ],
    );
  }
}

class _SegmentedNavShell extends StatelessWidget {
  const _SegmentedNavShell({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainer,
        borderRadius: AppRadius.mdAll,
      ),
      child: Row(children: children),
    );
  }
}

class _CompactSegment extends StatelessWidget {
  const _CompactSegment({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.semanticLabel,
  });

  final IconData? icon;
  final String label;
  final String? semanticLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final inactive = context.colors.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel ?? label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.smAll,
          splashColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: icon != null ? AppSpacing.sm : AppSpacing.sm + 2,
            ),
            decoration: BoxDecoration(
              color: selected ? context.palette.neuSurface : Colors.transparent,
              borderRadius: AppRadius.smAll,
              boxShadow: selected ? context.palette.raisedSmall : null,
            ),
            child: icon != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 18,
                        fill: selected ? 1 : 0,
                        color: selected ? primary : inactive,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        label,
                        style: context.text.labelSmall?.copyWith(
                          fontSize: 10,
                          height: 1.15,
                          color: selected ? primary : inactive,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                : Text(
                    label,
                    style: context.text.labelSmall?.copyWith(
                      fontSize: 11,
                      height: 1.15,
                      color: selected ? primary : inactive,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ),
      ),
    );
  }
}

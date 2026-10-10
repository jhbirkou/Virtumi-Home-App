import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/models/models.dart';

/// Highlighted card showing a connection status with a colored indicator.
class ConnectionStatusCard extends StatelessWidget {
  const ConnectionStatusCard({
    super.key,
    required this.status,
    required this.title,
    this.onReset,
    this.resetTooltip = 'Verbindung initialisieren',
  });

  final ConnectionStatus status;
  final String title;
  final VoidCallback? onReset;
  final String resetTooltip;

  Color _color(BuildContext context) {
    return switch (status) {
      ConnectionStatus.connected => context.palette.statusOnline,
      ConnectionStatus.connecting => context.palette.accentAmber,
      ConnectionStatus.disconnected => context.colors.outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    return AppCard(
      child: Row(
        children: [
          IconBox(
            icon: status == ConnectionStatus.connected
                ? Symbols.cloud_done
                : status == ConnectionStatus.connecting
                    ? Symbols.sync
                    : Symbols.cloud_off,
            color: color,
            size: AppSizes.iconBoxMd,
            filled: true,
            glow: true,
          ),
          const SizedBox(width: AppSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: context.text.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(status.label, style: context.text.bodySmall),
              ],
            ),
          ),
          if (onReset != null) ...[
            NeumorphicIconButton(
              icon: Symbols.restart_alt,
              size: 40,
              iconSize: 20,
              tooltip: resetTooltip,
              onPressed: status == ConnectionStatus.connecting ? null : onReset,
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

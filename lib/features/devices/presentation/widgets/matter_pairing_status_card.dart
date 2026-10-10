import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// Pairing status card for Matter, styled like [ConnectionStatusCard].
class MatterPairingStatusCard extends StatelessWidget {
  const MatterPairingStatusCard({
    super.key,
    required this.paired,
  });

  final bool paired;

  @override
  Widget build(BuildContext context) {
    final color = paired
        ? context.palette.statusOnline
        : context.colors.outline;
    final statusLabel = paired ? 'Gekoppelt' : 'Nicht gekoppelt';

    return AppCard(
      child: Row(
        children: [
          IconBox(
            icon: paired ? Symbols.link : Symbols.link_off,
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
                  'Kopplung Status',
                  style: context.text.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(statusLabel, style: context.text.bodySmall),
              ],
            ),
          ),
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

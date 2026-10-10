import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/models/models.dart';
import 'device_card_text_styles.dart';

/// Two-column grid of quick summary stat tiles derived from the room's devices
/// (e.g. light state, temperature).
class RoomSummaryGrid extends StatelessWidget {
  const RoomSummaryGrid({super.key, required this.devices});

  final List<Device> devices;

  @override
  Widget build(BuildContext context) {
    final tiles = _buildTiles();
    if (tiles.isEmpty) return const SizedBox.shrink();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.cardGap,
      crossAxisSpacing: AppSpacing.cardGap,
      childAspectRatio: 1.25,
      children: tiles,
    );
  }

  List<Widget> _buildTiles() {
    final tiles = <Widget>[];

    final withTemp = devices.where((d) => d.temperature != null).firstOrNull;
    if (withTemp != null) {
      tiles.add(_SummaryTile(
        label: 'Temp',
        value: '${withTemp.temperature!.toStringAsFixed(1)}\u00b0C',
        icon: Symbols.device_thermostat,
      ));
    }
    return tiles;
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconBox(
            icon: icon,
            color: context.colors.primary,
            size: AppSizes.iconBoxSm,
          ),
          const SizedBox(height: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.toUpperCase(),
                style: DeviceCardTextStyles.statLabel(context),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: DeviceCardTextStyles.statValue(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/providers/data_providers.dart';

/// Opens a location search bottom sheet and returns the chosen [Location].
Future<Location?> showLocationSearch(BuildContext context) {
  return showModalBottomSheet<Location>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (_) => const _LocationSearchSheet(),
  );
}

class _LocationSearchSheet extends ConsumerStatefulWidget {
  const _LocationSearchSheet();

  @override
  ConsumerState<_LocationSearchSheet> createState() =>
      _LocationSearchSheetState();
}

class _LocationSearchSheetState extends ConsumerState<_LocationSearchSheet> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(locationSearchProvider(_query));
    final maxHeight = MediaQuery.sizeOf(context).height * 0.78;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: SafeArea(
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
              Row(
                children: [
                  IconBox(icon: Symbols.public, color: context.colors.primary),
                  const SizedBox(width: AppSpacing.gutter),
                  Text('Zeitzone', style: context.text.titleMedium),
                ],
              ),
              const SizedBox(height: AppSpacing.gutter),
              Text('Standort suchen (Stadt oder Land)',
                  style: context.text.labelSmall),
              const SizedBox(height: AppSpacing.sm),
              _SearchField(
                controller: _controller,
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: AppSpacing.md),
              Flexible(
                child: AsyncValueView<List<Location>>(
                  value: resultsAsync,
                  data: (locations) => _Results(locations: locations),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      style: NeumorphicStyle.sunken,
      borderRadius: AppRadius.mdAll,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      child: Row(
        children: [
          Icon(Symbols.search, color: context.colors.onSurfaceVariant),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              onChanged: onChanged,
              style: context.text.bodyLarge,
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'z. B. Nürnberg',
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.locations});
  final List<Location> locations;

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          'Keine Orte gefunden',
          textAlign: TextAlign.center,
          style: context.text.bodyMedium
              ?.copyWith(color: context.colors.onSurfaceVariant),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: locations.length,
      separatorBuilder: (_, _) =>
          Divider(height: 1, color: context.palette.divider),
      itemBuilder: (context, index) {
        final loc = locations[index];
        return InkWell(
          onTap: () => Navigator.of(context).pop(loc),
          borderRadius: AppRadius.mdAll,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.gutter,
            ),
            child: Row(
              children: [
                Icon(Symbols.location_on,
                    color: context.colors.onSurfaceVariant, size: 22),
                const SizedBox(width: AppSpacing.gutter),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(loc.city,
                          style: context.text.bodyLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text(loc.country, style: context.text.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

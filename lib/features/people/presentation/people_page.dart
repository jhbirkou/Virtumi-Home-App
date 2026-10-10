import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/providers/data_providers.dart';
import '../../profile/presentation/widgets/profile_card.dart';

/// People tab ("Personen"). Designed consistently with the system (no Stitch
/// reference exists for this tab yet).
class PeoplePage extends ConsumerWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;

    return AppScaffold(
      header: const AppHeader(showBack: false),
      body: AppScrollView(
        children: [
          const SectionHeaderCard(
            title: 'Personen',
            icon: Symbols.group,
            subtitle: 'Zugriff & Berechtigungen verwalten',
            filled: true,
          ),
          ActionBannerCard(
            icon: Symbols.person_add,
            title: 'Person einladen',
            subtitle: 'Zugriff per E-Mail teilen',
            accent: context.colors.primary,
            trailingIcon: Symbols.add,
            trailingFilledButton: true,
            onTap: () {},
          ),
          const AppSectionLabel('Mitglieder'),
          if (user != null) ProfileCard(user: user),
          const EmptyState(
            icon: Symbols.group_add,
            message: 'Noch keine weiteren Personen verknüpft',
          ),
        ],
      ),
    );
  }
}

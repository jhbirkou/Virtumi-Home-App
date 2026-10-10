import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/providers/data_providers.dart';
import '../theme/theme.dart';
import '../widgets/app_bottom_navigation.dart';

/// Hosts the four primary tab branches and overlays the floating bottom
/// navigation so it stays visible (and consistent) across nested drill-downs.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.only(
                bottom:
                    MediaQuery.paddingOf(context).bottom + AppSpacing.bottomNavInset,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AppBottomNavigation(
                  currentIndex: navigationShell.currentIndex,
                  onTap: (index) => _onTap(index, ref),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTap(int index, WidgetRef ref) {
    if (index == 0) {
      refreshHomeScreenData(ref);
    }

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/preferences_service.dart';

/// Persists the last opened house ids (max. 2) for the Home houses grid.
class RecentHouseActivityNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return ref.read(preferencesServiceProvider).recentHouseIds;
  }

  Future<void> record(String houseId) async {
    final updated = [
      houseId,
      ...state.where((id) => id != houseId),
    ].take(PreferencesService.maxRecentHouses).toList();

    state = updated;
    await ref.read(preferencesServiceProvider).setRecentHouseIds(updated);
  }

  Future<void> syncStored(List<String> ids) async {
    if (listEquals(state, ids)) return;
    state = ids;
    await ref.read(preferencesServiceProvider).setRecentHouseIds(ids);
  }
}

final recentHouseActivityProvider =
    NotifierProvider<RecentHouseActivityNotifier, List<String>>(
  RecentHouseActivityNotifier.new,
);

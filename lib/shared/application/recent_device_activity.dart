import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/preferences_service.dart';

/// Persists the last controlled device ids (max. 3) for the Home activity list.
class RecentDeviceActivityNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return ref.read(preferencesServiceProvider).recentDeviceIds;
  }

  Future<void> record(String deviceId) async {
    final updated = [
      deviceId,
      ...state.where((id) => id != deviceId),
    ].take(PreferencesService.maxRecentDevices).toList();

    state = updated;
    await ref.read(preferencesServiceProvider).setRecentDeviceIds(updated);
  }

  Future<void> syncStored(List<String> ids) async {
    if (listEquals(state, ids)) return;
    state = ids;
    await ref.read(preferencesServiceProvider).setRecentDeviceIds(ids);
  }
}

final recentDeviceActivityProvider =
    NotifierProvider<RecentDeviceActivityNotifier, List<String>>(
  RecentDeviceActivityNotifier.new,
);

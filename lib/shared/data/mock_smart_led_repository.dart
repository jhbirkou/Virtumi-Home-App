import '../domain/smart_led_repository.dart';
import '../models/smart_led_strip.dart';
import '../models/smart_led_trigger.dart';
import 'supabase/mappers/extended_mappers.dart';

class MockSmartLedRepository implements SmartLedRepository {
  final _strips = <String, List<SmartLedStrip>>{};
  final _triggers = <String, List<SmartLedTrigger>>{};

  @override
  Future<List<SmartLedStrip>> getStrips(String deviceId) async {
    return _strips[deviceId] ?? defaultSmartLedStrips();
  }

  @override
  Future<void> saveStrip(
    String deviceId,
    SmartLedStrip strip, {
    bool quickControl = false,
  }) async {
    final list = List<SmartLedStrip>.from(await getStrips(deviceId));
    final index = list.indexWhere((s) => s.ledIndex == strip.ledIndex);
    if (index >= 0) {
      list[index] = strip;
    } else {
      list.add(strip);
    }
    _strips[deviceId] = list;
  }

  @override
  Future<List<SmartLedTrigger>> getTriggers(String deviceId) async {
    return _triggers[deviceId] ?? defaultSmartLedTriggers();
  }

  @override
  Future<List<SmartLedTrigger>> getActiveTriggers(String deviceId) async {
    final all = await getTriggers(deviceId);
    return all.where((t) => t.active == 1).toList();
  }

  @override
  Future<int?> nextFreeTriggerIndex(String deviceId) async {
    final all = await getTriggers(deviceId);
    for (final trigger in all) {
      if (trigger.active != 1) return trigger.parameterIndex;
    }
    return null;
  }

  @override
  Future<void> saveTrigger(String deviceId, SmartLedTrigger trigger) async {
    final list = List<SmartLedTrigger>.from(await getTriggers(deviceId));
    final index = list.indexWhere((t) => t.parameterIndex == trigger.parameterIndex);
    if (index >= 0) {
      list[index] = trigger;
    } else {
      list.add(trigger);
    }
    _triggers[deviceId] = list;
  }

  @override
  Future<void> deactivateTrigger(
    String deviceId,
    int parameterIndex,
  ) async {
    final list = List<SmartLedTrigger>.from(await getTriggers(deviceId));
    final index = list.indexWhere((t) => t.parameterIndex == parameterIndex);
    if (index < 0) return;
    list[index] = list[index].copyWith(active: 0);
    _triggers[deviceId] = list;
  }
}

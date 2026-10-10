import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/supabase/supabase_helpers.dart';
import '../../domain/smart_led_repository.dart';
import '../../models/smart_led_strip.dart';
import '../../models/smart_led_trigger.dart';
import 'mappers/extended_mappers.dart';

class SupabaseSmartLedRepository implements SmartLedRepository {
  SupabaseSmartLedRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<SmartLedStrip>> getStrips(String deviceId) async {
    final rows = await _client
        .from('smart_led_settings')
        .select()
        .eq('device_id', deviceId)
        .order('led_index');

    if (rows.isEmpty) return defaultSmartLedStrips();

    final byIndex = {
      for (final row in rows) row['led_index'] as int: mapSmartLedStrip(row),
    };

    return [1, 2, 3].map((i) => byIndex[i] ?? SmartLedStrip(ledIndex: i)).toList();
  }

  @override
  Future<void> saveStrip(
    String deviceId,
    SmartLedStrip strip, {
    bool quickControl = false,
  }) async {
    await _client.from('smart_led_settings').upsert(
      smartLedStripPayload(deviceId, strip),
      onConflict: 'device_id,led_index',
    );
  }

  @override
  Future<List<SmartLedTrigger>> getTriggers(String deviceId) async {
    final rows = await _client
        .from('smart_led_triggers')
        .select()
        .eq('device_id', deviceId)
        .order('parameter_index');

    if (rows.isEmpty) return defaultSmartLedTriggers();

    final byIndex = {
      for (final row in rows)
        row['parameter_index'] as int: mapSmartLedTrigger(row),
    };

    return List.generate(
      10,
      (i) => byIndex[i] ?? SmartLedTrigger(parameterIndex: i),
    );
  }

  @override
  Future<List<SmartLedTrigger>> getActiveTriggers(String deviceId) async {
    final rows = await _client
        .from('smart_led_triggers')
        .select()
        .eq('device_id', deviceId)
        .eq('active', 1)
        .order('parameter_index');

    return [for (final row in rows) mapSmartLedTrigger(row)];
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
    final userId = requireUserId(_client);
    await _client.from('smart_led_triggers').upsert(
      smartLedTriggerPayload(deviceId, userId, trigger),
      onConflict: 'device_id,parameter_index',
    );
  }

  @override
  Future<void> deactivateTrigger(
    String deviceId,
    int parameterIndex,
  ) async {
    final userId = requireUserId(_client);
    await _client.from('smart_led_triggers').upsert(
      {
        'device_id': deviceId,
        'user_id': userId,
        'parameter_index': parameterIndex,
        'active': 0,
      },
      onConflict: 'device_id,parameter_index',
    );
  }
}

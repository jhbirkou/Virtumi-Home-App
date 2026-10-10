import '../models/smart_led_strip.dart';
import '../models/smart_led_trigger.dart';

abstract interface class SmartLedRepository {
  Future<List<SmartLedStrip>> getStrips(String deviceId);

  /// [quickControl] skips full strip config fields and, in direct/UDP mode,
  /// sends fire-and-forget so the UI is not blocked waiting for an ACK.
  Future<void> saveStrip(
    String deviceId,
    SmartLedStrip strip, {
    bool quickControl = false,
  });

  Future<List<SmartLedTrigger>> getTriggers(String deviceId);
  Future<List<SmartLedTrigger>> getActiveTriggers(String deviceId);
  Future<int?> nextFreeTriggerIndex(String deviceId);
  Future<void> saveTrigger(String deviceId, SmartLedTrigger trigger);
  Future<void> deactivateTrigger(String deviceId, int parameterIndex);
}

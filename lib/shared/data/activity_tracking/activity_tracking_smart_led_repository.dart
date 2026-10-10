import '../../domain/smart_led_repository.dart';
import '../../models/smart_led_strip.dart';
import '../../models/smart_led_trigger.dart';
import 'activity_tracking_smart_home_repository.dart';

/// Records device actuation after successful [SmartLedRepository.saveStrip].
class ActivityTrackingSmartLedRepository implements SmartLedRepository {
  ActivityTrackingSmartLedRepository(this._inner, this._onActivity);

  final SmartLedRepository _inner;
  final DeviceActivityCallback _onActivity;

  @override
  Future<List<SmartLedStrip>> getStrips(String deviceId) =>
      _inner.getStrips(deviceId);

  @override
  Future<void> saveStrip(
    String deviceId,
    SmartLedStrip strip, {
    bool quickControl = false,
  }) async {
    await _inner.saveStrip(deviceId, strip, quickControl: quickControl);
    _onActivity(deviceId);
  }

  @override
  Future<List<SmartLedTrigger>> getTriggers(String deviceId) =>
      _inner.getTriggers(deviceId);

  @override
  Future<List<SmartLedTrigger>> getActiveTriggers(String deviceId) =>
      _inner.getActiveTriggers(deviceId);

  @override
  Future<int?> nextFreeTriggerIndex(String deviceId) =>
      _inner.nextFreeTriggerIndex(deviceId);

  @override
  Future<void> saveTrigger(String deviceId, SmartLedTrigger trigger) =>
      _inner.saveTrigger(deviceId, trigger);

  @override
  Future<void> deactivateTrigger(String deviceId, int parameterIndex) =>
      _inner.deactivateTrigger(deviceId, parameterIndex);
}

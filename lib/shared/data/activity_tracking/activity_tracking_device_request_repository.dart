import '../../domain/device_request_repository.dart';
import 'activity_tracking_smart_home_repository.dart';

/// Records device actuation after successful [DeviceRequestRepository.sendButtonPress].
class ActivityTrackingDeviceRequestRepository implements DeviceRequestRepository {
  ActivityTrackingDeviceRequestRepository(this._inner, this._onActivity);

  final DeviceRequestRepository _inner;
  final DeviceActivityCallback _onActivity;

  @override
  Future<void> sendButtonPress(String deviceId, int command) async {
    await _inner.sendButtonPress(deviceId, command);
    _onActivity(deviceId);
  }

  @override
  Future<void> sendMatterPairingRequest(String deviceId) =>
      _inner.sendMatterPairingRequest(deviceId);

  @override
  Future<void> sendUpdateRequest(String deviceId) =>
      _inner.sendUpdateRequest(deviceId);

  @override
  Future<void> requestPasswordChange({
    required String deviceId,
    required String currentCode,
    required String newCode,
  }) =>
      _inner.requestPasswordChange(
        deviceId: deviceId,
        currentCode: currentCode,
        newCode: newCode,
      );

  @override
  Future<String?> pollRequestStatus({
    required String table,
    required String deviceId,
    Duration timeout = const Duration(seconds: 30),
    Duration interval = const Duration(seconds: 2),
  }) =>
      _inner.pollRequestStatus(
        table: table,
        deviceId: deviceId,
        timeout: timeout,
        interval: interval,
      );
}

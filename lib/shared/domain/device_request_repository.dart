/// Cloud request actions from app to ESP32 via Supabase polling tables.
abstract interface class DeviceRequestRepository {
  Future<void> sendButtonPress(String deviceId, int command);

  Future<void> sendMatterPairingRequest(String deviceId);

  Future<void> sendUpdateRequest(String deviceId);

  Future<void> requestPasswordChange({
    required String deviceId,
    required String currentCode,
    required String newCode,
  });

  Future<String?> pollRequestStatus({
    required String table,
    required String deviceId,
    Duration timeout = const Duration(seconds: 30),
    Duration interval = const Duration(seconds: 2),
  });
}

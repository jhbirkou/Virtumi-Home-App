import 'package:flutter/widgets.dart';

/// Raw sensor JSON row from [device_data].
@immutable
class DeviceDataEntry {
  const DeviceDataEntry({
    required this.id,
    required this.receivedAt,
    this.data = const {},
  });

  final String id;
  final DateTime receivedAt;
  final Map<String, dynamic> data;
}

/// OTA/update progress from [device_update_status].
@immutable
class DeviceUpdateStatus {
  const DeviceUpdateStatus({
    this.status = 'idle',
    this.errorMessage,
    this.lastUpdateRequest,
  });

  final String status;
  final String? errorMessage;
  final DateTime? lastUpdateRequest;

  bool get isUpdating =>
      status == 'pending' || status == 'updating';
}

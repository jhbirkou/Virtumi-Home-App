import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/device_data_repository.dart';
import '../../models/device_data_entry.dart';
import 'mappers/extended_mappers.dart';

class SupabaseDeviceDataRepository implements DeviceDataRepository {
  SupabaseDeviceDataRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<DeviceDataEntry>> getDeviceData(String deviceId) async {
    final rows = await _client
        .from('device_data')
        .select()
        .eq('device_id', deviceId)
        .order('received_at', ascending: false);

    return rows.map((row) => mapDeviceDataEntry(row)).toList();
  }

  @override
  Future<void> deleteDeviceData(String entryId) async {
    await _client.from('device_data').delete().eq('id', entryId);
  }

  @override
  Future<void> deleteAllDeviceData(String deviceId) async {
    await _client.from('device_data').delete().eq('device_id', deviceId);
  }

  @override
  Future<DeviceUpdateStatus> getUpdateStatus(String deviceId) async {
    final row = await _client
        .from('device_update_status')
        .select()
        .eq('device_id', deviceId)
        .maybeSingle();

    return mapDeviceUpdateStatus(row);
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';

/// Subscribes to Postgres changes for a device table.
class RealtimeService {
  RealtimeService(this._client);

  final SupabaseClient _client;
  final _channels = <String, RealtimeChannel>{};

  void subscribeToDeviceTable({
    required String deviceId,
    required String table,
    required void Function() onChange,
  }) {
    final key = '$table-$deviceId';
    _channels[key]?.unsubscribe();

    final channel = _client
        .channel('device-$deviceId-$table')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: table,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'device_id',
            value: deviceId,
          ),
          callback: (_) => onChange(),
        )
        .subscribe();

    _channels[key] = channel;
  }

  void unsubscribeAll() {
    for (final channel in _channels.values) {
      channel.unsubscribe();
    }
    _channels.clear();
  }
}

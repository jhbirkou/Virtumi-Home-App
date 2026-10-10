import 'package:supabase_flutter/supabase_flutter.dart';

int boolToInt(bool value) => value ? 1 : 0;

bool intToBool(int? value) => value == 1;

String? currentUserId(SupabaseClient client) => client.auth.currentUser?.id;

String requireUserId(SupabaseClient client) {
  final id = currentUserId(client);
  if (id == null) {
    throw const AuthException('Nicht angemeldet');
  }
  return id;
}

bool isSyntheticId(String id) => id.startsWith('syn:');

String syntheticHomeId(String homeName) => 'syn:home:${homeName.trim()}';

String syntheticFloorId(String homeName, String floorName) =>
    'syn:floor:${homeName.trim()}:${floorName.trim()}';

String syntheticRoomId(String homeName, String floorName, String roomName) =>
    'syn:room:${homeName.trim()}:${floorName.trim()}:${roomName.trim()}';

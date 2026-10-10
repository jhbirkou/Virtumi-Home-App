import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/connection_mode_provider.dart';

/// Returns false in direct/UDP mode — Supabase Realtime is not used then.
bool useSupabaseRealtime(WidgetRef ref) {
  return !ref.read(isDirectConnectionProvider);
}

/// Same check for [Ref] (providers, not widgets).
bool useSupabaseRealtimeRef(Ref ref) {
  return !ref.read(isDirectConnectionProvider);
}

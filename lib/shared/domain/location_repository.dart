import '../models/models.dart';

/// Provides access to the searchable location database.
abstract interface class LocationRepository {
  /// All known locations (loaded once and cached).
  Future<List<Location>> getLocations();

  /// Locations whose city/country/code match [query] (case-insensitive).
  Future<List<Location>> search(String query, {int limit = 30});
}

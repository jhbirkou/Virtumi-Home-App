import 'package:flutter/services.dart' show rootBundle;

import '../domain/location_repository.dart';
import '../models/models.dart';

/// Loads the bundled `location_database.csv` asset and caches the parsed list.
class CsvLocationRepository implements LocationRepository {
  CsvLocationRepository({this.assetPath = 'assets/data/location_database.csv'});

  final String assetPath;

  List<Location>? _cache;

  @override
  Future<List<Location>> getLocations() async {
    final cached = _cache;
    if (cached != null) return cached;

    final raw = await rootBundle.loadString(assetPath);
    final lines = raw.split(RegExp(r'\r?\n'));
    final result = <Location>[];

    // Skip the header row (index 0).
    for (var i = 1; i < lines.length; i++) {
      final line = lines[i];
      if (line.trim().isEmpty) continue;
      final fields = _parseCsvLine(line);
      if (fields.length < 6) continue;
      result.add(
        Location(
          city: fields[0],
          country: fields[1],
          countryCode: fields[2],
          latitude: double.tryParse(fields[3]) ?? 0,
          longitude: double.tryParse(fields[4]) ?? 0,
          timezone: fields[5],
        ),
      );
    }

    _cache = result;
    return result;
  }

  @override
  Future<List<Location>> search(String query, {int limit = 30}) async {
    final all = await getLocations();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all.take(limit).toList();

    final matches = all.where((l) => l.searchKey.contains(q)).toList()
      ..sort((a, b) {
        // Prefer matches at the start of the city name.
        final aStarts = a.city.toLowerCase().startsWith(q) ? 0 : 1;
        final bStarts = b.city.toLowerCase().startsWith(q) ? 0 : 1;
        if (aStarts != bStarts) return aStarts - bStarts;
        return a.city.compareTo(b.city);
      });
    return matches.take(limit).toList();
  }

  /// Minimal CSV field parser that respects double-quoted fields (which may
  /// contain commas, e.g. the POSIX timezone string).
  List<String> _parseCsvLine(String line) {
    final fields = <String>[];
    final buffer = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          buffer.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        fields.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }
    fields.add(buffer.toString());
    return fields.map((f) => f.trim()).toList();
  }
}

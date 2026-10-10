import 'package:flutter/widgets.dart';

/// A searchable geographic location with its POSIX timezone string, sourced
/// from the bundled location database.
@immutable
class Location {
  const Location({
    required this.city,
    required this.country,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  final String city;
  final String country;
  final String countryCode;
  final double latitude;
  final double longitude;

  /// POSIX TZ string, e.g. "CET-1CEST,M3.5.0,M10.5.0/3".
  final String timezone;

  /// Human-readable label shown in the UI ("Stadt, Land").
  String get label => '$city, $country';

  /// Lowercased haystack used for search matching.
  String get searchKey => '$city $country $countryCode'.toLowerCase();
}

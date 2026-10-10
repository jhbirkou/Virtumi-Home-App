import 'package:flutter/widgets.dart';

/// A small pill badge shown on a user profile (e.g. "Besitzer", "Pro Plan").
@immutable
class UserBadge {
  const UserBadge({required this.label, required this.accentKey});
  final String label;
  final String accentKey;
}

/// The app user / account.
@immutable
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.avatarUrl,
    this.isOnline = true,
    this.badges = const [],
    this.phone = '',
    this.addressStreet = '',
    this.addressPostalCode = '',
    this.addressCity = '',
    this.addressCountry = 'Deutschland',
  });

  final String id;
  final String name;
  final String email;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final bool isOnline;
  final List<UserBadge> badges;
  final String phone;
  final String addressStreet;
  final String addressPostalCode;
  final String addressCity;
  final String addressCountry;

  String get displayName {
    final combined = '$firstName $lastName'.trim();
    if (combined.isNotEmpty) return combined;
    return name.trim();
  }

  String get fullAddress {
    final parts = [
      addressStreet.trim(),
      '${addressPostalCode.trim()} ${addressCity.trim()}'.trim(),
      addressCountry.trim(),
    ].where((p) => p.isNotEmpty);
    return parts.join(', ');
  }

  String get initials {
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  User copyWith({
    String? name,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? avatarUrl,
    String? addressStreet,
    String? addressPostalCode,
    String? addressCity,
    String? addressCountry,
  }) =>
      User(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        isOnline: isOnline,
        badges: badges,
        phone: phone ?? this.phone,
        addressStreet: addressStreet ?? this.addressStreet,
        addressPostalCode: addressPostalCode ?? this.addressPostalCode,
        addressCity: addressCity ?? this.addressCity,
        addressCountry: addressCountry ?? this.addressCountry,
      );
}

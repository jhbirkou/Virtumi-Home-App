import 'package:flutter/foundation.dart';

UserProfileFields profileFieldsFromRow(Map<String, dynamic> row) {
  return UserProfileFields(
    firstName: row['first_name'] as String? ?? '',
    lastName: row['last_name'] as String? ?? '',
    phone: row['phone'] as String? ?? '',
    addressStreet: row['address_street'] as String? ?? '',
    addressPostalCode: row['address_postal_code'] as String? ?? '',
    addressCity: row['address_city'] as String? ?? '',
    addressCountry: row['address_country'] as String? ?? 'Deutschland',
    avatarUrl: row['avatar_url'] as String?,
  );
}

Map<String, dynamic> profileFieldsToRow(String userId, UserProfileFields fields) {
  return {
    'user_id': userId,
    'first_name': fields.firstName,
    'last_name': fields.lastName,
    'phone': fields.phone,
    'address_street': fields.addressStreet,
    'address_postal_code': fields.addressPostalCode,
    'address_city': fields.addressCity,
    'address_country': fields.addressCountry,
    'avatar_url': fields.avatarUrl,
  };
}

/// Editable profile fields stored in [user_profiles].
@immutable
class UserProfileFields {
  const UserProfileFields({
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.addressStreet = '',
    this.addressPostalCode = '',
    this.addressCity = '',
    this.addressCountry = 'Deutschland',
    this.avatarUrl,
  });

  final String firstName;
  final String lastName;
  final String phone;
  final String addressStreet;
  final String addressPostalCode;
  final String addressCity;
  final String addressCountry;
  final String? avatarUrl;

  String get fullAddress {
    final parts = [
      addressStreet.trim(),
      '${addressPostalCode.trim()} ${addressCity.trim()}'.trim(),
      addressCountry.trim(),
    ].where((p) => p.isNotEmpty);
    return parts.join(', ');
  }

  UserProfileFields copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? addressStreet,
    String? addressPostalCode,
    String? addressCity,
    String? addressCountry,
    String? avatarUrl,
  }) {
    return UserProfileFields(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      addressStreet: addressStreet ?? this.addressStreet,
      addressPostalCode: addressPostalCode ?? this.addressPostalCode,
      addressCity: addressCity ?? this.addressCity,
      addressCountry: addressCountry ?? this.addressCountry,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

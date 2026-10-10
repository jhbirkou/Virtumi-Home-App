import 'package:flutter/foundation.dart';

import '../../../models/app_settings.dart';

AppSettings appSettingsFromRow(Map<String, dynamic> row) {
  return AppSettings(
    userId: row['user_id'] as String,
    darkMode: row['dark_mode'] as bool? ?? false,
    language: row['language'] as String? ?? 'de',
    biometricEnabled: row['biometric_enabled'] as bool? ?? false,
    pinEnabled: row['pin_enabled'] as bool? ?? false,
    twoFactorEnabled: row['two_factor_enabled'] as bool? ?? false,
    connectionMode: row['connection_mode'] as String? ?? 'cloud',
    startRoute: row['start_route'] as String? ?? '/home',
  );
}

Map<String, dynamic> appSettingsToRow(
  AppSettings settings, {
  bool includeStartRoute = true,
}) {
  return {
    'user_id': settings.userId,
    'dark_mode': settings.darkMode,
    'language': settings.language,
    'biometric_enabled': settings.biometricEnabled,
    'pin_enabled': settings.pinEnabled,
    'two_factor_enabled': settings.twoFactorEnabled,
    'connection_mode': settings.connectionMode,
    if (includeStartRoute) 'start_route': settings.startRoute,
  };
}

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

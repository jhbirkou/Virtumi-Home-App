import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../domain/user_repository.dart';
import '../../models/user.dart';
import '../../../core/utils/avatar_url_utils.dart';
import 'mappers/user_mappers.dart';

class SupabaseUserRepository implements UserRepository {
  SupabaseUserRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<User> getCurrentUser() async {
    final authUser = _client.auth.currentUser;
    if (authUser == null) {
      throw const AuthException('Nicht angemeldet');
    }

    final profileRow = await _client
        .from('user_profiles')
        .select()
        .eq('user_id', authUser.id)
        .maybeSingle();

    final profile = profileRow != null
        ? profileFieldsFromRow(profileRow)
        : const UserProfileFields();

    final metadata = authUser.userMetadata ?? {};
    final fallbackName = (metadata['full_name'] as String?) ??
        (metadata['name'] as String?) ??
        authUser.email?.split('@').first ??
        'Benutzer';

    final firstName = profile.firstName.isNotEmpty
        ? profile.firstName
        : _splitName(fallbackName).$1;
    final lastName = profile.lastName.isNotEmpty
        ? profile.lastName
        : _splitName(fallbackName).$2;

    return User(
      id: authUser.id,
      name: '$firstName $lastName'.trim().isEmpty ? fallbackName : '$firstName $lastName'.trim(),
      email: authUser.email ?? '',
      firstName: firstName,
      lastName: lastName,
      avatarUrl: profile.avatarUrl ?? metadata['avatar_url'] as String?,
      phone: profile.phone,
      addressStreet: profile.addressStreet,
      addressPostalCode: profile.addressPostalCode,
      addressCity: profile.addressCity,
      addressCountry: profile.addressCountry,
    );
  }

  @override
  Future<void> updateUser(User user) async {
    await _client.from('user_profiles').upsert(
          profileFieldsToRow(
            user.id,
            UserProfileFields(
              firstName: user.firstName,
              lastName: user.lastName,
              phone: user.phone,
              addressStreet: user.addressStreet,
              addressPostalCode: user.addressPostalCode,
              addressCity: user.addressCity,
              addressCountry: user.addressCountry,
              avatarUrl: user.avatarUrl,
            ),
          ),
        );

    await _client.auth.updateUser(
      UserAttributes(
        data: {
          'full_name': user.displayName,
          if (user.phone.isNotEmpty) 'phone': user.phone,
          if (user.avatarUrl != null) 'avatar_url': user.avatarUrl,
        },
        email: user.email != (_client.auth.currentUser?.email ?? '')
            ? user.email
            : null,
      ),
    );
  }

  @override
  Future<String> uploadAvatar(String userId, Uint8List bytes, String fileExt) async {
    final path = '$userId/avatar.$fileExt';
    await _client.storage.from('avatars').uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: _mimeForExt(fileExt),
          ),
        );
    return avatarUrlWithCacheBuster(
      _client.storage.from('avatars').getPublicUrl(path),
    );
  }

  (String, String) _splitName(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return ('', '');
    if (parts.length == 1) return (parts.first, '');
    return (parts.first, parts.sublist(1).join(' '));
  }

  String _mimeForExt(String ext) => switch (ext.toLowerCase()) {
        'png' => 'image/png',
        'webp' => 'image/webp',
        _ => 'image/jpeg',
      };
}

import 'dart:typed_data';

import '../models/models.dart';

/// Abstraction over the current user / account data.
abstract interface class UserRepository {
  Future<User> getCurrentUser();
  Future<void> updateUser(User user);
  Future<String> uploadAvatar(String userId, Uint8List bytes, String fileExt);
}

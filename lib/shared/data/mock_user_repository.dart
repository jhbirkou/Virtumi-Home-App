import 'dart:typed_data';

import '../domain/user_repository.dart';
import '../models/user.dart';
import 'mock_seed.dart';

/// In-memory [UserRepository] backed by [MockStore].
class MockUserRepository implements UserRepository {
  MockUserRepository(MockStore store) : _current = store.user;

  User _current;

  @override
  Future<User> getCurrentUser() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _current;
  }

  @override
  Future<void> updateUser(User user) async {
    _current = user;
  }

  @override
  Future<String> uploadAvatar(String userId, Uint8List bytes, String fileExt) async {
    return 'https://example.com/avatar.$fileExt';
  }
}

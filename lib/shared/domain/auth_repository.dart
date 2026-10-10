import 'package:supabase_flutter/supabase_flutter.dart';

/// Abstraction over Supabase Auth (email/password).
abstract interface class AuthRepository {
  Stream<AuthState> authStateChanges();

  Session? get currentSession;

  Future<void> signIn({required String email, required String password});

  Future<void> signUp({required String email, required String password});

  Future<void> signOut();
}

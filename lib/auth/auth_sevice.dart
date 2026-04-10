import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // - Sign up a new user with email and password
  Future<void> signUp(String username, String email, String password) async {
    await _supabase.auth.signUp(
      data: {
        'username': username,
      },
      email: email,
      password: password,
    );
  }

  // - Sign in an existing user with email and password
  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // - Sign out the current user
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  String? getCurrentEmail() {
    final sesion = _supabase.auth.currentSession;
    final user = sesion?.user;
    return user?.email;
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_user.dart';

class AuthController extends Notifier<AuthUser?> {
  @override
  AuthUser? build() {
    return null; // Initially not logged in
  }

  Future<bool> login(String username, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Hardcoded mock authentication
    if (username == 'admin' && password == 'admin') {
      state = AuthUser(
        id: 'admin_1',
        username: 'Sistem Yöneticisi',
        role: 'admin',
      );
      return true;
    } else if (username == 'cari' && password == '1234') {
      state = AuthUser(
        id: 'cari_1001',
        username: 'Netsim Örnek Cari',
        role: 'customer',
        cariKodu: 'M-1001',
      );
      return true;
    }
    
    // Login failed
    return false;
  }

  void logout() {
    state = null;
  }
}

final authProvider = NotifierProvider<AuthController, AuthUser?>(() {
  return AuthController();
});

class AuthUser {
  final String id;
  final String username;
  final String role; // 'admin' or 'customer'
  final String? cariKodu; // Only if customer

  AuthUser({
    required this.id,
    required this.username,
    required this.role,
    this.cariKodu,
  });
}

class CustomerBalance {
  final double totalDebit; // Toplam Borç
  final double totalCredit; // Toplam Alacak/Ödenen
  
  double get netBalance => totalDebit - totalCredit; // Kalan Net Borç

  CustomerBalance({
    required this.totalDebit,
    required this.totalCredit,
  });
}

class Customer {
  final int id;
  final String name;
  final String email;
  final CustomerBalance balance;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['CARI_NO'] ?? 0,
      name: json['CARI_ADI']?.toString() ?? 'Bilinmeyen Cari',
      email: json['EMAIL']?.toString() ?? 'email@yok.com',
      balance: CustomerBalance(
        totalDebit: (json['TOPLAM_BORC'] ?? 0).toDouble(),
        totalCredit: (json['TOPLAM_ALACAK'] ?? 0).toDouble(),
      ),
    );
  }
}

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
}

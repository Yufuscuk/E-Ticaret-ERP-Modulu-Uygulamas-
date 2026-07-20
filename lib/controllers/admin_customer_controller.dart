import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/customer.dart';

class AdminCustomerController extends Notifier<AsyncValue<List<Customer>>> {
  @override
  AsyncValue<List<Customer>> build() {
    fetchCustomers();
    return const AsyncValue.loading();
  }

  Future<void> fetchCustomers() async {
    try {
      state = const AsyncValue.loading();
      await Future.delayed(const Duration(milliseconds: 800)); // Simüle edilmiş bekleme

      // Mock Müşteri (Cari) Listesi
      final List<Customer> mockCustomers = [
        Customer(
          id: 1,
          name: 'Ahmet Yılmaz',
          email: 'ahmet@example.com',
          balance: CustomerBalance(totalDebit: 15000.0, totalCredit: 5000.0),
        ),
        Customer(
          id: 2,
          name: 'Mehmet Demir',
          email: 'mehmet.demir@firma.com',
          balance: CustomerBalance(totalDebit: 25000.0, totalCredit: 25000.0),
        ),
        Customer(
          id: 3,
          name: 'Ayşe Kaya (Toptan)',
          email: 'ayse@toptancim.net',
          balance: CustomerBalance(totalDebit: 42000.0, totalCredit: 12000.0),
        ),
        Customer(
          id: 4,
          name: 'Veli Gündüz',
          email: 'veli@veli.com',
          balance: CustomerBalance(totalDebit: 8000.0, totalCredit: 0.0),
        ),
      ];

      state = AsyncValue.data(mockCustomers);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final adminCustomerProvider = NotifierProvider<AdminCustomerController, AsyncValue<List<Customer>>>(() {
  return AdminCustomerController();
});

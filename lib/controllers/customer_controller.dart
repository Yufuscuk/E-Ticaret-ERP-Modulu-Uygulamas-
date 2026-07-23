import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/customer.dart';
import '../models/order.dart';

// Şimdilik Mock bir müşteri durumu yönetiyoruz.
class CustomerState {
  final Customer? customer;
  final List<Order> orderHistory;

  CustomerState({
    this.customer,
    this.orderHistory = const [],
  });

  CustomerState copyWith({
    Customer? customer,
    List<Order>? orderHistory,
  }) {
    return CustomerState(
      customer: customer ?? this.customer,
      orderHistory: orderHistory ?? this.orderHistory,
    );
  }
}

class CustomerController extends Notifier<AsyncValue<CustomerState>> {
  @override
  AsyncValue<CustomerState> build() {
    final mockCustomer = Customer(
      id: 1,
      name: 'Ahmet Yılmaz',
      email: 'ahmet@example.com',
      balance: CustomerBalance(
        totalDebit: 15000.0,
        totalCredit: 5000.0,
      ),
    );

    return AsyncValue.data(CustomerState(
      customer: mockCustomer,
      orderHistory: [],
    ));
  }

  Future<void> fetchCustomerData() async {
    // API entegrasyonu gelene kadar bu metod mock data dönecek.
    // Build metodunda senkron döndüğümüz için burası şu an sadece refresh için kullanılabilir.
  }

  // Sipariş verildiğinde cariye borç ekleyen metod
  void addOrderToHistory(Order order) {
    if (state.value == null) return;
    
    final currentData = state.value!;
    final currentCustomer = currentData.customer!;
    
    // Yeni bakiyeyi hesapla
    final newBalance = CustomerBalance(
      totalDebit: currentCustomer.balance.totalDebit + order.totalAmount,
      totalCredit: currentCustomer.balance.totalCredit,
    );
    
    final updatedCustomer = Customer(
      id: currentCustomer.id,
      name: currentCustomer.name,
      email: currentCustomer.email,
      balance: newBalance,
    );

    state = AsyncValue.data(currentData.copyWith(
      customer: updatedCustomer,
      orderHistory: [order, ...currentData.orderHistory],
    ));
  }
}

final customerProvider = NotifierProvider<CustomerController, AsyncValue<CustomerState>>(() {
  return CustomerController();
});

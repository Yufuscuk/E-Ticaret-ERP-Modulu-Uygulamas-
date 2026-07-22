import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/customer.dart';
import '../services/api_service.dart';

class AdminCustomerController extends Notifier<AsyncValue<List<Customer>>> {
  @override
  AsyncValue<List<Customer>> build() {
    fetchCustomers();
    return const AsyncValue.loading();
  }

  Future<void> fetchCustomers() async {
    try {
      state = const AsyncValue.loading();
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.getRequest('customers');
      
      final List<dynamic> data = response.data;
      final List<Customer> apiCustomers = data.map((item) {
        return Customer.fromJson(item as Map<String, dynamic>);
      }).toList();

      state = AsyncValue.data(apiCustomers);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final adminCustomerProvider = NotifierProvider<AdminCustomerController, AsyncValue<List<Customer>>>(() {
  return AdminCustomerController();
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/admin_customer_controller.dart';

class AdminCustomerListView extends ConsumerWidget {
  const AdminCustomerListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersState = ref.watch(adminCustomerProvider);

    return Scaffold(
      body: customersState.when(
        data: (customers) {
          if (customers.isEmpty) {
            return const Center(child: Text('Hiç müşteri bulunamadı.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              final balance = customer.balance;
              final isDebt = balance.netBalance > 0;
              
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        radius: 24,
                        child: Text(
                          customer.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple, fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              customer.email,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            // Balance details
                            Row(
                              children: [
                                const Text('Net Bakiye: ', style: TextStyle(fontSize: 13)),
                                Text(
                                  '${balance.netBalance.abs().toStringAsFixed(2)} TL',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: isDebt ? Colors.red : Colors.green,
                                  ),
                                ),
                                if (isDebt)
                                  const Text(' (Borçlu)', style: TextStyle(color: Colors.red, fontSize: 12))
                                else if (balance.netBalance < 0)
                                  const Text(' (Alacaklı)', style: TextStyle(color: Colors.green, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Action buttons
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.receipt_long, color: Colors.blue),
                            tooltip: 'Hesap Özeti',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${customer.name} hesap özeti çok yakında eklenecek.')),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata: $err')),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/customer_controller.dart';

class CustomerView extends ConsumerWidget {
  const CustomerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerStateAsync = ref.watch(customerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Hesabım'),
      ),
      body: customerStateAsync.when(
        data: (state) {
          final customer = state.customer;
          if (customer == null) {
            return const Center(child: Text('Müşteri bilgisi bulunamadı.'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Cari Özet Kartı
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sn. ${customer.name}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Toplam Borç:', style: TextStyle(fontSize: 16)),
                              Text('${customer.balance.totalDebit} TL', style: const TextStyle(fontSize: 16, color: Colors.red)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Toplam Alacak/Ödenen:', style: TextStyle(fontSize: 16)),
                              Text('${customer.balance.totalCredit} TL', style: const TextStyle(fontSize: 16, color: Colors.green)),
                            ],
                          ),
                          const Divider(height: 24, thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Güncel Bakiye:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text(
                                '${customer.balance.netBalance} TL',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  const Text('Sipariş Geçmişim', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  
                  // Sipariş Listesi
                  if (state.orderHistory.isEmpty)
                    const Text('Henüz siparişiniz bulunmuyor.')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.orderHistory.length,
                      itemBuilder: (context, index) {
                        final order = state.orderHistory[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ExpansionTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.receipt_long, color: Colors.deepPurple),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Sipariş: ${order.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                Text('${order.totalAmount} TL', style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.deepPurple)),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text('${order.date.day}/${order.date.month}/${order.date.year} ${order.date.hour}:${order.date.minute.toString().padLeft(2, '0')}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            ),
                            // İkonları elle ayarlamayı bırakıyoruz ki varsayılan dönen ok (expand_more) çıksın.
                            childrenPadding: const EdgeInsets.only(bottom: 8),
                            children: order.items.map((item) {
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                                title: Text(item.product.name, style: const TextStyle(fontSize: 14)),
                                subtitle: Text('${item.quantity} adet x ${item.product.price} TL', style: const TextStyle(fontSize: 12)),
                                trailing: Text('${item.quantity * item.product.price} TL', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata: $err')),
      ),
    );
  }
}

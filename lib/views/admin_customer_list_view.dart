import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/admin_customer_controller.dart';
import '../models/customer.dart';

class AdminCustomerListView extends ConsumerStatefulWidget {
  const AdminCustomerListView({super.key});

  @override
  ConsumerState<AdminCustomerListView> createState() => _AdminCustomerListViewState();
}

class _AdminCustomerListViewState extends ConsumerState<AdminCustomerListView> {
  final TextEditingController _searchNameController = TextEditingController();
  String _searchNameQuery = '';

  @override
  void dispose() {
    _searchNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customersState = ref.watch(adminCustomerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tablo Başlıkları ve Arama Kutuları
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFEBE6F3),
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Cari Adı', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 36,
                          child: TextField(
                            controller: _searchNameController,
                            decoration: InputDecoration(
                              hintText: 'Ada göre ara...',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                            ),
                            onChanged: (value) => setState(() => _searchNameQuery = value),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    flex: 2,
                    child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    flex: 2,
                    child: Text('Toplam Borç', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                  ),
                  const Expanded(
                    flex: 2,
                    child: Text('Toplam Alacak', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                  ),
                  const Expanded(
                    flex: 2,
                    child: Text('Net Bakiye', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                  ),
                  const SizedBox(
                    width: 60,
                    child: Text('İşlemler', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                  ),
                ],
              ),
            ),

            // Liste
            Expanded(
              child: Container(
                color: Colors.white,
                child: customersState.when(
                  data: (customers) {
                    final filteredCustomers = customers.where((c) {
                      final nameQuery = _searchNameQuery.toLowerCase();
                      return c.name.toLowerCase().contains(nameQuery);
                    }).toList();

                    if (filteredCustomers.isEmpty) {
                      return const Center(child: Text('Cari bulunamadı.'));
                    }
                    
                    return ListView.builder(
                      itemCount: filteredCustomers.length,
                      itemBuilder: (context, index) {
                        final customer = filteredCustomers[index];
                        final balance = customer.balance;
                        final isDebt = balance.netBalance > 0;

                        return Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            child: Row(
                              children: [
                                // Cari Adı
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    customer.name, 
                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Email
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    customer.email, 
                                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Toplam Borç
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${balance.totalDebit.toStringAsFixed(2)} TL', 
                                    style: const TextStyle(color: Colors.red, fontSize: 13),
                                  ),
                                ),
                                // Toplam Alacak
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${balance.totalCredit.toStringAsFixed(2)} TL', 
                                    style: const TextStyle(color: Colors.green, fontSize: 13),
                                  ),
                                ),
                                // Net Bakiye
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${balance.netBalance.abs().toStringAsFixed(2)} TL', 
                                    style: TextStyle(
                                      color: isDebt ? Colors.red.shade700 : Colors.green.shade700, 
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 13
                                    ),
                                  ),
                                ),
                                // İşlemler
                                SizedBox(
                                  width: 60,
                                  child: IconButton(
                                    icon: const Icon(Icons.receipt_long, color: Colors.blue, size: 20),
                                    splashRadius: 20,
                                    tooltip: 'Hesap Özeti',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${customer.name} hesap özeti çok yakında eklenecek.')),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(color: Colors.deepPurple)),
                  error: (error, stack) => Center(child: Text('Hata: $error')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

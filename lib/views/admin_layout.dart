import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';
import 'admin_view.dart';
import 'admin_customer_list_view.dart';
import 'product_list_view.dart';

class AdminLayout extends ConsumerStatefulWidget {
  const AdminLayout({super.key});

  @override
  ConsumerState<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends ConsumerState<AdminLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdminView(), // Ürün ve Stok Yönetimi (İçerisinde kendi AppBar'ı yerine gövdesi kalacak)
    const AdminCustomerListView(), // Cari Takibi
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Admin: Stok Yönetimi' : 'Admin: Cari Takibi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.store),
            tooltip: 'Müşteri Görünümü',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductListView()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Çıkış Yap',
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Netsim Yönetim', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Yönetici Paneli', style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text('Ürün ve Stok Yönetimi'),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context); // Çekmeceyi kapat
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_alt),
              title: const Text('Cari (Müşteri) Takibi'),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context); // Çekmeceyi kapat
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Çıkış Yap', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () {
                ref.read(authProvider.notifier).logout();
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import 'cart_view.dart';
import 'customer_view.dart';
import 'admin_view.dart';
import 'product_detail_view.dart';

class ProductListView extends ConsumerStatefulWidget {
  const ProductListView({super.key});

  @override
  ConsumerState<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends ConsumerState<ProductListView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productProvider);
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    // Sepetteki toplam ürün miktarı
    final cartItemCount = cartItems.fold(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürünler (Netsim N4 Mock)'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartView()),
                  );
                },
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text('Netsim E-Ticaret', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Cari Hesabım'),
              onTap: () {
                Navigator.pop(context); // Çekmeceyi kapat
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerView()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Admin Paneli'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminView()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Ürün adı veya kodu ara...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: productsState.when(
              data: (products) {
                final filteredProducts = products.where((p) {
                  final query = _searchQuery.toLowerCase();
                  return p.name.toLowerCase().contains(query) || p.code.toLowerCase().contains(query);
                }).toList();

                if (filteredProducts.isEmpty) {
                  return const Center(child: Text('Aradığınız kriterlere uygun ürün bulunamadı.'));
                }
                return ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    final isOutOfStock = product.stockQuantity <= 0;
                    
                    // Sepetteki ürün miktarını bul
                    final cartItemIndex = cartItems.indexWhere((item) => item.product.id == product.id);
                    final quantityInCart = cartItemIndex >= 0 ? cartItems[cartItemIndex].quantity : 0;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Kod: ${product.code} | Stok: ${product.stockQuantity}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${product.price} TL', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            if (isOutOfStock && quantityInCart == 0)
                              const Text('Stokta Yok', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold))
                            else if (quantityInCart == 0)
                              InkWell(
                                onTap: () {
                                  cartNotifier.addToCart(product);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(6)),
                                  child: const Text('Ekle', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              )
                            else
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () => cartNotifier.removeFromCart(product),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4)),
                                      child: const Icon(Icons.remove, size: 16, color: Colors.red),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('$quantityInCart', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  ),
                                  InkWell(
                                    onTap: quantityInCart >= product.stockQuantity ? null : () => cartNotifier.addToCart(product),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: quantityInCart >= product.stockQuantity ? Colors.grey.shade200 : Colors.green.shade50, 
                                        borderRadius: BorderRadius.circular(4)
                                      ),
                                      child: Icon(Icons.add, size: 16, color: quantityInCart >= product.stockQuantity ? Colors.grey : Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProductDetailView(product: product)),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Hata: $error')),
            ),
          ),
        ],
      ),
    );
  }
}

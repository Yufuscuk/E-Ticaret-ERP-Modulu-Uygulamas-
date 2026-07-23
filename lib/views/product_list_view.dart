import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/auth_controller.dart';
import 'cart_view.dart';
import 'customer_view.dart';
import 'product_detail_view.dart';

class ProductListView extends ConsumerStatefulWidget {
  const ProductListView({super.key});

  @override
  ConsumerState<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends ConsumerState<ProductListView> {
  final TextEditingController _searchNameController = TextEditingController();
  final TextEditingController _searchCodeController = TextEditingController();
  String _searchNameQuery = '';
  String _searchCodeQuery = '';

  @override
  void dispose() {
    _searchNameController.dispose();
    _searchCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productProvider);
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final authUser = ref.watch(authProvider);

    // Sepetteki toplam ürün miktarı
    final cartItemCount = cartItems.fold(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Ürünler (Netsim N4 Mock)', style: TextStyle(color: Colors.black54)),
        backgroundColor: const Color(0xFFEBE6F3),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.black54),
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
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
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
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFEBE6F3)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Netsim B2B', style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (authUser != null)
                    Text('Hoşgeldin, ${authUser.username}', style: const TextStyle(color: Colors.black54, fontSize: 14)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Cari Hesabım'),
              onTap: () {
                Navigator.pop(context); // Çekmeceyi kapat
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerView()));
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
                        const Text('Ürün Adı', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
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
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Stok Kodu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 36,
                          child: TextField(
                            controller: _searchCodeController,
                            decoration: InputDecoration(
                              hintText: 'Koda göre ara...',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                            ),
                            onChanged: (value) => setState(() => _searchCodeQuery = value),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    flex: 2,
                    child: Text('Stok', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                  ),
                  const Expanded(
                    flex: 2,
                    child: Text('Fiyat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                  ),
                  const SizedBox(
                    width: 100,
                    child: Text('Sepet İşlemi', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
                  ),
                ],
              ),
            ),
            
            // Liste
            Expanded(
              child: Container(
                color: Colors.white,
                child: productsState.when(
                  data: (products) {
                    final filteredProducts = products.where((p) {
                      final nameQuery = _searchNameQuery.toLowerCase();
                      final codeQuery = _searchCodeQuery.toLowerCase();
                      return p.name.toLowerCase().contains(nameQuery) && p.code.toLowerCase().contains(codeQuery);
                    }).toList();

                    if (filteredProducts.isEmpty) {
                      return const Center(child: Text('Ürün bulunamadı.'));
                    }
                    
                    return ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        final isOutOfStock = product.stockQuantity <= 0;
                        
                        // Sepetteki ürün miktarını bul
                        final cartItemIndex = cartItems.indexWhere((item) => item.product.id == product.id);
                        final quantityInCart = cartItemIndex >= 0 ? cartItems[cartItemIndex].quantity : 0;

                        return Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            child: Row(
                              children: [
                                // Ürün Adı
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    product.name, 
                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Stok Kodu
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    product.code, 
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Stok Miktarı
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isOutOfStock ? const Color(0xFFFFEBEE) : const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${product.stockQuantity} Adet', 
                                      style: TextStyle(
                                        color: isOutOfStock ? Colors.red.shade700 : Colors.green.shade700,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                // Fiyat
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${product.price.toStringAsFixed(2)} TL', 
                                    style: const TextStyle(
                                      color: Colors.deepPurple, 
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 13
                                    ),
                                  ),
                                ),
                                // İşlemler
                                SizedBox(
                                  width: 100,
                                  child: (isOutOfStock && quantityInCart == 0)
                                    ? const Center(child: Text('Stokta Yok', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)))
                                    : (quantityInCart == 0)
                                      ? Center(
                                          child: InkWell(
                                            onTap: () => cartNotifier.addToCart(product),
                                            borderRadius: BorderRadius.circular(6),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                                              decoration: BoxDecoration(
                                                color: Colors.deepPurple,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: const Text('Ekle', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.deepPurple.shade50,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: Colors.deepPurple.shade100)
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () => cartNotifier.removeFromCart(product),
                                                child: Container(
                                                  padding: const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                                                  child: const Icon(Icons.remove, size: 12, color: Colors.deepPurple),
                                                ),
                                              ),
                                              Text('$quantityInCart', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.deepPurple)),
                                              InkWell(
                                                onTap: quantityInCart >= product.stockQuantity ? null : () => cartNotifier.addToCart(product),
                                                child: Container(
                                                  padding: const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color: quantityInCart >= product.stockQuantity ? Colors.grey.shade200 : Colors.deepPurple, 
                                                    borderRadius: BorderRadius.circular(4)
                                                  ),
                                                  child: Icon(Icons.add, size: 12, color: quantityInCart >= product.stockQuantity ? Colors.grey : Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
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

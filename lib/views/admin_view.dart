import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';

class AdminView extends ConsumerStatefulWidget {
  const AdminView({super.key});

  @override
  ConsumerState<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends ConsumerState<AdminView> {
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

  void _showAddEditDialog(BuildContext context, WidgetRef ref, {Product? product}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final codeController = TextEditingController(text: product?.code ?? '');
    final priceController = TextEditingController(text: product?.price.toString() ?? '');
    final stockController = TextEditingController(text: product?.stockQuantity.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(product == null ? 'Yeni Ürün Ekle' : 'Ürün Düzenle', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController, 
                  decoration: InputDecoration(
                    labelText: 'Ürün Adı',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  )
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: codeController, 
                  decoration: InputDecoration(
                    labelText: 'Stok Kodu',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  )
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController, 
                  keyboardType: TextInputType.number, 
                  decoration: InputDecoration(
                    labelText: 'Fiyat (TL)',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  )
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stockController, 
                  keyboardType: TextInputType.number, 
                  decoration: InputDecoration(
                    labelText: 'Stok Miktarı',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  )
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
              ),
              onPressed: () {
                final newProduct = Product(
                  id: product?.id ?? DateTime.now().millisecondsSinceEpoch,
                  name: nameController.text,
                  code: codeController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  stockQuantity: int.tryParse(stockController.text) ?? 0,
                );

                if (product == null) {
                  ref.read(productProvider.notifier).addProduct(newProduct);
                } else {
                  ref.read(productProvider.notifier).updateProduct(newProduct);
                }
                Navigator.pop(context);
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => _showAddEditDialog(context, ref),
        child: const Icon(Icons.add, color: Colors.white),
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
                    child: Text('İşlemler', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54)),
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.deepPurple, size: 20),
                                        splashRadius: 20,
                                        onPressed: () => _showAddEditDialog(context, ref, product: product),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                        splashRadius: 20,
                                        onPressed: () {
                                          ref.read(productProvider.notifier).deleteProduct(product.id);
                                        },
                                      ),
                                    ],
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

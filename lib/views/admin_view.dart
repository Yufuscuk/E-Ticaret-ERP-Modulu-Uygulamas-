import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';
import '../controllers/auth_controller.dart';
import 'product_list_view.dart';

class AdminView extends ConsumerWidget {
  const AdminView({super.key});

  void _showAddEditDialog(BuildContext context, WidgetRef ref, {Product? product}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final codeController = TextEditingController(text: product?.code ?? '');
    final priceController = TextEditingController(text: product?.price.toString() ?? '');
    final stockController = TextEditingController(text: product?.stockQuantity.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product == null ? 'Yeni Ürün Ekle' : 'Ürün Düzenle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Ürün Adı')),
                TextField(controller: codeController, decoration: const InputDecoration(labelText: 'Stok Kodu')),
                TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Fiyat')),
                TextField(controller: stockController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stok Miktarı')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
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
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: productsState.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('Hiç ürün yok.'));
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Text('Kod: ${product.code} | Stok: ${product.stockQuantity} | ${product.price} TL'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showAddEditDialog(context, ref, product: product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          ref.read(productProvider.notifier).deleteProduct(product.id);
                        },
                      ),
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

// Şimdilik API entegrasyonu olmadığı için mock veri kullanıyoruz.
class ProductController extends Notifier<AsyncValue<List<Product>>> {
  @override
  AsyncValue<List<Product>> build() {
    fetchProducts();
    return const AsyncValue.loading();
  }

  Future<void> fetchProducts() async {
    try {
      state = const AsyncValue.loading();
      
      // Simüle edilmiş ağ gecikmesi
      await Future.delayed(const Duration(seconds: 1));

      // Mock Veri
      final List<Product> mockProducts = [
        Product(id: 1, name: 'Oyuncu Bilgisayarı', code: 'PC-001', price: 25000.0, stockQuantity: 5),
        Product(id: 2, name: 'Mekanik Klavye', code: 'KB-002', price: 1500.0, stockQuantity: 15),
        Product(id: 3, name: 'Kablosuz Mouse', code: 'MS-003', price: 800.0, stockQuantity: 0), // Stokta yok
        Product(id: 4, name: '27" Monitör', code: 'MN-004', price: 6500.0, stockQuantity: 2),
      ];

      state = AsyncValue.data(mockProducts);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Sipariş sonrası stok düşme işlemi
  void reduceStock(int productId, int quantity) {
    if (state.value == null) return;
    
    final currentProducts = state.value!;
    final updatedProducts = currentProducts.map((p) {
      if (p.id == productId) {
        return Product(
          id: p.id,
          name: p.name,
          code: p.code,
          price: p.price,
          stockQuantity: p.stockQuantity - quantity,
        );
      }
      return p;
    }).toList();

    state = AsyncValue.data(updatedProducts);
  }

  // ---- ADMIN FONKSİYONLARI ---- //

  void addProduct(Product newProduct) {
    if (state.value == null) return;
    state = AsyncValue.data([...state.value!, newProduct]);
  }

  void updateProduct(Product updatedProduct) {
    if (state.value == null) return;
    final currentProducts = state.value!;
    final index = currentProducts.indexWhere((p) => p.id == updatedProduct.id);
    if (index >= 0) {
      final newState = [...currentProducts];
      newState[index] = updatedProduct;
      state = AsyncValue.data(newState);
    }
  }

  void deleteProduct(int productId) {
    if (state.value == null) return;
    final newState = state.value!.where((p) => p.id != productId).toList();
    state = AsyncValue.data(newState);
  }
}

final productProvider = NotifierProvider<ProductController, AsyncValue<List<Product>>>(() {
  return ProductController();
});

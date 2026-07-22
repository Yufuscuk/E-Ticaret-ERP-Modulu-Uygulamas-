import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../services/api_service.dart';

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
      
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.getRequest('products');
      
      final List<dynamic> data = response.data;
      final List<Product> products = data.map((item) {
        return Product(
          id: item['STOK_NO'] ?? 0,
          name: item['STOK_ADI']?.toString() ?? 'Bilinmeyen Ürün',
          code: item['STOK_KODU']?.toString() ?? 'KOD-YOK',
          price: (item['FIYAT'] ?? 0).toDouble(), // DB'den gelen fiyat
          stockQuantity: (item['BAKIYE'] ?? 0).toInt(), // DB'den gelen stok
        );
      }).toList();

      state = AsyncValue.data(products);
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

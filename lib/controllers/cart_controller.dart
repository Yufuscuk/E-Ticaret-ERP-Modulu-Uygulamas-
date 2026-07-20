import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartController extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  // Sepete ürün ekle
  void addToCart(Product product) {
    if (product.stockQuantity <= 0) return;

    final existingItemIndex = state.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex >= 0) {
      final existingItem = state[existingItemIndex];
      // Stok miktarını aşmamak için validasyon
      if (existingItem.quantity < product.stockQuantity) {
        final updatedItem = existingItem.copyWith(quantity: existingItem.quantity + 1);
        final newState = [...state];
        newState[existingItemIndex] = updatedItem;
        state = newState;
      }
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }

  // Sepetten ürün çıkar veya miktarını azalt
  void removeFromCart(Product product) {
    final existingItemIndex = state.indexWhere((item) => item.product.id == product.id);
    if (existingItemIndex >= 0) {
      final existingItem = state[existingItemIndex];
      if (existingItem.quantity > 1) {
        final updatedItem = existingItem.copyWith(quantity: existingItem.quantity - 1);
        final newState = [...state];
        newState[existingItemIndex] = updatedItem;
        state = newState;
      } else {
        state = state.where((item) => item.product.id != product.id).toList();
      }
    }
  }

  // Sepeti tamamen boşalt
  void clearCart() {
    state = [];
  }

  // Toplam sepet tutarını hesapla
  double get totalAmount {
    return state.fold(0, (total, item) => total + (item.product.price * item.quantity));
  }
}

// Global sepet provider'ı
final cartProvider = NotifierProvider<CartController, List<CartItem>>(() {
  return CartController();
});

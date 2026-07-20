import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart'; // uuid eklenecek pubspec'te var varsayıyorum, ancak math.Random da kullanılabilir. Şimdilik DateTime milliseconds kullanalım
import '../controllers/cart_controller.dart';
import '../controllers/customer_controller.dart';
import '../controllers/product_controller.dart';
import '../models/order.dart';

class CartView extends ConsumerWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepetim'),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Sepetiniz boş.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text('${item.product.price} TL', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                      if (item.quantity > 1) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.deepPurple.shade50,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text('x${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple, fontSize: 11)),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${item.product.price * item.quantity} TL', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green)),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () => cartNotifier.removeFromCart(item.product),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Icon(Icons.remove, color: Colors.red, size: 16),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(width: 12),
                                    InkWell(
                                      onTap: item.quantity >= item.product.stockQuantity
                                          ? null
                                          : () => cartNotifier.addToCart(item.product),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Icon(Icons.add, color: Colors.green, size: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Alt Sabit Kısım (Sipariş Özeti + Buton)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Sipariş Özeti Detayları
                      if (cartItems.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Sipariş Özeti', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey)),
                            Text('${cartItems.length} Çeşit Ürün', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 100),
                          child: SingleChildScrollView(
                            child: Column(
                              children: cartItems.map((item) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text('${item.product.name} (x${item.quantity})', style: const TextStyle(fontSize: 13, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                    Text('${item.product.price * item.quantity} TL', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                                  ],
                                ),
                              )).toList(),
                            ),
                          ),
                        ),
                        const Divider(height: 24),
                      ],
                      // Toplam ve Buton
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Genel Toplam', style: TextStyle(fontSize: 13, color: Colors.grey)),
                              Text('${cartNotifier.totalAmount} TL', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: cartItems.isEmpty
                                ? null
                                : () {
                                    // Sipariş Oluştur (Mock)
                                    final newOrder = Order(
                                      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                                      date: DateTime.now(),
                                      items: cartItems.toList(),
                                      totalAmount: cartNotifier.totalAmount,
                                    );

                                    // Cariye İşle
                                    ref.read(customerProvider.notifier).addOrderToHistory(newOrder);

                                    // Stoktan Düş
                                    final productNotifier = ref.read(productProvider.notifier);
                                    for (var item in cartItems) {
                                      productNotifier.reduceStock(item.product.id, item.quantity);
                                    }

                                    // Sepeti Temizle
                                    cartNotifier.clearCart();

                                    // Bildirim Göster ve Çık
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Sipariş başarıyla oluşturuldu!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Siparişi Tamamla', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

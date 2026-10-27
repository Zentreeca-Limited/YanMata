import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/features/shop/data/shop_repository.dart';
import 'package:yanmata/features/shop/domain/health_product.dart';

final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepository();
});

class ShopCategoryFilterNotifier extends Notifier<String> {
  @override
  String build() => 'All';

  void setCategory(String cat) => state = cat;
}

final shopCategoryFilterProvider =
    NotifierProvider<ShopCategoryFilterNotifier, String>(
  ShopCategoryFilterNotifier.new,
);

class ShopSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String q) => state = q;
}

final shopSearchQueryProvider =
    NotifierProvider<ShopSearchQueryNotifier, String>(
  ShopSearchQueryNotifier.new,
);

final healthProductsProvider =
    FutureProvider.autoDispose<List<HealthProduct>>((ref) async {
  final repo = ref.watch(shopRepositoryProvider);
  final category = ref.watch(shopCategoryFilterProvider);
  final query = ref.watch(shopSearchQueryProvider);

  return repo.fetchProducts(
    category: category,
    query: query.isEmpty ? null : query,
  );
});

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => [];

  void addToCart(HealthProduct product) {
    final index = state.indexWhere((it) => it.product.id == product.id);
    if (index >= 0) {
      final updated = [...state];
      updated[index] =
          updated[index].copyWith(quantity: updated[index].quantity + 1);
      state = updated;
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }

  void removeFromCart(String productId) {
    state = state.where((it) => it.product.id != productId).toList();
  }

  void updateQuantity(String productId, int delta) {
    final index = state.indexWhere((it) => it.product.id == productId);
    if (index >= 0) {
      final newQty = state[index].quantity + delta;
      if (newQty <= 0) {
        removeFromCart(productId);
      } else {
        final updated = [...state];
        updated[index] = updated[index].copyWith(quantity: newQty);
        state = updated;
      }
    }
  }

  void clearCart() {
    state = [];
  }

  int get totalNgn =>
      state.fold(0, (sum, it) => sum + (it.product.priceNgn * it.quantity));
  int get itemCount => state.fold(0, (sum, it) => sum + it.quantity);
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);

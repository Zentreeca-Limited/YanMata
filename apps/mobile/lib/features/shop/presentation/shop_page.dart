import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/widgets.dart';
import 'package:yanmata/features/shop/application/shop_provider.dart';
import 'package:yanmata/features/shop/domain/health_product.dart';
import 'package:yanmata/features/shop/presentation/cart_sheet.dart';

class ShopPage extends ConsumerStatefulWidget {
  const ShopPage({super.key});

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(healthProductsProvider);
    final activeFilter = ref.watch(shopCategoryFilterProvider);
    final cartCount = ref.watch(cartProvider.notifier).itemCount;

    return PageFrame(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Eyebrow('Verified pharmacies & wellness products'),
                  const SizedBox(height: 4),
                  Text(
                    'Shop Health Products',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Palette.plum,
                    ),
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: () => CartSheet.show(context),
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Palette.plum,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Search Bar
        TextField(
          controller: _searchController,
          onChanged: (val) =>
              ref.read(shopSearchQueryProvider.notifier).setQuery(val),
          decoration: InputDecoration(
            hintText: 'Search for a product (e.g. pregnancy test)',
            prefixIcon: const Icon(Icons.search, color: Palette.plum),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(shopSearchQueryProvider.notifier).setQuery('');
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE9E2E9)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE9E2E9)),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                [
                  'All',
                  "Women's Health",
                  'Vitamins & Supplements',
                  'Personal Care',
                ].map((cat) {
                  final isSelected = activeFilter == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) {
                        ref
                            .read(shopCategoryFilterProvider.notifier)
                            .setCategory(cat);
                      },
                    ),
                  );
                }).toList(),
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          'Featured Products',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Palette.plum,
          ),
        ),
        const SizedBox(height: 12),

        productsAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (err, _) => SoftCard(
            color: Palette.blush,
            child: Text('Unable to load products: $err'),
          ),
          data: (products) {
            if (products.isEmpty) {
              return SoftCard(
                color: Colors.white,
                child: Column(
                  children: [
                    const Icon(
                      Icons.storefront_outlined,
                      size: 40,
                      color: Palette.slate,
                    ),
                    const SizedBox(height: 8),
                    const Text('No products match your search.'),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        ref.read(shopSearchQueryProvider.notifier).setQuery('');
                        ref
                            .read(shopCategoryFilterProvider.notifier)
                            .setCategory('All');
                      },
                      child: const Text('Reset filters'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: products
                  .map(
                    (p) => _ProductCard(
                      product: p,
                      onAddToCart: () {
                        ref.read(cartProvider.notifier).addToCart(p);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added ${p.name} to cart'),
                            action: SnackBarAction(
                              label: 'View Cart',
                              textColor: Palette.lilac,
                              onPressed: () => CartSheet.show(context),
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onAddToCart});
  final HealthProduct product;
  final VoidCallback onAddToCart;

  IconData _iconForCategory(String cat) {
    switch (cat) {
      case 'womens_health':
        return Icons.medication_outlined;
      case 'vitamins':
        return Icons.healing_outlined;
      default:
        return Icons.clean_hands_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE9E2E9)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Palette.lilac,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _iconForCategory(product.category),
                  color: Palette.plum,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Palette.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${product.packSize} · ${product.sellerName}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Palette.slate,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₦${product.priceNgn}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Palette.plum,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: onAddToCart,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  minimumSize: const Size(0, 36),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

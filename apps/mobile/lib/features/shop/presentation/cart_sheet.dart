import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/features/shop/application/shop_provider.dart';

class CartSheet extends ConsumerStatefulWidget {
  const CartSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CartSheet(),
    );
  }

  @override
  ConsumerState<CartSheet> createState() => _CartSheetState();
}

class _CartSheetState extends ConsumerState<CartSheet> {
  final _nameController = TextEditingController(text: 'Aisha Yusuf');
  final _phoneController = TextEditingController(text: '+234 803 123 4567');
  final _addressController = TextEditingController(text: '14 Rayfield Road, Jos, Plateau State');
  bool _isOrdering = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleCheckout() async {
    final cart = ref.read(cartProvider);
    if (cart.isEmpty) return;

    setState(() => _isOrdering = true);
    try {
      final repo = ref.read(shopRepositoryProvider);
      final total = ref.read(cartProvider.notifier).totalNgn;
      await repo.placeOrder(
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        deliveryAddress: _addressController.text.trim(),
        totalNgn: total,
        items: cart,
      );

      ref.read(cartProvider.notifier).clearCart();
      if (!mounted) return;
      Navigator.pop(context);
      showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text('Order Confirmed'),
            ],
          ),
          content: const Text(
            'Your order has been placed with the verified pharmacy in Jos. You will receive an SMS confirmation once dispatched.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('Great, thanks!'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isOrdering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final total = ref.read(cartProvider.notifier).totalNgn;

    return Container(
      decoration: const BoxDecoration(
        color: Palette.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6C7D6),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Icon(Icons.shopping_bag_outlined, color: Palette.plum, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Your Health Cart',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Palette.plum,
                      ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (cart.isEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 36),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.remove_shopping_cart_outlined, size: 48, color: Palette.slate),
                      SizedBox(height: 12),
                      Text('Your cart is empty', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 4),
                      Text(
                        'Browse verified products and add them to your cart.',
                        style: TextStyle(fontSize: 12, color: Palette.slate),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Cart items list
              ...cart.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE9E2E9)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item.product.packSize} · ₦${item.product.priceNgn}',
                              style: const TextStyle(fontSize: 12, color: Palette.slate),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, size: 20),
                            onPressed: () => ref.read(cartProvider.notifier).updateQuantity(item.product.id, -1),
                          ),
                          Text(
                            '${item.quantity}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, size: 20),
                            onPressed: () => ref.read(cartProvider.notifier).updateQuantity(item.product.id, 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),

              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total (incl. delivery in Jos)', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    '₦$total',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Palette.plum),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Customer details for delivery
              const Text('Delivery Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Palette.plum)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Recipient Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number (SMS updates)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Delivery Address in Jos'),
              ),
              const SizedBox(height: 20),

              FilledButton(
                onPressed: _isOrdering ? null : _handleCheckout,
                child: Text(_isOrdering ? 'Submitting order…' : 'Place Order with Verified Pharmacy'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

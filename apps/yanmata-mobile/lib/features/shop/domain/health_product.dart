class HealthProduct {
  const HealthProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.packSize,
    required this.priceNgn,
    required this.description,
    required this.sellerName,
    required this.isVerifiedSeller,
    required this.stockStatus,
    required this.safetyInfo,
  });

  final String id;
  final String name;
  final String category;
  final String packSize;
  final int priceNgn;
  final String description;
  final String sellerName;
  final bool isVerifiedSeller;
  final String stockStatus;
  final String safetyInfo;

  factory HealthProduct.fromJson(Map<String, dynamic> json) {
    return HealthProduct(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? 'womens_health',
      packSize: json['pack_size'] as String? ?? '',
      priceNgn: (json['price_ngn'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
      sellerName: json['seller_name'] as String? ?? '',
      isVerifiedSeller: json['is_verified_seller'] as bool? ?? true,
      stockStatus: json['stock_status'] as String? ?? 'in_stock',
      safetyInfo: json['safety_info'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'pack_size': packSize,
    'price_ngn': priceNgn,
    'description': description,
    'seller_name': sellerName,
    'is_verified_seller': isVerifiedSeller,
    'stock_status': stockStatus,
    'safety_info': safetyInfo,
  };
}

class CartItem {
  const CartItem({required this.product, required this.quantity});

  final HealthProduct product;
  final int quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);
}

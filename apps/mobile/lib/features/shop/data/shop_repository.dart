import 'package:yanmata/core/api.dart';
import 'package:yanmata/features/shop/domain/health_product.dart';

class ShopRepository {
  ShopRepository({Api? api}) : _api = api ?? Api();
  final Api _api;

  static const List<HealthProduct> fallbackProducts = [
    HealthProduct(
      id: 'prod-01',
      name: 'Pregnancy Test Kit',
      category: 'womens_health',
      packSize: '1 pack',
      priceNgn: 3500,
      description: 'Over 99% accurate early pregnancy detection test. Rapid results within 3-5 minutes with clear line indicators.',
      sellerName: 'Zentreeca Community Pharmacy Jos',
      isVerifiedSeller: true,
      stockStatus: 'in_stock',
      safetyInfo: 'For in vitro diagnostic use. Read instruction leaflet before use. If you have questions about your result, contact YanMata care specialists.',
    ),
    HealthProduct(
      id: 'prod-02',
      name: 'Folic Acid 400mcg',
      category: 'vitamins',
      packSize: '30 tablets',
      priceNgn: 2800,
      description: 'Essential daily vitamin B9 supplement supporting cell division, reproductive wellness, and maternal development.',
      sellerName: 'Zentreeca Community Pharmacy Jos',
      isVerifiedSeller: true,
      stockStatus: 'in_stock',
      safetyInfo: 'Dietary supplement. Not a replacement for a balanced diet. Consult a healthcare provider before taking with prescription medications.',
    ),
    HealthProduct(
      id: 'prod-03',
      name: 'Iron Supplement',
      category: 'vitamins',
      packSize: '30 tablets',
      priceNgn: 3000,
      description: 'Gentle iron bisglycinate with Vitamin C for optimal absorption to support healthy energy levels and red blood cells during heavy flow.',
      sellerName: 'Plateau Health Mart Jos',
      isVerifiedSeller: true,
      stockStatus: 'in_stock',
      safetyInfo: 'Keep out of reach of children. Take with food or water to minimise stomach sensitivity.',
    ),
    HealthProduct(
      id: 'prod-04',
      name: 'Menstrual Pain Relief',
      category: 'womens_health',
      packSize: '20 tablets',
      priceNgn: 2500,
      description: 'Targeted relief for menstrual cramps, lower back ache, and period discomfort.',
      sellerName: 'Zentreeca Community Pharmacy Jos',
      isVerifiedSeller: true,
      stockStatus: 'in_stock',
      safetyInfo: 'Use strictly as directed on the packaging. Do not exceed stated dose. Avoid use if sensitive to NSAIDs.',
    ),
    HealthProduct(
      id: 'prod-05',
      name: 'Organic Cotton Sanitary Pads',
      category: 'personal_care',
      packSize: '10 pads',
      priceNgn: 1800,
      description: 'Breathable 100% organic cotton top sheet, chlorine-free and fragrance-free pads designed for sensitive skin.',
      sellerName: 'Plateau Health Mart Jos',
      isVerifiedSeller: true,
      stockStatus: 'in_stock',
      safetyInfo: 'Change pads every 4-6 hours for comfort and hygiene.',
    ),
  ];

  Future<List<HealthProduct>> fetchProducts({
    String? category,
    String? query,
  }) async {
    try {
      final queryParams = <String>[];
      if (category != null && category.isNotEmpty && category != 'All') {
        String mappedCat = category.toLowerCase().replaceAll(' ', '_');
        if (category == "Women's Health") mappedCat = 'womens_health';
        if (category == 'Vitamins & Supplements') mappedCat = 'vitamins';
        if (category == 'Personal Care') mappedCat = 'personal_care';
        queryParams.add('category=${Uri.encodeComponent(mappedCat)}');
      }
      if (query != null && query.isNotEmpty) {
        queryParams.add('query=${Uri.encodeComponent(query)}');
      }

      final qs = queryParams.isEmpty ? '' : '?${queryParams.join('&')}';
      final res = await _api.request('/products$qs');
      final list = (res['data'] as List<dynamic>?) ?? [];
      if (list.isEmpty) {
        return _filterLocal(fallbackProducts, category, query);
      }
      return list
          .map((e) => HealthProduct.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return _filterLocal(fallbackProducts, category, query);
    }
  }

  Future<Map<String, dynamic>> placeOrder({
    required String customerName,
    required String customerPhone,
    required String deliveryAddress,
    required int totalNgn,
    required List<CartItem> items,
    String? token,
  }) async {
    final payload = {
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'delivery_address': deliveryAddress,
      'total_ngn': totalNgn,
      'items': items
          .map(
            (it) => {
              'product_id': it.product.id,
              'name': it.product.name,
              'quantity': it.quantity,
              'price_ngn': it.product.priceNgn,
            },
          )
          .toList(),
    };

    return _api.request('/orders', method: 'POST', body: payload, token: token);
  }

  List<HealthProduct> _filterLocal(
    List<HealthProduct> prods,
    String? category,
    String? query,
  ) {
    return prods.where((p) {
      if (category != null && category != 'All') {
        String target = 'womens_health';
        if (category == 'Vitamins & Supplements') target = 'vitamins';
        if (category == 'Personal Care') target = 'personal_care';
        if (p.category != target) return false;
      }
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        return p.name.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q);
      }
      return true;
    }).toList();
  }
}

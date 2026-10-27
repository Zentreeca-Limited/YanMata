import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yanmata/core/providers.dart';

final learningProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final data = await ref.watch(apiProvider).request('/content');
  return (data['data'] as List)
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';

final apiProvider = Provider((ref) => Api());
final apiBaseUrlProvider = Provider<String>((ref) => Api.base);

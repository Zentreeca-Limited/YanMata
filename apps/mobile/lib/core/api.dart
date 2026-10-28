import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  Api({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;
  static const base = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://yanmata.zentreeca.org/api/v1',
  );
  Future<Map<String, dynamic>> request(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final uri = Uri.parse('$base$path');
    if (uri.scheme != 'https' &&
        const bool.fromEnvironment('dart.vm.product')) {
      throw Exception('A secure API URL is required for release builds.');
    }
    final request = http.Request(method, uri)
      ..headers.addAll({
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });
    if (body != null) request.body = jsonEncode(body);
    final response = await http.Response.fromStream(
      await _client.send(request).timeout(const Duration(seconds: 20)),
    );
    if (response.statusCode == 422) {
      try {
        final errors = (jsonDecode(response.body) as Map)['errors'] as Map?;
        final first = errors?.values.first;
        if (first is List && first.isNotEmpty) {
          throw Exception('${first.first}');
        }
      } on FormatException {
        // fall through to the generic message
      }
    }
    if (response.statusCode >= 400) {
      throw Exception(
        response.statusCode == 401
            ? 'Your session expired. Sign in again.'
            : response.statusCode == 403
            ? 'This action needs permission or sync consent.'
            : response.statusCode == 429
            ? 'Too many requests. Wait a moment and try again.'
            : 'Unable to complete the request (${response.statusCode}). Please try again.',
      );
    }
    return response.body.isEmpty
        ? {}
        : jsonDecode(response.body) as Map<String, dynamic>;
  }
}

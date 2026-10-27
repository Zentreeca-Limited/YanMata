import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/journal_repository.dart';

class DevicePrivateStore implements PrivateStore {
  const DevicePrivateStore();
  static const _storage = FlutterSecureStorage();
  static const _key = 'yanmata.private.v1';
  @override
  Future<String?> read() => _storage.read(key: _key);
  @override
  Future<void> write(String value) => _storage.write(key: _key, value: value);
  @override
  Future<void> delete() => _storage.delete(key: _key);
}

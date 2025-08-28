import 'dart:async';

import '../../domain/entities/api_key.dart';
import '../../domain/repositories/i_api_key_repository.dart';
import '../models/api_key_model.dart';

class MockApiKeyRepository implements IApiKeyRepository {
  @override
  Future<ApiKey> validateApiKey(String? apiKey) async {
    await Future.delayed(const Duration(seconds: 1));

    final isValid =
        apiKey != null && apiKey.length >= 20 && !apiKey.contains(' ');

    return ApiKeyModel(keyValue: apiKey, isValid: isValid, isSkipped: false);
  }

  @override
  Future<bool> isApiKeyAlreadyConfigured(String projectPath) async {
    await Future.delayed(const Duration(seconds: 1));
    return false;
  }

  @override
  Future<ApiKey> skipApiKey() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ApiKeyModel.skipped();
  }
}

import '../entities/api_key.dart';

abstract class IApiKeyRepository {
  Future<ApiKey> validateApiKey(String? apiKey);
  Future<bool> isApiKeyAlreadyConfigured(String projectPath);
  Future<ApiKey> skipApiKey();
}

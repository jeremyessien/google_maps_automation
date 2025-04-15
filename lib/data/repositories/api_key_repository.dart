import '../../core/utils/api_key_utils.dart';
import '../../domain/entities/api_key.dart';
import '../../domain/repositories/i_api_key_repository.dart';
import '../models/api_key_model.dart';

class ApiKeyRepository implements IApiKeyRepository {
  @override
  Future<ApiKey> validateApiKey(String? apiKey) async {
    final isValid = ApiKeyUtils.isValidApiKey(apiKey);

    return ApiKeyModel(keyValue: apiKey, isValid: isValid, isSkipped: false);
  }

  @override
  Future<bool> isApiKeyAlreadyConfigured(String projectPath) async {
    final isConfiguredInAndroid = await ApiKeyUtils.isApiKeyConfiguredInAndroid(
      projectPath,
      'android/app/src/main/AndroidManifest.xml',
    );

    final isConfiguredInIOS = await ApiKeyUtils.isApiKeyConfiguredInIOS(
      projectPath,
      'ios/Runner/Info.plist',
    );

    return isConfiguredInAndroid || isConfiguredInIOS;
  }

  @override
  Future<ApiKey> skipApiKey() async {
    return ApiKeyModel.skipped();
  }
}

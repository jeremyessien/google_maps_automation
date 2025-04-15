
import '../../domain/entities/api_key.dart';

class ApiKeyModel extends ApiKey {
  ApiKeyModel({super.keyValue, super.isSkipped, super.isValid});

  factory ApiKeyModel.fromEntity(ApiKey entity) {
    return ApiKeyModel(
      keyValue: entity.keyValue,
      isSkipped: entity.isSkipped,
      isValid: entity.isValid,
    );
  }

  factory ApiKeyModel.empty() {
    return ApiKeyModel();
  }

  factory ApiKeyModel.skipped() {
    return ApiKeyModel(isSkipped: true);
  }
}

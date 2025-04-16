import '../../domain/entities/demo_integration.dart';

class DemoIntegrationModel extends DemoIntegration {
  DemoIntegrationModel({
    super.isIntegrated,
    super.errorMessage,
    super.filePath,
  });

  factory DemoIntegrationModel.fromEntity(DemoIntegration entity) {
    return DemoIntegrationModel(
      isIntegrated: entity.isIntegrated,
      errorMessage: entity.errorMessage,
      filePath: entity.filePath,
    );
  }
}

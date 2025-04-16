import '../../core/utils/demo_integration_utils.dart';
import '../../domain/entities/demo_integration.dart';
import '../../domain/repositories/i_demo_integration_repository.dart';
import '../models/demo_integration_model.dart';

class DemoIntegrationRepository implements IDemoIntegrationRepository {
  @override
  Future<DemoIntegration> integrateGoogleMapsExample(String projectPath) async {
    try {
      final mainDartFilePath = await DemoIntegrationUtils.findMainDartFile(
        projectPath,
      );

      if (mainDartFilePath == null) {
        return DemoIntegrationModel(
          isIntegrated: false,
          errorMessage: 'Could not find main.dart file in the project',
        );
      }

      final exampleFilePath = await DemoIntegrationUtils.createMapsExampleFile(
        projectPath,
      );

      if (exampleFilePath == null) {
        return DemoIntegrationModel(
          isIntegrated: false,
          errorMessage: 'Failed to create Google Maps example file',
        );
      }

      final isMainUpdated = await DemoIntegrationUtils.updateMainDartFile(
        mainDartFilePath,
        exampleFilePath,
      );

      if (!isMainUpdated) {
        return DemoIntegrationModel(
          isIntegrated: false,
          errorMessage: 'Failed to update main.dart file',
          filePath: exampleFilePath,
        );
      }

      return DemoIntegrationModel(
        isIntegrated: true,
        filePath: exampleFilePath,
      );
    } catch (e) {
      return DemoIntegrationModel(
        isIntegrated: false,
        errorMessage: 'Error integrating Google Maps example: $e',
      );
    }
  }
}

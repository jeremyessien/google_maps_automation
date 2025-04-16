
import '../entities/demo_integration.dart';

abstract class IDemoIntegrationRepository {
  Future<DemoIntegration> integrateGoogleMapsExample(String projectPath);
}
import 'dart:async';

import '../../domain/entities/demo_integration.dart';
import '../../domain/repositories/i_demo_integration_repository.dart';
import '../models/demo_integration_model.dart';

class MockDemoIntegrationRepository implements IDemoIntegrationRepository {
  @override
  Future<DemoIntegration> integrateGoogleMapsExample(String projectPath) async {
    await Future.delayed(const Duration(seconds: 3));

    return DemoIntegrationModel(
      isIntegrated: true,
      filePath: '$projectPath/lib/google_maps_example.dart',
    );
  }
}

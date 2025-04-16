import '../../domain/entities/package_integration.dart';

import '../../domain/repositories/i_package_repository.dart';
import '../models/package_integration_model.dart';

class MockPackageIntegrationRepository
    implements IPackageIntegrationRepository {
  @override
  Future<PackageIntegration> integratePackage({
    required String projectPath,
    required String packageName,
    String? version,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    return PackageIntegrationModel(
      packageName: packageName,
      version: version ?? 'latest',
      isIntegrated: true,
    );
  }

  @override
  Future<bool> isPackageIntegrated({
    required String projectPath,
    required String packageName,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return false;
  }

  @override
  Future<String> runPubGet(String projectPath) async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Running "flutter pub get" in $projectPath...\nResolved 256 dependencies.\nRunning post-process hooks...\nProcessed 1 package.\nRunning post-process hooks...\nProcessed 8 packages.\nRunning post-process hooks...\nProcessed 42 packages.\nGoogle Maps package successfully added!';
  }
}

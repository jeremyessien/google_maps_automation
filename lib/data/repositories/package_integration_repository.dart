
import '../../core/utils/process_utils.dart';
import '../../core/utils/pubspec_utils.dart';
import '../../domain/entities/package_integration.dart';

import '../../domain/repositories/i_package_repository.dart';
import '../models/package_integration_model.dart';

class PackageIntegrationRepository implements IPackageIntegrationRepository {
  @override
  Future<PackageIntegration> integratePackage({
    required String projectPath,
    required String packageName,
    String? version,
  }) async {
    try {

      final alreadyIntegrated = await isPackageIntegrated(
        projectPath: projectPath,
        packageName: packageName,
      );

      if (alreadyIntegrated) {
        return PackageIntegrationModel(
          packageName: packageName,
          version: version ?? 'latest',
          isIntegrated: true,
        );
      }


      final success = await PubspecUtils.addPackageToPubspec(
        projectPath: projectPath,
        packageName: packageName,
        version: version,
      );

      if (!success) {
        return PackageIntegrationModel(
          packageName: packageName,
          isIntegrated: false,
          error: 'Failed to add package to pubspec.yaml',
        );
      }


      final pubGetOutput = await runPubGet(projectPath);

      
      if (pubGetOutput.toLowerCase().contains('error')) {
        return PackageIntegrationModel(
          packageName: packageName,
          isIntegrated: false,
          error: pubGetOutput,
        );
      }

      return PackageIntegrationModel(
        packageName: packageName,
        version: version ?? 'latest',
        isIntegrated: true,
      );
    } catch (e) {
      return PackageIntegrationModel(
        packageName: packageName,
        isIntegrated: false,
        error: e.toString(),
      );
    }
  }

  @override
  Future<bool> isPackageIntegrated({
    required String projectPath,
    required String packageName,
  }) async {
    return await PubspecUtils.isPackageInPubspec(
      projectPath: projectPath,
      packageName: packageName,
    );
  }

  @override
  Future<String> runPubGet(String projectPath) {
    return ProcessUtils.runPubGet(projectPath);
  }
}
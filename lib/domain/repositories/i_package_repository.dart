
import '../entities/package_integration.dart';

abstract class IPackageIntegrationRepository {
  Future<PackageIntegration> integratePackage({
    required String projectPath,
    required String packageName,
    String? version,
  });

  Future<bool> isPackageIntegrated({
    required String projectPath,
    required String packageName,
  });

  Future<String> runPubGet(String projectPath);
}
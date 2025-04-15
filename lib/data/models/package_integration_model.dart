import 'package:dev_task/domain/entities/package_integration.dart';

class PackageIntegrationModel extends PackageIntegration {
  PackageIntegrationModel({
    required super.packageName,
    super.version,
    super.isIntegrated,
    super.error,
  });
  factory PackageIntegrationModel.fromEntity(PackageIntegration entity) {
    return PackageIntegrationModel(
      packageName: entity.packageName,
      version: entity.version,
      isIntegrated: entity.isIntegrated,
      error: entity.error,
    );
  }
}

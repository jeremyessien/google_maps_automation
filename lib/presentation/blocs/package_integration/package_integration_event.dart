import 'package:equatable/equatable.dart';

abstract class PackageIntegrationEvent extends Equatable {
  const PackageIntegrationEvent();

  @override
  List<Object?> get props => [];
}

class IntegratePackage extends PackageIntegrationEvent {
  final String projectPath;
  final String packageName;
  final String? version;

  const IntegratePackage({
    required this.projectPath,
    required this.packageName,
    this.version,
  });

  @override
  List<Object?> get props => [projectPath, packageName, version];
}

class CheckPackageIntegration extends PackageIntegrationEvent {
  final String projectPath;
  final String packageName;

  const CheckPackageIntegration({
    required this.projectPath,
    required this.packageName,
  });

  @override
  List<Object> get props => [projectPath, packageName];
}

class RunPubGet extends PackageIntegrationEvent {
  final String projectPath;

  const RunPubGet({required this.projectPath});

  @override
  List<Object> get props => [projectPath];
}

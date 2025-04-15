
import 'package:equatable/equatable.dart';

import '../../../domain/entities/package_integration.dart';

enum PackageIntegrationStatus {
  initial,
  loading,
  alreadyIntegrated,
  integrating,
  pubGetRunning,
  success,
  failure
}

class PackageIntegrationState extends Equatable {
  final PackageIntegrationStatus status;
  final PackageIntegration? packageIntegration;
  final String? output;
  final String? errorMessage;

  const PackageIntegrationState({
    this.status = PackageIntegrationStatus.initial,
    this.packageIntegration,
    this.output,
    this.errorMessage,
  });

  PackageIntegrationState copyWith({
    PackageIntegrationStatus? status,
    PackageIntegration? packageIntegration,
    String? output,
    String? errorMessage,
  }) {
    return PackageIntegrationState(
      status: status ?? this.status,
      packageIntegration: packageIntegration ?? this.packageIntegration,
      output: output ?? this.output,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, packageIntegration, output, errorMessage];
}
import 'package:equatable/equatable.dart';

enum DemoIntegrationStatus { initial, integrating, success, failure }

class DemoIntegrationState extends Equatable {
  final DemoIntegrationStatus status;
  final bool isIntegrated;
  final String? filePath;
  final String? errorMessage;

  const DemoIntegrationState({
    this.status = DemoIntegrationStatus.initial,
    this.isIntegrated = false,
    this.filePath,
    this.errorMessage,
  });

  DemoIntegrationState copyWith({
    DemoIntegrationStatus? status,
    bool? isIntegrated,
    String? filePath,
    String? errorMessage,
  }) {
    return DemoIntegrationState(
      status: status ?? this.status,
      isIntegrated: isIntegrated ?? this.isIntegrated,
      filePath: filePath ?? this.filePath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, isIntegrated, filePath, errorMessage];
}

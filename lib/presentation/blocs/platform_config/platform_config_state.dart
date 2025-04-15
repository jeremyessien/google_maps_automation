import 'package:equatable/equatable.dart';

enum PlatformConfigStatus {
  initial,
  configuring,
  androidConfigured,
  iosConfigured,
  fullyConfigured,
  failure,
}

class PlatformConfigState extends Equatable {
  final PlatformConfigStatus status;
  final bool androidConfigured;
  final bool iosConfigured;
  final String? errorMessage;
  final String? currentTask;

  const PlatformConfigState({
    this.status = PlatformConfigStatus.initial,
    this.androidConfigured = false,
    this.iosConfigured = false,
    this.errorMessage,
    this.currentTask,
  });

  bool get isFullyConfigured => androidConfigured && iosConfigured;

  PlatformConfigState copyWith({
    PlatformConfigStatus? status,
    bool? androidConfigured,
    bool? iosConfigured,
    String? errorMessage,
    String? currentTask,
  }) {
    return PlatformConfigState(
      status: status ?? this.status,
      androidConfigured: androidConfigured ?? this.androidConfigured,
      iosConfigured: iosConfigured ?? this.iosConfigured,
      errorMessage: errorMessage ?? this.errorMessage,
      currentTask: currentTask ?? this.currentTask,
    );
  }

  @override
  List<Object?> get props => [
    status,
    androidConfigured,
    iosConfigured,
    errorMessage,
    currentTask,
  ];
}

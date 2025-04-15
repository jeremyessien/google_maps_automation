import 'package:equatable/equatable.dart';

enum ApiKeyStatus {
  initial,
  loading,
  checking,
  alreadyConfigured,
  valid,
  invalid,
  skipped,
}

class ApiKeyState extends Equatable {
  final ApiKeyStatus status;
  final String? apiKey;
  final bool isValid;
  final bool isSkipped;
  final String? errorMessage;

  const ApiKeyState({
    this.status = ApiKeyStatus.initial,
    this.apiKey,
    this.isValid = false,
    this.isSkipped = false,
    this.errorMessage,
  });

  ApiKeyState copyWith({
    ApiKeyStatus? status,
    String? apiKey,
    bool? isValid,
    bool? isSkipped,
    String? errorMessage,
  }) {
    return ApiKeyState(
      status: status ?? this.status,
      apiKey: apiKey ?? this.apiKey,
      isValid: isValid ?? this.isValid,
      isSkipped: isSkipped ?? this.isSkipped,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, apiKey, isValid, isSkipped, errorMessage];
}

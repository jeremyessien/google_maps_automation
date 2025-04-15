import 'package:equatable/equatable.dart';

abstract class ApiKeyEvent extends Equatable {
  const ApiKeyEvent();

  @override
  List<Object?> get props => [];
}

class InputApiKey extends ApiKeyEvent {
  final String apiKey;

  const InputApiKey(this.apiKey);

  @override
  List<Object> get props => [apiKey];
}

class ValidateApiKey extends ApiKeyEvent {
  final String apiKey;

  const ValidateApiKey(this.apiKey);

  @override
  List<Object> get props => [apiKey];
}

class SkipApiKey extends ApiKeyEvent {
  const SkipApiKey();
}

class CheckApiKeyConfiguration extends ApiKeyEvent {
  final String projectPath;

  const CheckApiKeyConfiguration(this.projectPath);

  @override
  List<Object> get props => [projectPath];
}

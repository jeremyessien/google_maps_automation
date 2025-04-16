
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/i_api_key_repository.dart';
import 'api_key_event.dart';
import 'api_key_state.dart';

class ApiKeyBloc extends Bloc<ApiKeyEvent, ApiKeyState> {
  final IApiKeyRepository apiKeyRepository;

  ApiKeyBloc({required this.apiKeyRepository}) : super(const ApiKeyState()) {
    on<InputApiKey>(onInputApiKey);
    on<ValidateApiKey>(onValidateApiKey);
    on<SkipApiKey>(onSkipApiKey);
    on<CheckApiKeyConfiguration>(onCheckApiKeyConfiguration);
  }

  void onInputApiKey(InputApiKey event, Emitter<ApiKeyState> emit) {
    emit(
      state.copyWith(
        apiKey: event.apiKey,

        status: ApiKeyStatus.initial,
        isValid: false,
        errorMessage: null,
      ),
    );
  }

  Future<void> onValidateApiKey(
    ValidateApiKey event,
    Emitter<ApiKeyState> emit,
  ) async {
    emit(state.copyWith(status: ApiKeyStatus.loading));

    final apiKeyEntity = await apiKeyRepository.validateApiKey(event.apiKey);

    if (apiKeyEntity.isValid) {
      emit(
        state.copyWith(
          status: ApiKeyStatus.valid,
          isValid: true,
          apiKey: event.apiKey,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: ApiKeyStatus.invalid,
          isValid: false,
          errorMessage: 'Invalid API key format',
        ),
      );
    }
  }

  Future<void> onSkipApiKey(SkipApiKey event, Emitter<ApiKeyState> emit) async {
    emit(state.copyWith(status: ApiKeyStatus.loading));

    final apiKeyEntity = await apiKeyRepository.skipApiKey();

    emit(state.copyWith(status: ApiKeyStatus.skipped, isSkipped: true));
  }

  Future<void> onCheckApiKeyConfiguration(
    CheckApiKeyConfiguration event,
    Emitter<ApiKeyState> emit,
  ) async {
    emit(state.copyWith(status: ApiKeyStatus.checking));

    final isConfigured = await apiKeyRepository.isApiKeyAlreadyConfigured(
      event.projectPath,
    );

    if (isConfigured) {
      emit(state.copyWith(status: ApiKeyStatus.alreadyConfigured));
    } else {
      emit(state.copyWith(status: ApiKeyStatus.initial));
    }
  }
}

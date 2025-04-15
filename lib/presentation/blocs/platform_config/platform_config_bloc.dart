import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/i_platform_config_repository.dart';
import 'platform_config_event.dart';
import 'platform_config_state.dart';

class PlatformConfigBloc
    extends Bloc<PlatformConfigEvent, PlatformConfigState> {
  final IPlatformConfigRepository platformConfigRepository;

  PlatformConfigBloc({required this.platformConfigRepository})
    : super(const PlatformConfigState()) {
    on<ConfigureAndroidPlatform>(onConfigureAndroidPlatform);
    on<ConfigureIosPlatform>(onConfigureIosPlatform);
    on<ConfigureBothPlatforms>(onConfigureBothPlatforms);
  }

  Future<void> onConfigureAndroidPlatform(
    ConfigureAndroidPlatform event,
    Emitter<PlatformConfigState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PlatformConfigStatus.configuring,
        currentTask: 'Configuring Android...',
      ),
    );

    final result = await platformConfigRepository.configureAndroidPlatform(
      projectPath: event.projectPath,
      apiKey: event.apiKey,
    );

    if (result.androidConfigured) {
      emit(
        state.copyWith(
          status: PlatformConfigStatus.androidConfigured,
          androidConfigured: true,
          currentTask: 'Android configuration complete',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: PlatformConfigStatus.failure,
          errorMessage:
              result.errorMessage ?? 'Failed to configure Android platform',
        ),
      );
    }
  }

  Future<void> onConfigureIosPlatform(
    ConfigureIosPlatform event,
    Emitter<PlatformConfigState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PlatformConfigStatus.configuring,
        currentTask: 'Configuring iOS...',
      ),
    );

    final result = await platformConfigRepository.configureIosPlatform(
      projectPath: event.projectPath,
      apiKey: event.apiKey,
    );

    if (result.iosConfigured) {
      emit(
        state.copyWith(
          status: PlatformConfigStatus.iosConfigured,
          iosConfigured: true,
          currentTask: 'iOS configuration complete',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: PlatformConfigStatus.failure,
          errorMessage:
              result.errorMessage ?? 'Failed to configure iOS platform',
        ),
      );
    }
  }

  Future<void> onConfigureBothPlatforms(
    ConfigureBothPlatforms event,
    Emitter<PlatformConfigState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PlatformConfigStatus.configuring,
        currentTask: 'Configuring Android...',
      ),
    );

    final androidResult = await platformConfigRepository
        .configureAndroidPlatform(
          projectPath: event.projectPath,
          apiKey: event.apiKey,
        );

    if (!androidResult.androidConfigured) {
      emit(
        state.copyWith(
          status: PlatformConfigStatus.failure,
          errorMessage:
              androidResult.errorMessage ??
              'Failed to configure Android platform',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        androidConfigured: true,
        currentTask: 'Configuring iOS...',
      ),
    );

    final iosResult = await platformConfigRepository.configureIosPlatform(
      projectPath: event.projectPath,
      apiKey: event.apiKey,
    );

    if (!iosResult.iosConfigured) {
      emit(
        state.copyWith(
          status: PlatformConfigStatus.androidConfigured,
          errorMessage:
              iosResult.errorMessage ?? 'Failed to configure iOS platform',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: PlatformConfigStatus.fullyConfigured,
        iosConfigured: true,
        currentTask: 'Both platforms configured successfully',
      ),
    );
  }
}

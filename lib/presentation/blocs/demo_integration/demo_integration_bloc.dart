import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/i_demo_integration_repository.dart';
import 'demo_integration_event.dart';
import 'demo_integration_state.dart';

class DemoIntegrationBloc
    extends Bloc<DemoIntegrationEvent, DemoIntegrationState> {
  final IDemoIntegrationRepository demoIntegrationRepository;

  DemoIntegrationBloc({required this.demoIntegrationRepository})
    : super(const DemoIntegrationState()) {
    on<IntegrateGoogleMapsExample>(onIntegrateGoogleMapsExample);
  }

  Future<void> onIntegrateGoogleMapsExample(
    IntegrateGoogleMapsExample event,
    Emitter<DemoIntegrationState> emit,
  ) async {
    emit(state.copyWith(status: DemoIntegrationStatus.integrating));

    final result = await demoIntegrationRepository.integrateGoogleMapsExample(
      event.projectPath,
    );

    if (result.isIntegrated) {
      emit(
        state.copyWith(
          status: DemoIntegrationStatus.success,
          isIntegrated: true,
          filePath: result.filePath,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: DemoIntegrationStatus.failure,
          errorMessage: result.errorMessage,
          filePath: result.filePath,
        ),
      );
    }
  }
}

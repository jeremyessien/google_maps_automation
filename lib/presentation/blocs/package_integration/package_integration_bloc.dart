// lib/presentation/bloc/package_integration/package_integration.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/i_package_repository.dart';
import 'package_integration_event.dart';
import 'package_integration_state.dart';

class PackageIntegrationBloc
    extends Bloc<PackageIntegrationEvent, PackageIntegrationState> {
  final IPackageIntegrationRepository packageIntegrationRepository;

  PackageIntegrationBloc({required this.packageIntegrationRepository})
    : super(const PackageIntegrationState()) {
    on<IntegratePackage>(onIntegratePackage);
    on<CheckPackageIntegration>(onCheckPackageIntegration);
    on<RunPubGet>(onRunPubGet);
  }

  Future<void> onIntegratePackage(
    IntegratePackage event,
    Emitter<PackageIntegrationState> emit,
  ) async {

    emit(state.copyWith(status: PackageIntegrationStatus.loading));

    final isIntegrated = await packageIntegrationRepository.isPackageIntegrated(
      projectPath: event.projectPath,
      packageName: event.packageName,
    );

    if (isIntegrated) {
      emit(
        state.copyWith(
          status: PackageIntegrationStatus.alreadyIntegrated,
          output: '${event.packageName} is already integrated',
        ),
      );
      return;
    }


    emit(
      state.copyWith(
        status: PackageIntegrationStatus.integrating,
        output: 'Adding ${event.packageName} to pubspec.yaml...',
      ),
    );

    final packageIntegration = await packageIntegrationRepository
        .integratePackage(
          projectPath: event.projectPath,
          packageName: event.packageName,
          version: event.version,
        );

    if (packageIntegration.isIntegrated) {
      emit(
        state.copyWith(
          status: PackageIntegrationStatus.success,
          packageIntegration: packageIntegration,
          output: '${event.packageName} successfully integrated',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: PackageIntegrationStatus.failure,
          packageIntegration: packageIntegration,
          errorMessage:
              packageIntegration.error ?? 'Failed to integrate package',
        ),
      );
    }
  }

  Future<void> onCheckPackageIntegration(
    CheckPackageIntegration event,
    Emitter<PackageIntegrationState> emit,
  ) async {
    emit(state.copyWith(status: PackageIntegrationStatus.loading));

    final isIntegrated = await packageIntegrationRepository.isPackageIntegrated(
      projectPath: event.projectPath,
      packageName: event.packageName,
    );

    if (isIntegrated) {
      emit(
        state.copyWith(
          status: PackageIntegrationStatus.alreadyIntegrated,
          output: '${event.packageName} is already integrated',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: PackageIntegrationStatus.initial,
          output: '${event.packageName} is not yet integrated',
        ),
      );
    }
  }

  Future<void> onRunPubGet(
    RunPubGet event,
    Emitter<PackageIntegrationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PackageIntegrationStatus.pubGetRunning,
        output: 'Running flutter pub get...',
      ),
    );

    final output = await packageIntegrationRepository.runPubGet(
      event.projectPath,
    );

    if (output.toLowerCase().contains('error')) {
      emit(
        state.copyWith(
          status: PackageIntegrationStatus.failure,
          output: output,
          errorMessage: 'flutter pub get failed',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: PackageIntegrationStatus.success,
          output: output,
        ),
      );
    }
  }
}

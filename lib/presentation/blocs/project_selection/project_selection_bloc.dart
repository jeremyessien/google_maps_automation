import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/i_project_repository.dart';
import 'project_selection_event.dart';
import 'project_selection_state.dart';

class ProjectSelectionBloc
    extends Bloc<ProjectSelectionEvent, ProjectSelectionState> {
  final IProjectRepository projectRepository;

  ProjectSelectionBloc({required this.projectRepository})
    : super(const ProjectSelectionState()) {
    on<SelectProjectDirectory>(onSelectProjectDirectory);
    on<ValidateProject>(onValidateProject);
  }

  Future<void> onSelectProjectDirectory(
    SelectProjectDirectory event,
    Emitter<ProjectSelectionState> emit,
  ) async {
    emit(state.copyWith(status: ProjectSelectionStatus.loading));

    final directoryPath = await projectRepository.selectProjectDirectory();

    if (directoryPath != null) {
      emit(
        state.copyWith(
          status: ProjectSelectionStatus.selected,
          directoryPath: directoryPath,
        ),
      );
      add(ValidateProject(directoryPath));
    } else {
      emit(state.copyWith(status: ProjectSelectionStatus.initial));
    }
  }

  Future<void> onValidateProject(
    ValidateProject event,
    Emitter<ProjectSelectionState> emit,
  ) async {
    emit(state.copyWith(status: ProjectSelectionStatus.loading));

    final project = await projectRepository.validateProject(
      event.directoryPath,
    );

    if (project.isValid) {
      emit(
        state.copyWith(
          status: ProjectSelectionStatus.valid,
          project: project,
          directoryPath: event.directoryPath,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: ProjectSelectionStatus.invalid,
          errorMessage: 'Invalid flutter project : No pubspec.yaml found',
          directoryPath: event.directoryPath,
        ),
      );
    }
  }
}

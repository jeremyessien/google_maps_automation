import 'package:equatable/equatable.dart';

import '../../../domain/entities/projects.dart';

class ProjectSelectionState extends Equatable {
  final ProjectSelectionStatus status;
  final String? directoryPath;
  final Project? project;
  final String? errorMessage;

  const ProjectSelectionState({
    this.status = ProjectSelectionStatus.initial,
    this.project,
    this.directoryPath,
    this.errorMessage,
  });
  ProjectSelectionState copyWith({
    ProjectSelectionStatus? status,
    String? directoryPath,
    Project? project,
    String? errorMessage,
  }) {
    return ProjectSelectionState(
      status: status ?? this.status,
      directoryPath: directoryPath ?? this.directoryPath,
      project: project ?? this.project,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, directoryPath, project, errorMessage];
}

enum ProjectSelectionStatus { initial, loading, selected, valid, invalid }

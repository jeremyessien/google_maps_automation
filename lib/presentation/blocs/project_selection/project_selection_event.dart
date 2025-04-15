import 'package:equatable/equatable.dart';

abstract class ProjectSelectionEvent extends Equatable {
  const ProjectSelectionEvent();

  @override
  List<Object> get props => [];
}

class SelectProjectDirectory extends ProjectSelectionEvent {}

class ValidateProject extends ProjectSelectionEvent {
  final String directoryPath;

  const ValidateProject(this.directoryPath);

  @override
  List<Object> get props => [directoryPath];
}
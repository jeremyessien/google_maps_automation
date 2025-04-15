import '../../domain/entities/projects.dart';

class ProjectModel extends Project {
  ProjectModel({
    required super.directoryPath,
    super.isValid,
    super.pubspecContent,
  });

  factory ProjectModel.fromEntity(Project project) {
    return ProjectModel(
      directoryPath: project.directoryPath,
      isValid: project.isValid,
      pubspecContent: project.pubspecContent,
    );
  }

  factory ProjectModel.empty() {
    return ProjectModel(directoryPath: '');
  }
}

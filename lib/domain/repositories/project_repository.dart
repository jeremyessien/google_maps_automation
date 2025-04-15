import '../entities/projects.dart';

abstract class IProjectRepository {
  Future<String?> selectProjectDirectory();
  Future<Project> validateProject(String directoryPath);
}

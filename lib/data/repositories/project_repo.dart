
import '../../core/utils/file_utils.dart';
import '../../domain/entities/projects.dart';
import '../../domain/repositories/project_repository.dart';
import '../models/project_model.dart';

class ProjectRepository implements IProjectRepository {
  @override
  Future<String?> selectProjectDirectory() async {
    return await FileUtils.pickDirectory();
  }

  @override
  Future<Project> validateProject(String directoryPath) async {
    final isValid = FileUtils.isFlutterProject(directoryPath);
    String? pubspecContent;

    if (isValid) {
      pubspecContent = await FileUtils.readPubspecFile(directoryPath);
    }

    return ProjectModel(
      directoryPath: directoryPath,
      isValid: isValid,
      pubspecContent: pubspecContent,
    );
  }
}
import 'dart:async';

import '../../domain/entities/projects.dart';
import '../../domain/repositories/i_project_repository.dart';
import '../models/project_model.dart';

class MockProjectRepository implements IProjectRepository {
  @override
  Future<String?> selectProjectDirectory() async {

    await Future.delayed(const Duration(seconds: 1));
    return '/Users/developer/flutter_projects/demo_project';
  }

  @override
  Future<Project> validateProject(String directoryPath) async {

    await Future.delayed(const Duration(seconds: 1));

    return ProjectModel(
      directoryPath: directoryPath,
      isValid: true,
      pubspecContent: '''
name: demo_project
description: A demo Flutter project.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=2.18.0 <3.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
''',
    );
  }
}

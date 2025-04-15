import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/api_key_repository.dart';
import '../../data/repositories/package_integration_repository.dart';
import '../../data/repositories/project_repository.dart';
import '../../domain/entities/projects.dart';
import '../../presentation/blocs/api_key/api_key_bloc.dart';
import '../../presentation/blocs/package_integration/package_integration_bloc.dart';

import '../../presentation/blocs/project_selection/project_selection_bloc.dart';
import '../../presentation/screens/api_key/api_key_screen.dart';
import '../../presentation/screens/package_integration/package_integration_screen.dart';
import '../../presentation/screens/project_selection/project_selection_screen.dart';
import '../constants/route_constants.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case RouteConstants.initial:
      case RouteConstants.projectSelection:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create:
                    (_) => ProjectSelectionBloc(
                      projectRepository: ProjectRepository(),
                    ),
                child: ProjectSelectionScreen(),
              ),
        );

      case RouteConstants.packageIntegration:
        if (args is Project) {
          return MaterialPageRoute(
            builder:
                (_) => BlocProvider(
                  create:
                      (_) => PackageIntegrationBloc(
                        packageIntegrationRepository:
                            PackageIntegrationRepository(),
                      ),
                  child: PackageIntegrationScreen(project: args),
                ),
          );
        }
        return errorRoute();
      case RouteConstants.apiKeyManagement:
        if (args is Project) {
          return MaterialPageRoute(
            builder:
                (_) => BlocProvider(
                  create:
                      (_) => ApiKeyBloc(apiKeyRepository: ApiKeyRepository()),
                  child: ApiKeyScreen(project: args),
                ),
          );
        } else if (args is Map) {
          return MaterialPageRoute(
            builder:
                (_) => BlocProvider(
                  create:
                      (_) => ApiKeyBloc(apiKeyRepository: ApiKeyRepository()),
                  child: ApiKeyScreen(project: args['project']),
                ),
          );
        }
        return errorRoute();

      default:
        return errorRoute();
    }
  }

  static Route<dynamic> errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Route not found')),
        );
      },
    );
  }
}

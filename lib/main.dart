
import 'package:dev_task/core/constants/route_constants.dart';
import 'package:dev_task/core/factories/repository_factory.dart';
import 'package:dev_task/core/route/route_generator.dart';
import 'package:dev_task/data/services/demo_service.dart';
import 'package:dev_task/data/services/navigation_service.dart';
import 'package:dev_task/presentation/blocs/project_selection/project_selection_bloc.dart';
import 'package:dev_task/presentation/screens/project_selection/project_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final navigationService = NavigationService();
void main() {
  demoModeService.enableDemoMode();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Package Integrator',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigationService.navigatorKey,
      initialRoute: RouteConstants.projectSelection,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: BlocProvider(
        create:
            (context) =>
                ProjectSelectionBloc(projectRepository: RepositoryFactory.getProjectRepository()),
        child: ProjectSelectionScreen(),
      ),
    );
  }
}

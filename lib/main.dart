// lib/main.dart
import 'package:dev_task/presentation/blocs/project_selection/project_selection_bloc.dart';
import 'package:dev_task/presentation/screens/project_selection/project_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/project_repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Package Integrator',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: BlocProvider(
        create:
            (context) =>
                ProjectSelectionBloc(projectRepository: ProjectRepository()),
        child: ProjectSelectionScreen(),
      ),
    );
  }
}

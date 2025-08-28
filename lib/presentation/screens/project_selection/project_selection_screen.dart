import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/route_constants.dart';
import '../../../main.dart';
import '../../blocs/project_selection/project_selection_bloc.dart';
import '../../blocs/project_selection/project_selection_event.dart';
import '../../blocs/project_selection/project_selection_state.dart';
import '../../widgets/directory_picker_widget.dart';
import '../../widgets/project_validation_widget.dart';

class ProjectSelectionScreen extends StatelessWidget {
  const ProjectSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Flutter Project')),
      body: BlocConsumer<ProjectSelectionBloc, ProjectSelectionState>(
        listener: (context, state) {
          if (state.status == ProjectSelectionStatus.valid) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(child: Text('Valid Flutter project selected!')),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            navigationService.navigateTo(
              RouteConstants.packageIntegration,
              arguments: state.project,
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Select a Flutter project directory to integrate Google Maps:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                DirectoryPickerWidget(
                  onSelectDirectory: () {
                    context.read<ProjectSelectionBloc>().add(
                      SelectProjectDirectory(),
                    );
                  },
                ),

                const SizedBox(height: 20),

                if (state.status == ProjectSelectionStatus.loading)
                  const Center(child: CircularProgressIndicator.adaptive()),

                if (state.directoryPath != null &&
                    state.status != ProjectSelectionStatus.loading &&
                    state.status != ProjectSelectionStatus.initial)
                  ProjectValidationWidget(state: state),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          // Navigate or show message based on state status
          if (state.status == ProjectSelectionStatus.valid) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Valid Flutter project selected!')),
            );

            // Navigate to next screen
            // Navigator.of(context).push(...);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select a Flutter project directory to integrate Google Maps:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                // Directory Picker Widget
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

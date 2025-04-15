// lib/presentation/widgets/project_validation_widget.dart
import 'package:flutter/material.dart';

import '../blocs/project_selection/project_selection_state.dart';

class ProjectValidationWidget extends StatelessWidget {
  final ProjectSelectionState state;

  const ProjectValidationWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case ProjectSelectionStatus.selected:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selected Directory:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(state.directoryPath ?? ''),
            const SizedBox(height: 8),
            const Text('Validating...'),
          ],
        );

      case ProjectSelectionStatus.valid:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selected Directory:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(state.directoryPath ?? ''),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Valid Flutter Project',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
          ],
        );

      case ProjectSelectionStatus.invalid:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selected Directory:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(state.directoryPath ?? ''),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  state.errorMessage ?? 'Invalid project',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

// lib/presentation/widgets/project_validation_widget.dart
import 'dart:io';

import 'package:flutter/cupertino.dart';
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
            Row(
              children: [
                Platform.isAndroid ? Icon(Icons.check_circle_sharp, color: Colors.green) : Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.green,),
                const SizedBox(width: 8),
                const Text(
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

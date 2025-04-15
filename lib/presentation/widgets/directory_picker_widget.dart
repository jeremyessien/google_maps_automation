
import 'package:flutter/material.dart';

class DirectoryPickerWidget extends StatelessWidget {
  final VoidCallback onSelectDirectory;

  const DirectoryPickerWidget({
    super.key,
    required this.onSelectDirectory,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onSelectDirectory,
      icon: const Icon(Icons.folder_open),
      label: const Text('Select Flutter Project'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/projects.dart';
import '../../widgets/action_button.dart';

class IntegrationResultScreen extends StatelessWidget {
  final Project project;
  final String? filePath;

  const IntegrationResultScreen({
    super.key,
    required this.project,
    this.filePath,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Integration Complete')),
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
       controller: ScrollController(),
        children: [
           Icon(Platform.isAndroid ? Icons.check_circle : CupertinoIcons.checkmark_alt_circle_fill, color: Colors.green, size: 44),
          const SizedBox(height: 10),
          const Text(
            'Google Maps Integration Complete!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Project: ${project.directoryPath}',
            style: const TextStyle(fontSize: 16),
          ),
          if (filePath != null) ...[
            const SizedBox(height: 8),
            Text(
              'Example file: $filePath',
              style: const TextStyle(fontSize: 16),
            ),
          ],
          const SizedBox(height: 32),
          const Text(
            'Summary of Changes:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          summaryItem(
            'Added google_maps_flutter package to pubspec.yaml',

          ),
          summaryItem(
            'Configured Android manifest with API key',

          ),
          summaryItem(
            'Configured iOS Info.plist with API key',

          ),
          summaryItem('Added Google Maps example code', ),
          const SizedBox(height: 20),
          const Text(
            'Next Steps:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          nextStepItem(
            '1. Run your app with "flutter run"',
            'See the Google Maps in action',
          ),
          nextStepItem(
            '2. Customize the example code',
            'Add markers, polylines, and other features',
          ),
          nextStepItem(
            '3. Get a valid API key if needed',
            'Make sure your maps display correctly in production',
          ),
          const SizedBox(height: 20),
          ActionButton(
            width: double.maxFinite,
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },

           title: 'Finish',
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  Widget summaryItem(String text,) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(Platform.isAndroid? Icons.check_circle_sharp :CupertinoIcons.checkmark_alt_circle_fill, color: Colors.green),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget nextStepItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

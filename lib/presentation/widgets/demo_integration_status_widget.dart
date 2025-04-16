import 'package:flutter/material.dart';

import '../blocs/demo_integration/demo_integration_state.dart';

class DemoIntegrationStatusWidget extends StatelessWidget {
  final DemoIntegrationState state;

  const DemoIntegrationStatusWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case DemoIntegrationStatus.integrating:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 16),
                Text('Creating and integrating Google Maps example...'),
              ],
            ),
          ],
        );

      case DemoIntegrationStatus.success:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 16),
                Text('Google Maps example added successfully!'),
              ],
            ),
            const SizedBox(height: 16),
            Text('Example file created at: ${state.filePath}'),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Integration Complete!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'You can now run your Flutter app to see the Google Maps integration in action. '
                    'Remember that you need a valid API key for the maps to display correctly.',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Next Steps:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('1. Run your app with "flutter run"'),
                  Text('2. Customize the example code as needed'),
                  Text('3. Add markers, polylines, and other features'),
                ],
              ),
            ),
          ],
        );

      case DemoIntegrationStatus.failure:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    state.errorMessage ??
                        'Failed to integrate Google Maps example',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            if (state.filePath != null) ...[
              const SizedBox(height: 16),
              Text(
                'Note: An example file was created at ${state.filePath}, but could not be '
                'integrated into your main.dart file. You may need to manually add it to your app.',
              ),
            ],
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

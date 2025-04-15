import 'package:flutter/material.dart';

import '../blocs/package_integration/package_integration_state.dart';

class IntegrationStatusWidget extends StatelessWidget {
  final PackageIntegrationState state;

  const IntegrationStatusWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case PackageIntegrationStatus.loading:
      case PackageIntegrationStatus.integrating:
      case PackageIntegrationStatus.pubGetRunning:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Integration Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text(state.output ?? 'Processing...'),
              ],
            ),
          ],
        );

      case PackageIntegrationStatus.alreadyIntegrated:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Integration Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.blue),
                const SizedBox(width: 8),
                Text(state.output ?? 'Package is already integrated'),
              ],
            ),
          ],
        );

      case PackageIntegrationStatus.success:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Integration Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Text(state.output ?? 'Package successfully integrated'),
              ],
            ),
          ],
        );

      case PackageIntegrationStatus.failure:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Integration Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.errorMessage ?? 'Package integration failed',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            if (state.output != null) ...[
              const SizedBox(height: 8),
              const Text('Output:'),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  state.output!,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ],
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

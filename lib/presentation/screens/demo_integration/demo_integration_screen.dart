import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/route_constants.dart';
import '../../../domain/entities/projects.dart';
import '../../../main.dart';
import '../../blocs/demo_integration/demo_integration_bloc.dart';
import '../../blocs/demo_integration/demo_integration_event.dart';
import '../../blocs/demo_integration/demo_integration_state.dart';
import '../../widgets/action_button.dart';
import '../../widgets/demo_integration_status_widget.dart';

class DemoIntegrationScreen extends StatefulWidget {
  final Project project;

  const DemoIntegrationScreen({super.key, required this.project});

  @override
  State<DemoIntegrationScreen> createState() => _DemoIntegrationScreenState();
}

class _DemoIntegrationScreenState extends State<DemoIntegrationScreen> {
  @override
  void initState() {
    super.initState();

    startIntegration();
  }

  void startIntegration() {
    context.read<DemoIntegrationBloc>().add(
      IntegrateGoogleMapsExample(widget.project.directoryPath),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Maps Example')),
      body: BlocConsumer<DemoIntegrationBloc, DemoIntegrationState>(
        listener: (context, state) {
          if (state.status == DemoIntegrationStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Center(
                  child: Text('Google Maps example added successfully!'),
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project information
                Text(
                  'Project: ${widget.project.directoryPath}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 24),

                // Status section
                const Text(
                  'Integrating Google Maps Example:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Integration status widget
                DemoIntegrationStatusWidget(state: state),

                const Spacer(),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Retry button for failures
                    if (state.status == DemoIntegrationStatus.failure)
                      ActionButton(
                        onTap: startIntegration,
                        title: 'Retry Integration',
                      ),

                    // Finish button
                    if (state.status == DemoIntegrationStatus.success)
                      ActionButton(
                        onTap: () {
                          navigationService.navigateTo(
                            RouteConstants.integrationResult,
                            arguments: {
                              'project': widget.project,
                              'filePath': state.filePath,
                            },
                          );
                        },
                        title: 'Finish Integration',
                      ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

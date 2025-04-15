import 'package:dev_task/data/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/route_constants.dart';
import '../../../domain/entities/projects.dart';
import '../../blocs/package_integration_bloc/package_integration_bloc.dart';
import '../../blocs/package_integration_bloc/package_integration_event.dart';
import '../../blocs/package_integration_bloc/package_integration_state.dart';
import '../../widgets/integration_status_widget.dart';

class PackageIntegrationScreen extends StatelessWidget {
  final Project project;

  PackageIntegrationScreen({super.key, required this.project});

  final NavigationService navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Package Integration')),
      body: BlocConsumer<PackageIntegrationBloc, PackageIntegrationState>(
        listener: (context, state) {
          if (state.status == PackageIntegrationStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Package integrated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.status == PackageIntegrationStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Package integration failed',
                ),
                backgroundColor: Colors.red,
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
                const Text(
                  'Project:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(project.directoryPath),
                const SizedBox(height: 16),

                const Text(
                  'Package to integrate:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Text('google_maps_flutter'),
                const SizedBox(height: 24),

                if (state.status == PackageIntegrationStatus.initial ||
                    state.status == PackageIntegrationStatus.failure)
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<PackageIntegrationBloc>().add(
                        IntegratePackage(
                          projectPath: project.directoryPath,
                          packageName: 'google_maps_flutter',
                        ),
                      );
                    },
                    icon: const Icon(Icons.integration_instructions),
                    label: const Text('Integrate Package'),
                  ),

                const SizedBox(height: 16),

                IntegrationStatusWidget(state: state),

                if (state.status == PackageIntegrationStatus.alreadyIntegrated)
                  ElevatedButton(
                    onPressed: () {
                      navigationService.navigateTo(
                        RouteConstants.apiKeyManagement,
                        arguments: project,
                      );
                    },
                    child: const Text('Continue to API Key'),
                  ),

                if (state.status == PackageIntegrationStatus.success)
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to API Key page
                      // Navigator.of(context).push(...);
                    },
                    child: const Text('Continue to API Key'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:dev_task/data/services/navigation_service.dart';
import 'package:dev_task/presentation/widgets/action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/route_constants.dart';
import '../../../domain/entities/projects.dart';
import '../../../main.dart';
import '../../blocs/package_integration/package_integration_bloc.dart';
import '../../blocs/package_integration/package_integration_event.dart';
import '../../blocs/package_integration/package_integration_state.dart';
import '../../widgets/integration_status_widget.dart';

class PackageIntegrationScreen extends StatelessWidget {
  final Project project;

  const PackageIntegrationScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Package Integration')),
      body: BlocConsumer<PackageIntegrationBloc, PackageIntegrationState>(
        listener: (context, state) {
          if (state.status == PackageIntegrationStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Center(child: Text('Package integrated successfully!')),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.status == PackageIntegrationStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Center(
                  child: Text(
                    state.errorMessage ?? 'Package integration failed',
                  ),
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
                  ActionButton(
                    onTap: () {
                      context.read<PackageIntegrationBloc>().add(
                        IntegratePackage(
                          projectPath: project.directoryPath,
                          packageName: 'google_maps_flutter',
                        ),
                      );
                    },
                    title: 'Integrate Package',
                    androidIcon: Icons.integration_instructions_rounded,
                    iosIcon: CupertinoIcons.doc_text,
                  ),

                const SizedBox(height: 16),

                IntegrationStatusWidget(state: state),

                if (state.status == PackageIntegrationStatus.alreadyIntegrated)

                  ActionButton(
                    onTap: () {
                      navigationService.navigateTo(
                        RouteConstants.apiKeyManagement,
                        arguments: project,
                      );
                    },
                    title: 'Continue to Api Key',
                  ),


                  SizedBox(height: 20,),
                if (state.status == PackageIntegrationStatus.success)
                  ActionButton(
                    onTap: () {
                      navigationService.navigateTo(
                        RouteConstants.apiKeyManagement,
                        arguments: project,
                      );
                    },
                    title: 'Continue to Api Key',
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

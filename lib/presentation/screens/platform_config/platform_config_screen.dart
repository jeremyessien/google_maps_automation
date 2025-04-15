
import 'package:dev_task/data/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/route_constants.dart';
import '../../../domain/entities/projects.dart';
import '../../blocs/platform_config/platform_config_bloc.dart';
import '../../blocs/platform_config/platform_config_event.dart';
import '../../blocs/platform_config/platform_config_state.dart';
import '../../widgets/platform_status_widget.dart';



class PlatformConfigScreen extends StatefulWidget {
  final Project project;
  final String? apiKey;
  final bool isApiKeySkipped;

  const PlatformConfigScreen({
    super.key,
    required this.project,
    this.apiKey,
    this.isApiKeySkipped = false,
  });

  @override
  State<PlatformConfigScreen> createState() => _PlatformConfigScreenState();
}

class _PlatformConfigScreenState extends State<PlatformConfigScreen> {
  final NavigationService navigationService = NavigationService();
  @override
  void initState() {
    super.initState();

    startConfiguration();
  }

  void startConfiguration() {
    final apiKey = widget.apiKey ?? 'YOUR_API_KEY_HERE';


    context.read<PlatformConfigBloc>().add(
      ConfigureBothPlatforms(
        projectPath: widget.project.directoryPath,
        apiKey: apiKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform Configuration'),
      ),
      body: BlocConsumer<PlatformConfigBloc, PlatformConfigState>(
        listener: (context, state) {
          if (state.isFullyConfigured) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Platforms configured successfully!'),
                backgroundColor: Colors.green,
              ),
            );


            Future.delayed(const Duration(seconds: 2), () {
              navigationService.navigateTo(
                RouteConstants.demoIntegration,
                arguments: widget.project,
              );
            });
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
                  'Configuring Project: ${widget.project.directoryPath}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),


                const SizedBox(height: 16),
                Text(
                  widget.isApiKeySkipped
                      ? 'API Key: Skipped (using placeholder)'
                      : 'API Key: ${widget.apiKey ?? "Not provided"}',
                ),

                const SizedBox(height: 24),


                const Text(
                  'Platform Configuration Status:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),


                PlatformConfigStatusWidget(state: state),

                const Spacer(),


                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    if (state.status == PlatformConfigStatus.failure)
                      ElevatedButton(
                        onPressed: startConfiguration,
                        child: const Text('Retry Configuration'),
                      ),


                    if (state.isFullyConfigured)
                      ElevatedButton(
                        onPressed: () {
                          navigationService.navigateTo(
                            RouteConstants.demoIntegration,
                            arguments: widget.project,
                          );
                        },
                        child: const Text('Continue to Demo Integration'),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
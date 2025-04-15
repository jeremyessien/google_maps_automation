// lib/presentation/screens/api_key_screen.dart
import 'package:dev_task/data/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/route_constants.dart';
import '../../../domain/entities/projects.dart';
import '../../blocs/api_key_bloc/api_key_bloc.dart';
import '../../blocs/api_key_bloc/api_key_event.dart';
import '../../blocs/api_key_bloc/api_key_state.dart';
import '../../widgets/api_key_input_widget.dart';


class ApiKeyScreen extends StatefulWidget {
  final Project project;

  const ApiKeyScreen({
    super.key,
    required this.project,
  });

  @override
  State<ApiKeyScreen> createState() => _ApiKeyScreenState();
}

class _ApiKeyScreenState extends State<ApiKeyScreen> {
  final apiKeyController = TextEditingController();
  final NavigationService navigationService = NavigationService();

  @override
  void initState() {
    super.initState();

    context.read<ApiKeyBloc>().add(
      CheckApiKeyConfiguration(widget.project.directoryPath),
    );
  }

  @override
  void dispose() {
    apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps API Key'),
      ),
      body: BlocConsumer<ApiKeyBloc, ApiKeyState>(
        listener: (context, state) {
          if (state.status == ApiKeyStatus.valid ||
              state.status == ApiKeyStatus.skipped ||
              state.status == ApiKeyStatus.alreadyConfigured) {

            navigationService.navigateTo(
              RouteConstants.platformConfiguration,
              arguments: {
                'project': widget.project,
                'apiKey': state.apiKey,
                'isSkipped': state.isSkipped,
              },
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
                  'Enter your Google Maps API Key:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This key will be used for both Android and iOS configurations.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),


                if (state.status == ApiKeyStatus.loading ||
                    state.status == ApiKeyStatus.checking)
                  const Center(child: CircularProgressIndicator.adaptive()),


                if (state.status == ApiKeyStatus.alreadyConfigured)
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue.shade700),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Google Maps API key is already configured in your project.',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ApiKeyBloc>().add(const SkipApiKey());
                        },
                        child: const Text('Continue with existing API key'),
                      ),
                    ],
                  ),

                // Show API key input when not already configured
                if (state.status != ApiKeyStatus.alreadyConfigured &&
                    state.status != ApiKeyStatus.checking)
                  ApiKeyInputWidget(
                    controller: apiKeyController,
                    onChanged: (value) {
                      context.read<ApiKeyBloc>().add(InputApiKey(value));
                    },
                    onSubmitted: (value) {
                      context.read<ApiKeyBloc>().add(ValidateApiKey(value));
                    },
                    state: state,
                  ),

                const SizedBox(height: 24),

                // Action buttons (validate or skip)
                if (state.status != ApiKeyStatus.alreadyConfigured &&
                    state.status != ApiKeyStatus.checking &&
                    state.status != ApiKeyStatus.loading)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.read<ApiKeyBloc>().add(const SkipApiKey());
                        },
                        child: const Text('Skip (Not Recommended)'),
                      ),
                      ElevatedButton(
                        onPressed: apiKeyController.text.isNotEmpty
                            ? () {
                          context.read<ApiKeyBloc>().add(
                            ValidateApiKey(apiKeyController.text),
                          );
                        }
                            : null,
                        child: const Text('Validate & Continue'),
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
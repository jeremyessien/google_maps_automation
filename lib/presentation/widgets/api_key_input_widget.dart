import 'package:flutter/material.dart';

import '../blocs/api_key/api_key_state.dart';

class ApiKeyInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final ApiKeyState state;

  const ApiKeyInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Google Maps API Key',
            hintText: 'Enter your Google Maps API key',
            border: const OutlineInputBorder(),
            errorText:
                state.status == ApiKeyStatus.invalid
                    ? state.errorMessage
                    : null,
            suffixIcon:
                state.status == ApiKeyStatus.valid
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
          ),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        ),
        const SizedBox(height: 8),
        const Text(
          'You can get a Google Maps API key from the Google Cloud Console',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),

        if (state.status == ApiKeyStatus.initial ||
            state.status == ApiKeyStatus.invalid)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'How to get a Google Maps API key:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('1. Go to the Google Cloud Console'),
                  Text('2. Create a project or select an existing one'),
                  Text('3. Enable the Google Maps SDK for each platform'),
                  Text('4. Create API key credentials'),
                  Text('5. Copy and paste the key here'),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

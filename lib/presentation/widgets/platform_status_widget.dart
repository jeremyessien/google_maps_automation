import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../blocs/platform_config/platform_config_state.dart';

class PlatformConfigStatusWidget extends StatelessWidget {
  final PlatformConfigState state;

  const PlatformConfigStatusWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        platformStatus(
          platformName: 'Android',
          isConfiguring:
              state.status == PlatformConfigStatus.configuring &&
              state.currentTask?.contains('Android') == true,
          isConfigured: state.androidConfigured,
        ),

        const SizedBox(height: 16),

        platformStatus(
          platformName: 'iOS',
          isConfiguring:
              state.status == PlatformConfigStatus.configuring &&
              state.currentTask?.contains('iOS') == true,
          isConfigured: state.iosConfigured,
        ),

        if (state.errorMessage != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Platform.isAndroid ? Icons.error_outline : CupertinoIcons.info_circle, color: Colors.red.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    state.errorMessage!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ],
            ),
          ),
        ],

        if (state.isFullyConfigured) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Platform.isAndroid ? Icons.check_circle : CupertinoIcons.checkmark_alt_circle_fill, color: Colors.green, size: 24,),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Google Maps successfully configured for both platforms!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget platformStatus({
    required String platformName,
    required bool isConfiguring,
    required bool isConfigured,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$platformName:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        if (isConfiguring)
          Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              ),
              const SizedBox(width: 8),
              Text('Configuring $platformName...'),
            ],
          )
        else if (isConfigured)
          Row(
            children: [
              Icon(Platform.isAndroid ? Icons.check_circle : CupertinoIcons.checkmark_alt_circle_fill, color: Colors.green),
              const SizedBox(width: 8),
              Text('$platformName configured'),
            ],
          )
        else
          Row(
            children: [
              const Icon(Icons.pending, color: Colors.grey),
              const SizedBox(width: 8),
              Text('$platformName pending'),
            ],
          ),
      ],
    );
  }
}

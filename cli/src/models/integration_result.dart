class IntegrationResult {
  final String projectPath;
  final List<String> errors = [];
  final List<String> warnings = [];
  final List<String> info = [];

  bool isValidProject = false;
  bool isAlreadyIntegrated = false;
  bool backupCreated = false;
  bool dependencyAdded = false;
  bool pubGetSuccessful = false;
  bool integrationSuccessful = false;
  bool removalSuccessful = false;

  IntegrationResult({required this.projectPath});

  void addError(String error) {
    errors.add(error);
  }

  void addWarning(String warning) {
    warnings.add(warning);
  }

  void addInfo(String info) {
    this.info.add(info);
  }

  bool get hasErrors => errors.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;
  bool get isSuccessful => integrationSuccessful || removalSuccessful;

  String get summary {
    if (!isValidProject) {
      return '❌ Invalid Flutter project';
    }

    if (isAlreadyIntegrated) {
      return 'ℹ️  Google Maps already integrated';
    }

    if (integrationSuccessful) {
      return '✅ Google Maps successfully integrated';
    }

    if (removalSuccessful) {
      return '✅ Google Maps successfully removed';
    }

    if (hasErrors) {
      return '❌ Integration failed';
    }

    return '⚠️  Integration incomplete';
  }
}

class ProcessResult {
  final bool success;
  final String output;
  final String error;
  final int exitCode;

  ProcessResult({
    required this.success,
    required this.output,
    required this.error,
    required this.exitCode,
  });
}

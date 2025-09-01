class ProjectValidationResult {
  final String projectPath;
  final List<String> errors = [];
  final List<String> warnings = [];
  final List<String> info = [];

  // Project validity
  bool isValidFlutterProject = false;
  bool libDirectoryExists = false;
  bool mainDartExists = false;
  bool testDirectoryExists = false;

  // Google Maps integration
  bool googleMapsIntegrated = false;
  bool googleMapsUsed = false;

  // Platform existence
  bool androidPlatformExists = false;
  bool iosPlatformExists = false;

  // Android configuration
  bool androidApiKeyConfigured = false;
  bool androidInternetPermission = false;
  bool androidLocationPermission = false;
  int? androidMinSdkVersion;

  // iOS configuration
  bool iosApiKeyConfigured = false;
  bool iosLocationPermission = false;
  bool iosEmbeddedViewsEnabled = false;

  ProjectValidationResult({required this.projectPath});

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
  bool get isReadyForIntegration => isValidFlutterProject && !hasErrors;

  /// Get a summary of the validation
  String get summary {
    if (!isValidFlutterProject) {
      return '❌ Not a valid Flutter project';
    }

    if (hasErrors) {
      return '❌ Project has validation errors';
    }

    if (googleMapsIntegrated) {
      return '✅ Google Maps already integrated';
    }

    if (hasWarnings) {
      return '⚠️  Ready for integration (with warnings)';
    }

    return '✅ Ready for Google Maps integration';
  }
}

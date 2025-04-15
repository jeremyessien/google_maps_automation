class PlatformConfig {
  final bool androidConfigured;
  final bool iosConfigured;
  final String? errorMessage;

  PlatformConfig({
    this.androidConfigured = false,
    this.iosConfigured = false,
    this.errorMessage,
  });

  bool get isFullyConfigured => androidConfigured && iosConfigured;
}

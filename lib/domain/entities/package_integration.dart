class PackageIntegration {
  final String packageName;
  final String version;
  final bool isIntegrated;
  final String? error;

  PackageIntegration({
    required this.packageName,
    this.error,
    this.isIntegrated = false,
    this.version = 'latest',
  });
}

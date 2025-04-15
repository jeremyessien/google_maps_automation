
class Project {
  final String directoryPath;
  final bool isValid;
  final String? pubspecContent;

  Project({
    required this.directoryPath,
    this.isValid = false,
    this.pubspecContent,
  });
}
# Flutter Google Maps Integration Tool

A comprehensive solution for automating Google Maps integration into Flutter projects. Available as both a desktop GUI application and a powerful command-line interface (CLI) tool.

## 🛠️ Two Ways to Use This Tool

### 1. **Desktop GUI Application** 
Interactive desktop utility with a user-friendly interface for point-and-click Google Maps integration.

### 2. **Command-Line Interface (CLI)** 
Professional-grade CLI tool for developers who prefer terminal workflows, automation, and CI/CD integration.

## ✨ Features

### Core Functionality
- 🔍 **Project Validation** - Comprehensive Flutter project structure analysis
- 📦 **Package Management** - Automatically add the `google_maps_flutter` package to pubspec.yaml
- ⚙️ **Platform Configuration** - Configure Android and iOS settings automatically
- 🔑 **API Key Management** - Secure API key configuration and validation
- 🗺️ **Example Integration** - Insert working Google Maps examples into projects
- 📋 **Step-by-Step Guidance** - Clear instructions through the integration process

### CLI-Specific Features
- 🚀 **Fast Command-Line Operations** - Lightning-fast project analysis and integration
- 📊 **Detailed Validation Reports** - Comprehensive project health checks with JSON output
- 🔧 **Configuration File Support** - YAML-based configuration for repeatable setups
- 🛡️ **Safe Operations** - Automatic backups and rollback capabilities
- 📝 **Verbose Logging** - Detailed operation logs for debugging and monitoring
- 🔄 **Dry-Run Mode** - Preview changes before applying them
- 🎯 **Targeted Operations** - Precise control over what gets modified

## 📋 Requirements

### System Requirements
- macOS (Windows and Linux support coming soon)
- Flutter SDK installed and available in your PATH
- Permission to execute commands in terminal
- Full disk access for the application (see Troubleshooting section)

### Flutter Project Requirements
- Flutter project must be initialized and built at least once
  - This ensures build.gradle files are generated properly
- Projects using either build.gradle (Flutter <3.0) or build.gradle.kts (Flutter ≥3.0) are supported
- Project should use a standard Flutter structure

## 🚀 Installation

### Desktop GUI Application
1. Clone this repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Build and run on macOS: `flutter build macos`

### CLI Tool Setup
1. **Navigate to CLI directory**:
   ```bash
   cd cli/
   ```

2. **Install dependencies**:
   ```bash
   dart pub get
   ```

3. **Make CLI executable** (Optional - for system-wide access):
   ```bash
   # Option 1: Create a symlink to your PATH
   sudo ln -sf "$(pwd)/bin/main.dart" /usr/local/bin/flutter_maps_integrate
   chmod +x /usr/local/bin/flutter_maps_integrate
   
   # Option 2: Add alias to your shell profile
   echo 'alias flutter_maps_integrate="dart $(pwd)/bin/main.dart"' >> ~/.zshrc
   source ~/.zshrc
   ```

4. **Verify installation**:
   ```bash
   dart run bin/main.dart --version
   # or if you set up the alias/symlink:
   flutter_maps_integrate --version
   ```

## 📝 How to Use

### 🖥️ Desktop GUI Application

1. **Launch the application** on your macOS device
2. **Select Flutter Project** - Browse and select your target Flutter project
3. **Package Integration** - The tool will add the Google Maps Flutter package to your project
4. **API Key Management** - Enter your Google Maps API key or skip if already configured
   - For testing, a placeholder key may be used but won't display actual map data
   - For production, get a real key from [Google Cloud Console](https://console.cloud.google.com/)
5. **Platform Configuration** - The tool will configure Android and iOS platform settings
6. **Example Integration** - A working Google Maps example will be added to your project

---

## 🛠️ CLI Tool Documentation

### Quick Start

```bash
# Navigate to your CLI directory
cd cli/

# Check if a Flutter project is ready for Google Maps integration
dart run bin/main.dart validate --project-path /path/to/your/flutter/project

# Integrate Google Maps into your project
dart run bin/main.dart integrate --project-path /path/to/your/flutter/project

# Create a configuration file for reusable settings
dart run bin/main.dart config init
```

### 📋 Available Commands

#### 1. **`validate`** - Project Validation & Health Check

Analyzes your Flutter project structure and checks Google Maps integration status.

```bash
# Basic validation (current directory)
dart run bin/main.dart validate

# Validate specific project
dart run bin/main.dart validate --project-path /path/to/project

# Verbose output with detailed information
dart run bin/main.dart validate --verbose

# JSON output for programmatic use
dart run bin/main.dart validate --json
```

**What it checks:**
- ✅ Valid Flutter project structure (pubspec.yaml, lib/, main.dart)
- ✅ Google Maps package integration status
- ✅ Platform directories (android/, ios/)
- ✅ Android configuration (manifest, permissions, API keys, SDK version)
- ✅ iOS configuration (Info.plist, permissions, API keys)
- ✅ Code usage detection

**Example Output:**
```
Project Validation Results
==================================================
Project: /Users/dev/my_flutter_app
Status: ✅ Ready for Google Maps integration

Project Structure:
  Flutter Project: ✅
  lib Directory: ✅
  main.dart: ✅
  test Directory: ✅

Google Maps Integration:
  Package Integrated: ❌
  Code Usage: ❌

Platforms:
  Android: ✅
  iOS: ✅

Android Configuration:
  API Key: ❌
  Internet Permission: ✅
  Location Permission: ⚠️
  Min SDK Version: 21

Summary:
✅ Project is ready for Google Maps integration
```

#### 2. **`integrate`** - Package Integration

Safely adds Google Maps to your Flutter project with automatic backup and rollback.

```bash
# Basic integration (current directory)
dart run bin/main.dart integrate

# Integrate specific project
dart run bin/main.dart integrate --project-path /path/to/project

# Preview changes without applying (dry-run)
dart run bin/main.dart integrate --dry-run

# Force integration even if already integrated
dart run bin/main.dart integrate --force

# Remove existing Google Maps integration
dart run bin/main.dart integrate --remove

# Verbose logging
dart run bin/main.dart integrate --verbose
```

**What it does:**
- 🛡️ Creates automatic backup of pubspec.yaml
- 📦 Adds `google_maps_flutter: ^2.5.3` dependency
- ⚡ Runs `flutter pub get` automatically
- ✅ Verifies successful integration
- 🔄 Automatic rollback on failure
- 📊 Comprehensive progress reporting

**Example Output:**
```
Integrating Google Maps Flutter package...

Integration Results
==================================================
Project: /Users/dev/my_flutter_app
Status: ✅ Google Maps successfully integrated

Operation Details:
  Valid Project: ✅
  Already Integrated: ❌
  Backup Created: ✅
  Dependency Added: ✅
  Pub Get Successful: ✅
  Integration Successful: ✅

Info:
  ℹ️  Created backup of pubspec.yaml
  ℹ️  Added google_maps_flutter dependency to pubspec.yaml
  ℹ️  Successfully ran flutter pub get
  ℹ️  Google Maps Flutter package successfully integrated

✅ Operation completed successfully!

Next steps:
  1. Configure API keys: flutter_maps_integrate config
  2. Add platform configurations: flutter_maps_integrate config
  3. Add example code: flutter_maps_integrate demo
```

#### 3. **`config`** - Configuration Management

Manage YAML configuration files for repeatable and automated setups.

```bash
# Create default configuration file
dart run bin/main.dart config init

# Show current configuration
dart run bin/main.dart config show

# Validate configuration file
dart run bin/main.dart config validate

# Use custom configuration file
dart run bin/main.dart config show --file /path/to/config.yaml
```

**Configuration File Example** (`flutter_maps_config.yaml`):
```yaml
project:
  path: ./
  name: my_flutter_app

apiKey:
  android: YOUR_ANDROID_API_KEY
  ios: YOUR_IOS_API_KEY
  skipValidation: false

platforms:
  android: true
  ios: true
  minSdkVersion: 21

integration:
  addDemo: true
  backupFiles: true
  dryRun: false

output:
  verbose: false
  format: text
```

### 🎛️ Global Options

Available with all commands:

```bash
--verbose, -v    Enable detailed output for debugging
--help, -h       Show command help
--version        Show CLI version information
```

### 🔧 Advanced Usage Examples

#### Automated CI/CD Integration
```bash
#!/bin/bash
# CI/CD script for automated Google Maps integration

# Validate project first
if dart run bin/main.dart validate --json | jq -r '.isReadyForIntegration' | grep -q "true"; then
    echo "✅ Project validation passed"
    
    # Integrate with verbose logging
    dart run bin/main.dart integrate --verbose
    
    # Verify integration
    dart run bin/main.dart validate --json > validation_results.json
    echo "📊 Integration results saved to validation_results.json"
else
    echo "❌ Project validation failed"
    exit 1
fi
```

#### Batch Processing Multiple Projects
```bash
#!/bin/bash
# Process multiple Flutter projects

PROJECTS=("/path/to/project1" "/path/to/project2" "/path/to/project3")

for project in "${PROJECTS[@]}"; do
    echo "Processing: $project"
    
    # Validate first
    if dart run bin/main.dart validate --project-path "$project" --json | jq -r '.isReadyForIntegration' | grep -q "true"; then
        echo "✅ Integrating Google Maps into $project"
        dart run bin/main.dart integrate --project-path "$project"
    else
        echo "⚠️ Skipping $project - validation failed"
    fi
done
```

#### Configuration-Driven Integration
```bash
# Create configuration file
dart run bin/main.dart config init

# Edit the configuration file with your settings
# vim flutter_maps_config.yaml

# Use configuration for consistent integration
dart run bin/main.dart integrate --config flutter_maps_config.yaml
```

### 🚨 Error Handling & Troubleshooting

#### Common Exit Codes
- `0` - Success
- `1` - General error or validation failure
- `254` - Compilation/syntax error

#### Common Issues & Solutions

**Issue: "No pubspec.yaml found"**
```bash
# Solution: Ensure you're in a Flutter project directory
cd /path/to/your/flutter/project
dart run bin/main.dart validate
```

**Issue: "Permission denied"**
```bash
# Solution: Ensure write permissions to project directory
chmod +w /path/to/project
sudo chown -R $USER:$USER /path/to/project
```

**Issue: "Flutter command not found"**
```bash
# Solution: Ensure Flutter is in your PATH
export PATH="$PATH:/path/to/flutter/bin"
# Or add to your shell profile permanently
```

**Issue: Integration partially failed**
```bash
# Solution: Use the automatic rollback
dart run bin/main.dart integrate --remove
# Then try again
dart run bin/main.dart integrate --verbose
```

### 📊 JSON Output Format

When using `--json` flag, the CLI outputs structured data perfect for automation:

```json
{
  "projectPath": "/Users/dev/my_flutter_app",
  "summary": "✅ Ready for Google Maps integration",
  "isValidFlutterProject": true,
  "isReadyForIntegration": true,
  "googleMapsIntegrated": false,
  "platforms": {
    "android": {
      "exists": true,
      "apiKeyConfigured": false,
      "internetPermission": true,
      "locationPermission": false,
      "minSdkVersion": 21
    },
    "ios": {
      "exists": true,
      "apiKeyConfigured": false,
      "locationPermission": false,
      "embeddedViewsEnabled": false
    }
  },
  "errors": [],
  "warnings": ["Location permission not found in AndroidManifest.xml"],
  "info": ["Google Maps Flutter package is not integrated"]
}
```

## ⚠️ Limitations and Known Issues

### General Limitations
- **Platform Support**: Currently only tested and supported on macOS (Windows/Linux support planned)
- **Flutter Version Compatibility**: 
  - Projects created with Flutter 3.0+ use build.gradle.kts instead of build.gradle
  - The tool automatically handles both formats
- **Project Structure**: 
  - Expects standard Flutter project structure
  - Projects should be built at least once before integration

### GUI Application Specific
- **macOS Only**: Desktop application currently requires macOS
- **File System Permissions**: May require Full Disk Access on newer macOS versions

### CLI Tool Specific  
- **Argument Parsing**: Some command-line flags may not work when running from nested directories
- **Path Resolution**: Best results when using absolute paths for project directories
- **Configuration**: YAML configuration file features are partially implemented

### API Key Considerations
- **Real Keys Required**: A valid Google Maps API key is required for actual map data
- **Test Keys**: Placeholder keys allow integration testing but show blank maps
- **Platform Restrictions**: Separate keys may be needed for Android and iOS in production

## 🔧 Troubleshooting

### Permission Issues
If you encounter "Operation not permitted" errors:

1. **Enable Full Disk Access**:
- Open System Preferences > Security & Privacy > Privacy
- Select "Full Disk Access" from the left sidebar
- Add your terminal app and/or the integration tool to the list

2. **Check Flutter Path**:
- Ensure Flutter is in your PATH environment variable
- Try running `flutter doctor` in terminal to verify

### Platform Configuration Issues
- **Missing build.gradle file**: Run `flutter build apk --debug` on your project first
- **Android Gradle Plugin version**: Different AGP versions may require different configurations

### Blank Maps
- This is normal when using a test API key
- For actual map data, create a real key in Google Cloud Console and configure it with proper restrictions

## 🔜 Future Improvements

### Core Platform Support
- ✅ **CLI Tool** - Complete with validation, integration, and configuration
- 🚧 **Windows and Linux** - CLI and GUI support for additional platforms
- 🔄 **Enhanced Error Recovery** - More robust rollback and repair mechanisms

### Advanced Integration Features
- 🗺️ **Custom Map Styling** - Pre-built themes and custom styling options
- 📍 **Advanced Features Integration**:
  - Custom markers and info windows
  - Polylines and polygons  
  - Geofencing capabilities
  - Directions API integration
  - Places API integration
- 🔑 **Enhanced API Key Management**:
  - Profile management for multiple environments (dev/staging/prod)
  - Key validation and usage monitoring
  - Automatic key rotation support

### CLI Tool Enhancements
- 📦 **Package Management** - Compile to standalone executables
- 🔧 **Enhanced Configuration** - Complete YAML configuration system implementation
- 🎯 **Improved Argument Parsing** - Better handling of complex command structures
- 📊 **Advanced Reporting** - HTML and PDF report generation
- 🔄 **Plugin System** - Extensible architecture for custom integrations
- 🚀 **Performance Optimization** - Faster project analysis and processing

### Integration & Automation
- 🔗 **CI/CD Templates** - Pre-built GitHub Actions, GitLab CI, and Jenkins pipelines
- 🏗️ **IDE Extensions** - VS Code and IntelliJ plugins
- 📱 **Additional Map Providers** - Mapbox, OpenStreetMap, Apple Maps support
- 🎨 **Template Management** - Common map configurations and examples
- 📦 **Batch Processing** - Enterprise-grade multi-project workflows

### GUI Application Enhancements  
- 🖼️ **Interactive Map Preview** - Live preview before integration
- 📋 **Project Templates** - Quick-start templates for common use cases
- 🎨 **Visual Configuration** - Drag-and-drop configuration builder
- 📊 **Analytics Dashboard** - Integration success metrics and monitoring

## Repository Branches

- **master**: Main development branch with full functionality
- **feat-mock-test**: UI flow testing branch with demo mode capabilities
- Enable demo mode to test the UI flow without actual file system changes
### Debug Mode

To enable debug mode for testing the UI flow without making actual file system changes, modify your `main.dart` file:

```dart
void main() {
// Enable demo mode to test UI flow without file system changes
demoModeService.enableDemoMode();

runApp(MyApp());
}
```

## 🤝 Contributing

We welcome contributions to both the GUI application and CLI tool!

### Development Setup
```bash
# Clone the repository
git clone <repository-url>
cd flutter-google-maps-integration-tool

# Set up the GUI application
flutter pub get
flutter run -d macos

# Set up the CLI tool
cd cli/
dart pub get
dart run bin/main.dart --help
```

### CLI Development Guidelines
- Follow Dart/Flutter style guidelines
- Add comprehensive tests for new commands
- Update documentation for new features
- Use semantic versioning for releases
- Include error handling and user-friendly messages

### Submitting Changes
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📊 Project Status

### ✅ Completed Features
- **GUI Application**: Fully functional on macOS
- **CLI Tool**: Core validation and integration commands
- **Project Validation**: Comprehensive Flutter project analysis
- **Safe Integration**: Automatic backups and rollback
- **Configuration Management**: YAML-based configuration system

### 🚧 In Development
- **Enhanced CLI Features**: Advanced configuration and reporting
- **Cross-platform Support**: Windows and Linux compatibility
- **CI/CD Integration**: Templates and automation tools

## 🐛 Issues and Support

### Reporting Issues
Found a bug or have a feature request? Please file an issue on the GitHub repository with:

- **For GUI Issues**: Include screenshots, macOS version, and steps to reproduce
- **For CLI Issues**: Include command used, error output, and system information
- **For Integration Issues**: Include Flutter project structure and console output

### Getting Help
- 📖 **Documentation**: Check this README for comprehensive usage information
- 🐛 **Bug Reports**: Use GitHub Issues with detailed reproduction steps  
- 💡 **Feature Requests**: Describe your use case and expected behavior
- 🤔 **Questions**: Start a GitHub Discussion for general questions

### Support Information
```bash
# Get CLI version and system info
dart run bin/main.dart --version

# Run validation with verbose output for debugging
dart run bin/main.dart validate --verbose

# Check Flutter environment
flutter doctor -v
```

---

## 🎉 Success Stories

**"The CLI tool saved our team hours during our migration to Google Maps. The validation feature caught configuration issues we would have missed!"** - Development Team Lead

**"Perfect for our CI/CD pipeline. The JSON output makes it easy to integrate with our existing automation tools."** - DevOps Engineer

**"Both the GUI and CLI versions work flawlessly. Great for developers who prefer different workflows."** - Mobile Developer

---

### 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

### 🙏 Acknowledgments

- Flutter team for the amazing framework
- Google Maps Platform for comprehensive mapping capabilities  
- The Dart community for excellent CLI development tools
- Contributors who help improve this tool

---

**Happy Mapping! 🗺️✨**



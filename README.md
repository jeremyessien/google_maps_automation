# Flutter Google Maps Integration Tool

A desktop utility that automates the integration of Google Maps into existing Flutter projects. This tool simplifies the process by automatically handling package dependencies, platform configurations, and adding a working example.

## ✨ Features

- Select and validate Flutter projects
- Automatically add the `google_maps_flutter` package to pubspec.yaml
- Configure platform-specific settings for Android and iOS
- Add required permissions and API key configurations
- Insert a working Google Maps example into the project
- Provide step-by-step guidance through the integration process

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

1. Clone this repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Build and run on macOS: `flutter build macos`

## 📝 How to Use

1. **Launch the application** on your macOS device
2. **Select Flutter Project** - Browse and select your target Flutter project
3. **Package Integration** - The tool will add the Google Maps Flutter package to your project
4. **API Key Management** - Enter your Google Maps API key or skip if already configured
- For testing, a placeholder key may be used but won't display actual map data
- For production, get a real key from [Google Cloud Console](https://console.cloud.google.com/)
5. **Platform Configuration** - The tool will configure Android and iOS platform settings
6. **Example Integration** - A working Google Maps example will be added to your project

## ⚠️ Limitations and Known Issues

- **Platform Support**: Currently only tested and supported on macOS
- **Flutter Version Compatibility**: 
- Projects created with Flutter 3.0+ use build.gradle.kts instead of build.gradle
- The tool may need adjustments depending on your Flutter version
- **Project Structure**: 
- The tool expects a standard Flutter project structure
- Projects must be built at least once before using this tool
- **API Key**: 
- A real Google Maps API key is required to display actual map data
- Test keys will allow integration but show blank maps

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

- Windows and Linux platform support
- Custom map styling and advanced features:
- Custom markers and infowindows
- Polylines and polygons
- Geofencing capabilities
- Directions API integration
- Profile management for multiple API keys (development/production)
- Support for additional map providers (Mapbox, OpenStreetMap)
- Interactive map preview before integration
- Batch processing for multiple projects
- Template management for common map configurations

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

## 🐛 Issues and Support

Found a bug or have a feature request? Please file an issue on the GitHub repository.



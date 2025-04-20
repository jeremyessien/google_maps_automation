
class DemoModeService {
  static final DemoModeService _instance = DemoModeService._internal();

  factory DemoModeService() => _instance;

  DemoModeService._internal();

  bool _isDemoMode = false;

  bool get isDemoMode => _isDemoMode;

  void enableDemoMode() {
    _isDemoMode = true;
  }

  void disableDemoMode() {
    _isDemoMode = false;
  }

  void toggleDemoMode() {
    _isDemoMode = !_isDemoMode;
  }
}


final demoModeService = DemoModeService();
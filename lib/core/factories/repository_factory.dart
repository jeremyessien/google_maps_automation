
import '../../data/repositories/api_key_repository.dart';
import '../../data/repositories/demo_integration_repository.dart';

import '../../data/repositories/mock_api_key_repository.dart';
import '../../data/repositories/mock_demo_integration_repository.dart';
import '../../data/repositories/mock_package_integration_repository.dart';
import '../../data/repositories/mock_platform_config_repository.dart';
import '../../data/repositories/mock_repository.dart';
import '../../data/repositories/package_integration_repository.dart';
import '../../data/repositories/platform_config_repository.dart';
import '../../data/repositories/project_repository.dart';
import '../../data/services/demo_service.dart';
import '../../domain/repositories/i_api_key_repository.dart';
import '../../domain/repositories/i_demo_integration_repository.dart';

import '../../domain/repositories/i_package_repository.dart';
import '../../domain/repositories/i_platform_config_repository.dart';
import '../../domain/repositories/i_project_repository.dart';


class RepositoryFactory {
  static IProjectRepository getProjectRepository() {
    return demoModeService.isDemoMode
        ? MockProjectRepository()
        : ProjectRepository();
  }

  static IPackageIntegrationRepository getPackageIntegrationRepository() {
    return demoModeService.isDemoMode
        ? MockPackageIntegrationRepository()
        : PackageIntegrationRepository();
  }

  static IApiKeyRepository getApiKeyRepository() {
    return demoModeService.isDemoMode
        ? MockApiKeyRepository()
        : ApiKeyRepository();
  }

  static IPlatformConfigRepository getPlatformConfigRepository() {
    return demoModeService.isDemoMode
        ? MockPlatformConfigRepository()
        : PlatformConfigRepository();
  }

  static IDemoIntegrationRepository getDemoIntegrationRepository() {
    return demoModeService.isDemoMode
        ? MockDemoIntegrationRepository()
        : DemoIntegrationRepository();
  }
}
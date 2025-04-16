import 'package:equatable/equatable.dart';

abstract class DemoIntegrationEvent extends Equatable {
  const DemoIntegrationEvent();

  @override
  List<Object> get props => [];
}

class IntegrateGoogleMapsExample extends DemoIntegrationEvent {
  final String projectPath;

  const IntegrateGoogleMapsExample(this.projectPath);

  @override
  List<Object> get props => [projectPath];
}

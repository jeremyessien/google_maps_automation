import 'package:flutter/material.dart';

import '../../domain/services/i_navigation_service.dart';

class NavigationService implements INavigationService {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<T?> navigateTo<T>(String routeName, {Object? arguments}) {
    return _navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  @override
  Future<T?> navigateToAndReplace<T, TO>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return _navigatorKey.currentState!.pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  @override
  Future<T?> navigateToAndRemoveUntil<T>(
    String routeName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return _navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  @override
  void goBack<T>({T? result}) {
    return _navigatorKey.currentState!.pop<T>(result);
  }

  @override
  BuildContext? get currentContext => _navigatorKey.currentState?.context;
}

import 'package:flutter/material.dart';

abstract class INavigationService {
  GlobalKey<NavigatorState> get navigatorKey;

  Future<T?> navigateTo<T>(String routeName, {Object? arguments});

  Future<T?> navigateToAndReplace<T, TO>(
    String routeName, {
    TO? result,
    Object? arguments,
  });

  Future<T?> navigateToAndRemoveUntil<T>(
    String routeName,
    RoutePredicate predicate, {
    Object? arguments,
  });

  void goBack<T>({T? result});

  BuildContext? get currentContext;
}

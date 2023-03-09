import 'package:admin/presentation/pages/authentication/index.dart';
import 'package:admin/presentation/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

abstract class AppRoutes {
  static String get login => LoginPage.routeName;
  static String get register => RegisterPage.routeName;
  static String get home => HomePage.routeName;
  static String get splash => "";
  static String get onboarding => "";
}

final routeLoggedOut = RouteMap(
  onUnknownRoute: (_) => const Redirect(LoginPage.routeName),
  routes: {
    LoginPage.routeName: (_) => const MaterialPage(child: LoginPage()),
    RegisterPage.routeName: (_) => const MaterialPage(child: RegisterPage()),
    // SplashPage.routeName: (_) => const MaterialPage(child: SplashPage()),
    // OnboardingPage.routeName: (_) =>
    //     const MaterialPage(child: OnboardingPage()),
  },
);
final routeLoggedIn = RouteMap(
  onUnknownRoute: (_) => const Redirect(HomePage.routeName),
  routes: {
    // SplashPage.routeName: (_) => const MaterialPage(child: SplashPage()),
    LoginPage.routeName: (_) => const MaterialPage(child: LoginPage()),
    RegisterPage.routeName: (_) => const MaterialPage(child: RegisterPage()),
  },
);

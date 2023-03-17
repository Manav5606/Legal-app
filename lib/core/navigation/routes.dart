import 'package:admin/presentation/pages/authentication/index.dart';
import 'package:admin/presentation/pages/home/home_page.dart';
import 'package:admin/presentation/pages/landing/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

abstract class AppRoutes {
  static String get login => LoginPage.routeName;
  static String get register => RegisterPage.routeName;
  static String get home => HomePage.routeName;
}

final routeLoggedOut = RouteMap(
  onUnknownRoute: (_) => const Redirect(LandingPage.routeName),
  routes: {
    LandingPage.routeName: (_) => const MaterialPage(child: LandingPage()),
    LoginPage.routeName: (_) => const MaterialPage(child: LoginPage()),
    RegisterPage.routeName: (_) => const MaterialPage(child: RegisterPage()),
  },
);
final routeLoggedIn = RouteMap(
  onUnknownRoute: (_) => const Redirect(HomePage.routeName),
  routes: {
    LandingPage.routeName: (_) => const MaterialPage(child: LandingPage()),
    HomePage.routeName: (_) => const MaterialPage(child: HomePage()),
    // LoginPage.routeName: (_) => const MaterialPage(child: LoginPage()),
    // RegisterPage.routeName: (_) => const MaterialPage(child: RegisterPage()),
  },
);

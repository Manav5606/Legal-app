import 'package:admin/presentation/pages/authentication/index.dart';
import 'package:admin/presentation/pages/category_client/category_client_page.dart';
import 'package:admin/presentation/pages/home/home_page.dart';
import 'package:admin/presentation/pages/landing/landing_page.dart';
import 'package:admin/presentation/pages/profile/profile_page.dart';
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
    CategoryClientPage.routeName: (data) => MaterialPage(
        child: CategoryClientPage(
            categoryId: data.queryParameters['categoryId'] ?? "")),
  },
);
final routeLoggedIn = RouteMap(
  onUnknownRoute: (_) => const Redirect(LandingPage.routeName),
  routes: {
    LandingPage.routeName: (_) => const MaterialPage(child: LandingPage()),
    HomePage.routeName: (_) => const MaterialPage(child: HomePage()),
    CategoryClientPage.routeName: (data) => MaterialPage(
        child: CategoryClientPage(
            categoryId: data.queryParameters['categoryId'] ?? "")),
    ProfilePage.routeName: (data) => MaterialPage(
            child: ProfilePage(
          userID: data.queryParameters['userID'] ?? "",
        )),
  },
);
final routeAdminLoggedIn = RouteMap(
  onUnknownRoute: (_) => const Redirect(HomePage.routeName),
  routes: {
    HomePage.routeName: (_) => const MaterialPage(child: HomePage()),
    ProfilePage.routeName: (data) => MaterialPage(
            child: ProfilePage(
          userID: data.queryParameters['userID'] ?? "",
        )),
  },
);

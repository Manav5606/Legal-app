import 'package:admin/presentation/pages/authentication/index.dart';
import 'package:admin/presentation/pages/category_client/category_client_page.dart';
import 'package:admin/presentation/pages/home/home_page.dart';
import 'package:admin/presentation/pages/landing/landing_page.dart';
import 'package:admin/presentation/pages/profile/profile_page.dart';
import 'package:admin/presentation/pages/service_info/service_info_page.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../../presentation/pages/orders_admin_page/order_page.dart';

abstract class AppRoutes {
  static String get login => LoginPage.routeName;
  static String get register => RegisterPage.routeName;
  static String get home => HomePage.routeName;
  static String get order => OrderPage.routeName;
}

final routeLoggedOut = RouteMap(
  onUnknownRoute: (_) => const Redirect(LandingPage.routeName),
  routes: {
    LandingPage.routeName: (_) => const MaterialPage(child: LandingPage()),
    LoginPage.routeName: (data) => MaterialPage(
        child: LoginPage(
            navigateBack:
                data.queryParameters['navigateBack'] == "true" ? true : false)),
    RegisterPage.routeName: (data) => MaterialPage(
        child: RegisterPage(
            navigateBack:
                data.queryParameters['navigateBack'] == "true" ? true : false)),
    CategoryClientPage.routeName: (data) => MaterialPage(
        child: CategoryClientPage(
            categoryId: data.queryParameters['categoryId'] ?? "")),
    ServiceInfoPage.routeName: (data) => MaterialPage(
        child: ServiceInfoPage(
            serviceId: data.queryParameters['serviceId'] ?? "")),
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
    ServiceInfoPage.routeName: (data) => MaterialPage(
        child: ServiceInfoPage(
            serviceId: data.queryParameters['serviceId'] ?? "")),
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
    OrderPage.routeName: (data) => MaterialPage(
            child: OrderPage(
          orderID: data.queryParameters['orderID'] ?? "",
        )),
  },
);

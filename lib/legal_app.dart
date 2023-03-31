import 'package:admin/core/enum/role.dart';
import 'package:admin/core/navigation/routes.dart';
import 'package:admin/core/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'data/models/models.dart';

final _isAuthenticateProvider =
    Provider<bool>((ref) => ref.watch(AppState.auth).isAuthenticated);
final _isAuthLoading =
    Provider<bool>((ref) => ref.watch(AppState.auth).isLoading);

final globalScaffold = GlobalKey<ScaffoldMessengerState>();

class LegalApp extends ConsumerStatefulWidget {
  const LegalApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LegalAppState();
}

class _LegalAppState extends ConsumerState<LegalApp> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(_isAuthLoading);
    if (isLoading) {
      return Container();
    }
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: globalScaffold,
      routeInformationParser: const RoutemasterParser(),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        final isAuthenticated = ref.watch(_isAuthenticateProvider);
        final User? user = ref.read(AppState.auth).user;

        return isAuthenticated
            ? (user?.userType ?? UserType.client) == UserType.admin
                ? routeAdminLoggedIn
                : routeLoggedIn
            : routeLoggedOut;
      }),
    );
  }
}

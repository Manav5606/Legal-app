import 'package:admin/core/navigation/routes.dart';
import 'package:admin/core/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

final _isAuthenticateProvider =
    Provider<bool>((ref) => ref.watch(AppState.auth).isAuthenticated);
final _isAuthLoading =
    Provider<bool>((ref) => ref.watch(AppState.auth).isLoading);

final globalScaffold = GlobalKey<ScaffoldMessengerState>();

class LegalAdmin extends ConsumerStatefulWidget {
  const LegalAdmin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LegalAdminState();
}

class _LegalAdminState extends ConsumerState<LegalAdmin> {
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
        return isAuthenticated ? routeLoggedIn : routeLoggedOut;
      }),
    );
  }
}

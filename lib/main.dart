import 'package:admin/legal_admin.dart';
import 'package:admin/presentation/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(child: LayoutBuilder(builder: (context, constraints) {
    ScreenUtil.init(constraints,
        designSize: Size(constraints.maxWidth, constraints.maxHeight));
    return const LegalAdmin();
  })));
}

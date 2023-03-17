import 'package:admin/legal_admin.dart';
import 'package:admin/presentation/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  runApp(ProviderScope(child: LayoutBuilder(builder: (context, constraints) {
    ScreenUtil.init(constraints,
        designSize: Size(constraints.maxWidth, constraints.maxHeight));
    return const LegalAdmin();
  })));
}

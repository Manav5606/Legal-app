import 'dart:developer';

import 'package:admin/core/provider.dart';
import 'package:admin/presentation/pages/category_client/category_client_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryClientPage extends ConsumerStatefulWidget {
  static const String routeName = "/categoryClient";
  final String categoryId;
  const CategoryClientPage({super.key, required this.categoryId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoryClientPageState();
}

class _CategoryClientPageState extends ConsumerState<CategoryClientPage> {
  late final CategoryClientPageViewModel _viewModel;
  late bool isAuthenticated;

  @override
  void initState() {
    _viewModel = ref.read(CategoryClientPageViewModel.provider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isAuthenticated = ref.watch(AppState.auth).isAuthenticated;
    if (!isAuthenticated) {
      log("User is not authenticated");
    }
    return Scaffold(
      
    );
  }
}

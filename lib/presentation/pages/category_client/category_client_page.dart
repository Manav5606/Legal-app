import 'dart:developer';

import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/category_client/category_client_view_model.dart';
import 'package:admin/presentation/pages/widgets/contact_us.dart';
import 'package:admin/presentation/pages/widgets/contact_us_card.dart';
import 'package:admin/presentation/pages/widgets/footer.dart';
import 'package:admin/presentation/pages/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.initCategoryInfo(widget.categoryId);
    });
    super.initState();
  }

// TODO make it dynamic
  final _contactDetails = [
    Category(
      id: "b",
      name: "Phone",
      iconUrl: "",
      description: "Lorem Ipsum",
      addedAt: DateTime.now().millisecondsSinceEpoch,
      addedBy: "",
    ),
    Category(
      id: "f",
      name: "Office",
      iconUrl: "",
      description: "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum",
      addedAt: DateTime.now().millisecondsSinceEpoch,
      addedBy: "",
    ),
    Category(
      id: "l",
      name: "Working hours",
      iconUrl: "",
      description: "Lorem Ipsum",
      addedAt: DateTime.now().millisecondsSinceEpoch,
      addedBy: "",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    isAuthenticated = ref.watch(AppState.auth).isAuthenticated;
    ref.watch(CategoryClientPageViewModel.provider);
    if (!isAuthenticated) {
      log("User is not authenticated");
    }
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: _viewModel.isLoading || _viewModel.selectedCategory == null
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ScreenTypeLayout.builder(
              mobile: (context) => ListView(
                children: [
                  const Header(mobile: true),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.8,
                    decoration: BoxDecoration(
                      color: AppColors.blueColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Text(_viewModel.selectedCategory!.name),
                        ..._viewModel.getServices.map(expandServices).toList(),
                      ],
                    ),
                  ),
                  const ContactUs(height: 250, mobile: true),
                  const Footer(),
                ],
              ),
              desktop: (context) => ListView(
                children: [
                  const Header(mobile: false),
                  //
                  const ContactUs(height: 250),
                  ContactUsCard(contactDetails: _contactDetails, height: 200),
                  const Footer(),
                ],
              ),
            ),
    );
  }

  ExpansionTile expandServices(Service data) {
    return ExpansionTile(
      backgroundColor: AppColors.whiteColor,
      shape: Border.all(),
      title: ListTile(
        dense: true,
        title: Text(data.shortDescription),
      ),
      children: data.childServices.map((e) {
        final service = _viewModel.getServiceByID(e);
        return service.childServices.isNotEmpty
            ? expandServices(service)
            : showServices(service);
      }).toList(),
    );
  }

  Widget showServices(Service data) {
    return data.shortDescription.isEmpty || data.ourPrice == null
        ? const SizedBox.shrink()
        : ListTile(
            onTap: () {
              // TODO
              Messenger.showSnackbar(
                  "Client selected ${data.shortDescription}.");
            },
            dense: true,
            title: Text(data.shortDescription),
            trailing: const Icon(Icons.check_circle),
          );
  }
}

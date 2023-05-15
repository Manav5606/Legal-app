import 'dart:developer';
import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/category_client/category_client_view_model.dart';
import 'package:admin/presentation/pages/service_info/service_info_page.dart';
import 'package:admin/presentation/pages/widgets/contact_us.dart';
import 'package:admin/presentation/pages/widgets/contact_us_card.dart';
import 'package:admin/presentation/pages/widgets/footer.dart';
import 'package:admin/presentation/pages/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:routemaster/routemaster.dart';

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
      _viewModel.fetchContacts();
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
                children: const [
                  Header(mobile: true),
                  CategoryContainer(mobile: true),
                  ContactUs(height: 250, mobile: true),
                  Footer(),
                ],
              ),
              desktop: (context) => ListView(
                children: [
                  const Header(mobile: false),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.2,
                          vertical: 24),
                      child: const CategoryContainer(mobile: false)),
                  const ContactUs(height: 250),
                  ContactUsCard(
                      contactDetails: _viewModel.getContacts,
                      height: MediaQuery.of(context).size.height * 0.4),
                  const Footer(),
                ],
              ),
            ),
    );
  }
}

class CategoryContainer extends ConsumerStatefulWidget {
  const CategoryContainer({
    super.key,
    this.mobile = false,
  });
  final bool mobile;

  @override
  ConsumerState<CategoryContainer> createState() => _CategoryContainerState();
}

class _CategoryContainerState extends ConsumerState<CategoryContainer> {
  late final CategoryClientPageViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ref.read(CategoryClientPageViewModel.provider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(CategoryClientPageViewModel.provider);
    return Container(
      width: MediaQuery.of(context).size.width * (widget.mobile ? 0.8 : 0.5),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.blueColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Center(
              child: Text(_viewModel.selectedCategory!.name,
                  style: FontStyles.font24Semibold
                      .copyWith(color: AppColors.yellowColor))),
          const SizedBox(height: 12),
          ..._viewModel.getServices.map(expandServices).toList(),
        ],
      ),
    );
  }

  Widget expandServices(Service data) {
    return Column(
      children: [
        ExpansionTile(
          backgroundColor: AppColors.whiteColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          collapsedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          collapsedBackgroundColor: AppColors.whiteColor,
          title: ListTile(
            dense: true,
            title:
                Text(data.shortDescription, style: FontStyles.font14Semibold),
          ),
          children: data.childServices.map((e) {
            final service = _viewModel.getServiceByID(e);
            return service.childServices.isNotEmpty
                ? expandServices(service)
                : showServices(service);
          }).toList(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget showServices(Service data) {
    return data.shortDescription.isEmpty || data.ourPrice == null
        ? const SizedBox.shrink()
        : ListTile(
            leading: const SizedBox.shrink(),
            minLeadingWidth: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onTap: () {
              Routemaster.of(context).push(ServiceInfoPage.routeName,
                  queryParameters: {"serviceId": data.id!});
            },
            dense: true,
            title: Text(data.shortDescription,
                style: FontStyles.font12Medium
                    .copyWith(color: AppColors.blackColor)),
            trailing: const Icon(Icons.check_circle),
          );
  }
}

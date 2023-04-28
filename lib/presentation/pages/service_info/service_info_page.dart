// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/authentication/index.dart';
import 'package:admin/presentation/pages/landing/landing_page.dart';
import 'package:admin/presentation/pages/order_detail_client/order_detail_page.dart';
import 'package:admin/presentation/pages/service_info/service_info_view_model.dart';
import 'package:admin/presentation/pages/widgets/contact_us.dart';
import 'package:admin/presentation/pages/widgets/contact_us_card.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:admin/presentation/pages/widgets/footer.dart';
import 'package:admin/presentation/pages/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:routemaster/routemaster.dart';

class ServiceInfoPage extends ConsumerStatefulWidget {
  static const String routeName = "/serviceInfo";
  final String serviceId;
  const ServiceInfoPage({super.key, required this.serviceId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ServiceInfoPageState();
}

class _ServiceInfoPageState extends ConsumerState<ServiceInfoPage> {
  late final ServiceInfoPageViewModel _viewModel;

  late bool isAuthenticated;

  @override
  void initState() {
    _viewModel = ref.read(ServiceInfoPageViewModel.provider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.initServiceInfo(widget.serviceId);
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
    ref.watch(ServiceInfoPageViewModel.provider);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: _viewModel.isLoading || _viewModel.selectedService == null
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ScreenTypeLayout.builder(
              mobile: (context) => ListView(
                children: const [
                  Header(mobile: true),
                  ServiceInfo(),
                  ContactUs(height: 250, mobile: true),
                  Footer(),
                ],
              ),
              desktop: (context) => ListView(
                children: [
                  const Header(mobile: false),
                  const ServiceInfo(),
                  const ContactUs(height: 250),
                  ContactUsCard(contactDetails: _contactDetails, height: 200),
                  const Footer(),
                ],
              ),
            ),
    );
  }
}

class ServiceInfo extends ConsumerStatefulWidget {
  const ServiceInfo({
    super.key,
  });

  @override
  ConsumerState<ServiceInfo> createState() => _ServiceInfoState();
}

class _ServiceInfoState extends ConsumerState<ServiceInfo> {
  late final ServiceInfoPageViewModel _viewModel;
  late bool isAuthenticated;
  @override
  void initState() {
    _viewModel = ref.read(ServiceInfoPageViewModel.provider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(ServiceInfoPageViewModel.provider);
    isAuthenticated = ref.watch(AppState.auth).isAuthenticated;
    if (!isAuthenticated) {
      log("User is not authenticated");
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_viewModel.selectedService!.shortDescription,
              style: FontStyles.font14Semibold
                  .copyWith(color: AppColors.blueColor)),
          Text(_viewModel.selectedService!.aboutDescription,
              style: FontStyles.font12Regular
                  .copyWith(color: AppColors.blueColor)),
          Text("Documents Required",
              style: FontStyles.font14Semibold
                  .copyWith(color: AppColors.blueColor)),
          // TODO fieldDescription can be a better option here.
          ..._viewModel.getRequiredDataFields
              .map((e) => Text("- ${e.fieldName}",
                  style: FontStyles.font12Regular
                      .copyWith(color: AppColors.blueColor)))
              .toList(),
          const Divider(),
          RichText(
            text: TextSpan(
                text: "Final Price  ",
                style: FontStyles.font14Semibold
                    .copyWith(color: AppColors.blueColor),
                children: [
                  TextSpan(
                      text: "${_viewModel.selectedService?.marketPrice}",
                      style: FontStyles.font14Semibold
                          .copyWith(decoration: TextDecoration.lineThrough)),
                  TextSpan(
                      text: "   ${_viewModel.selectedService?.ourPrice}",
                      style: FontStyles.font16Semibold),
                ]),
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () async {
                    Routemaster.of(context).history.back();
                  },
                  child: const Text("Cancel")),
              CTAButton(
                  title: "Buy Now",
                  color: AppColors.greenColor,
                  fullWidth: false,
                  mobile: true,
                  loading: _viewModel.isLoading,
                  onTap: () async {
                    if (isAuthenticated) {
                      // await _viewModel.createPurchase();
                      final orderId =
                          await _viewModel.createTransaction(rpData: {});
                      if (orderId != null) {
                        Routemaster.of(context).popUntil((routeData) =>
                            routeData.path == LandingPage.routeName);
                        Routemaster.of(context).push(OrderDetailPage.routeName,
                            queryParameters: {"orderID": orderId});
                      }
                    } else {
                      Routemaster.of(context).push(LoginPage.routeName,
                          queryParameters: {"navigateBack": true.toString()});
                    }
                  },
                  radius: 4),
            ],
          ),
        ],
      ),
    );
  }
}

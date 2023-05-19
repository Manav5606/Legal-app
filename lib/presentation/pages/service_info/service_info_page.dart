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

import '../../successfull_order/successfull_order.dart';
import '../widgets/freeze_header.dart';

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
              mobile: (context) => CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    delegate:
                        CustomSliverPersistentHeaderDelegate(mobile: true),
                    floating: false,
                    pinned: true,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                  ServiceInfo(mobile: true),
                  ContactUs(height: 250, mobile: true),
                  Footer(),
                ],
                    ),),],
              ),
              desktop: (context) => CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    delegate:
                        CustomSliverPersistentHeaderDelegate(mobile: false),
                    floating: false,
                    pinned: true,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                  ServiceInfo(),
                  ContactUs(height: 250),
                  Footer(),
                      ],),),
                ],
              ),
            ),
    );
  }
}

class ServiceInfo extends ConsumerStatefulWidget {
  final bool mobile;
  const ServiceInfo({super.key, this.mobile = false});

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
          Text("Service Type > ${_viewModel.selectedService!.title}",
              style: FontStyles.font12Regular
                  .copyWith(color: AppColors.blueColor)),
          const SizedBox(height: 24),
          Text(_viewModel.selectedService!.title,
              style: FontStyles.font20Semibold
                  .copyWith(color: AppColors.darkBlueColor)),
          Text(_viewModel.selectedService!.shortDescription,
              style: FontStyles.font12Regular
                  .copyWith(color: AppColors.darkBlueColor, fontSize: 14)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("About the Product",
                        style: FontStyles.font18Semibold
                            .copyWith(color: AppColors.darkBlueColor)),
                    Text(_viewModel.selectedService!.aboutDescription,
                        style: FontStyles.font12Regular.copyWith(
                            color: AppColors.blueColor, fontSize: 14)),
                    const SizedBox(height: 24),
                    Text("Documents Required",
                        style: FontStyles.font18Semibold
                            .copyWith(color: AppColors.darkBlueColor)),
                    ..._viewModel.getRequiredDataFields
                        .map((e) => Text("· ${e.fieldDescription}",
                            style: FontStyles.font12Regular
                                .copyWith(color: AppColors.blueColor)))
                        .toList(),
                    Text("(in JPEG format, maximum size 100 KB)",
                        style: FontStyles.font11Light
                            .copyWith(color: AppColors.blueColor)),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Visibility(
                    visible: !widget.mobile,
                    child: priceInfo(context, mobile: widget.mobile)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Visibility(
              visible: widget.mobile,
              child: priceInfo(context, mobile: widget.mobile)),
        ],
      ),
    );
  }

  Container priceInfo(BuildContext context, {bool mobile = false}) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.lightBlueColor,
          borderRadius: BorderRadius.circular(24)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Pricing Summary",
              style: FontStyles.font18Semibold
                  .copyWith(color: AppColors.darkBlueColor)),
          const SizedBox(height: 12),
          Text(
              "Market Price: ₹${_viewModel.selectedService?.marketPrice ?? 0.0}",
              style: FontStyles.font12Regular
                  .copyWith(color: AppColors.blueColor)),
          const SizedBox(height: 12),
          Text("Our Price: ₹${_viewModel.selectedService?.ourPrice ?? 0.0}",
              style: FontStyles.font12Regular
                  .copyWith(color: AppColors.blueColor)),
          const SizedBox(height: 12),
          Text(
              "You Save ${(100 - ((_viewModel.selectedService?.ourPrice ?? 0.0) * 100 / (_viewModel.selectedService?.marketPrice ?? 0.0))).toStringAsFixed(2)}%",
              style: FontStyles.font12Regular
                  .copyWith(color: AppColors.greenColor)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () async {
                    Routemaster.of(context).history.back();
                  },
                  child: const Text("Cancel")),
              CTAButton(
                  title: "Buy Now",
                  color: AppColors.darkGreenColor,
                  fullWidth: false,
                  mobile: true,
                  loading: _viewModel.isLoading,
                  onTap: () async {
                    if (isAuthenticated) {
                      // await _viewModel.createPurchase();
                      
                      final orderId =
                          await _viewModel.createTransaction(rpData: {});
                            Routemaster.of(context).push(OrderDetailPage.routeName,
                            queryParameters: {"orderID": orderId!});
                      if (orderId != null) {
                        // await Routemaster.of(context).popUntil((routeData) {
                        //   return routeData.path == LandingPage.routeName;
                        // });
                     
                        // showDialog(
                        //   context: context,
                        //   barrierDismissible: false,
                        //   builder: (_) => AlertDialog(
                        //     title: Text("Order Placed",
                        //         style: FontStyles.font20Semibold),
                        //     content: Column(
                        //       children: [
                        //         Text("#OrderID: ${orderId}"),
                        //         Text("Order Status: Order Created"),
                        //         Text("Payment Status: Paid"),
                        //         Text(
                        //             "Paid Amount: ${_viewModel.selectedService?.ourPrice ?? 0.0}")
                        //       ],
                        //     ),
                        //     actions: [
                        //       TextButton(
                        //           onPressed: () async {
                        //             await Routemaster.of(context).popUntil(
                        //                 (routeData) =>
                        //                     routeData.path ==
                        //                     LandingPage.routeName);
                        //             Routemaster.of(context).push(
                        //                 OrderDetailPage.routeName,
                        //                 queryParameters: {"orderID": orderId});
                        //           },
                        //           child: const Text("View")),
                        //     ],
                        //   ),
                        // );
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

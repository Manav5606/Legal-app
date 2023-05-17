import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/core/provider.dart';
import 'package:intl/intl.dart';
import 'package:admin/data/models/general_stat.dart';
import 'package:admin/presentation/pages/landing/landing_page_view_model.dart';
import 'package:admin/presentation/pages/landing/widgets/services.dart';
import 'package:admin/presentation/pages/widgets/banner.dart';
import 'package:admin/presentation/pages/widgets/contact_us.dart';
import 'package:admin/presentation/pages/widgets/contact_us_card.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:admin/presentation/pages/widgets/custom_mobile_drawer.dart';
import 'package:admin/presentation/pages/widgets/customer_review_slider.dart';
import 'package:admin/presentation/pages/widgets/footer.dart';
import 'package:admin/presentation/pages/widgets/frequent_service_container.dart';
import 'package:admin/presentation/pages/widgets/general_stat_container.dart';
import 'package:admin/presentation/pages/widgets/header.dart';
import 'package:admin/presentation/pages/widgets/news_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:admin/data/models/models.dart' as model;
import '../../../data/models/news.dart';
import '../../../data/models/stats.dart';
import '../widgets/circular_arrow.dart';

final landingScaffold = GlobalKey<ScaffoldState>();

class NewsDetail extends ConsumerStatefulWidget {
  final String? title;
  final String? desc;
  final String? createdAt;
  static const String routeName = "/newsDetails";

  const NewsDetail({super.key, this.title, this.desc, this.createdAt});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewsDetailState();
}

class _NewsDetailState extends ConsumerState<NewsDetail> {
 
  late bool isAuthenticated;

  late final LandingPageViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ref.read(LandingPageViewModel.provider);
    // _viewModel.fetchServices();
    _viewModel.fetchNews();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    isAuthenticated = ref.watch(AppState.auth).isAuthenticated;
    ref.watch(LandingPageViewModel.provider);
    return Scaffold(
      key: landingScaffold,
      endDrawerEnableOpenDragGesture: false,
      endDrawer: CustomMobileDrawer(categories: _viewModel.getCategories),
      backgroundColor: AppColors.whiteColor,
      body: _viewModel.isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ScreenTypeLayout.builder(
              mobile: (context) => ListView(
                children: [
                  const Header(mobile: true),
                  Visibility(
                    visible: _viewModel.getBanners.isNotEmpty,
                    child: BannerSlides(
                      mobile: true,
                      height: 250,
                      bannerDetails: _viewModel.getBanners,
                    ),
                  ),
                  // Services(height: 0, category: _viewModel.getCategories),
                  // _frequentlyUsedServices(300, mobile: true),
                  _newsAndUpdates(800),
                  // Center(child: _Statss(300, mobile: true)),
                  // Visibility(
                  //   visible: _viewModel.getReviews.isNotEmpty,
                  //   child: CustomerReviewSlides(
                  //       customerReviews: _viewModel.getReviews,
                  //       height: MediaQuery.of(context).size.width,
                  //       mobile: true),
                  // ),
                  // const ContactUs(height: 250, mobile: true),
                  const Footer(),
                ],
              ),
              desktop: (context) => ListView(
                children: [
                  const Header(mobile: false),
                  Visibility(
                    visible: _viewModel.getBanners.isNotEmpty,
                    child: BannerSlides(
                      mobile: false,
                      height: 700,
                      bannerDetails: _viewModel.getBanners,
                    ),
                  ),
                  // Services(height: 700, category: _viewModel.getCategories),
                  // _frequentlyUsedServices(350),
                  _newsAndUpdates(400),
                  // Center(child: _Statss(300)),
                  // Visibility(
                  //     visible: _viewModel.getReviews.isNotEmpty,
                  //     child: CustomerReviewSlides(
                  //         customerReviews: _viewModel.getReviews, height: 700)),

                  // const ContactUs(height: 250),
                  // ContactUsCard(
                  //     contactDetails: _viewModel.getContacts, height: 250),
                  const Footer(),
                ],
              ),
            ),
    );
  }

  

  Widget _newsAndUpdates(double height) {
    return SizedBox(
      height: height,
      width: height * 1.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(left: 20),
                      child: Text("Recent news and \nupdates",
                          textAlign: TextAlign.left,
                          style: FontStyles.font24Semibold.copyWith(
                              color: AppColors.blackColor, fontSize: 32)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircularArrow(),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(widget.title! ?? "",
                                    style: FontStyles.font14Semibold
                                        .copyWith(color: AppColors.blueColor)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(widget.desc! ?? "",
                                    style: FontStyles.font14Semibold
                                        .copyWith(color: AppColors.blueColor)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    DateFormat('MM-dd-yyyy').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(widget.createdAt! ?? "") *
                                                1000)),
                                    // textAlign: TextAlign.start,
                                    style: FontStyles.font14Bold
                                        .copyWith(color: AppColors.blueColor)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  // const CTAButton(title: "Show all", radius: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

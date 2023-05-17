import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/core/provider.dart';
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

final landingScaffold = GlobalKey<ScaffoldState>();

class ShowNews extends ConsumerStatefulWidget {
  static const String routeName = "/news";

  const ShowNews({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowNewsState();
}

class _ShowNewsState extends ConsumerState<ShowNews> {
  // final _news = [
  //   News(
  //       title: "assa",
  //       description:
  //           "Relaxation on levy of additional fees in filling of e-forms AOC-4, AOC-4 Non-XBRL and MGT-7/MGT-7A for the financial year ended on 31.03.2021 under the Companies Act, 2013",
  //       createdAt: DateTime.now().millisecondsSinceEpoch),
  //   News(
  //       title: "asas",
  //       description:
  //           "Relaxation on levy of additional fees in filling of e-forms AOC-4, AOC-4 Non-XBRL and MGT-7/MGT-7A for the financial year ended on 31.03.2021 under the Companies Act, 2013",
  //       createdAt: DateTime.now().millisecondsSinceEpoch),
  //   News(
  //       title: "assa",
  //       description:
  //           "Relaxation on levy of additional fees in filling of e-forms AOC-4, AOC-4 Non-XBRL and MGT-7/MGT-7A for the financial year ended on 31.03.2021 under the Companies Act, 2013",
  //       createdAt: DateTime.now().millisecondsSinceEpoch),
  // ];

  final _StatssData = [
    Stats(title: "1500", description: "Orders"),
    Stats(title: "86%", description: "Successful Orders"),
    Stats(title: "15", description: "Lorem Ipsum"),
    Stats(title: "567", description: "Users"),
  ];

  final _frequentlyUsedServicesList = [
    "Business",
    "Taxation",
    "GST",
    "Other Business",
    "Lorem Ipsum",
    "Lorem Ipsum",
    "Lorem Ipsum",
    "Lorem Ipsum",
  ];

  late bool isAuthenticated;

  late final LandingPageViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ref.read(LandingPageViewModel.provider);
    _viewModel.fetchServices();
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
                  Services(height: 0, category: _viewModel.getCategories),
                  _frequentlyUsedServices(300, mobile: true),
                  _newsAndUpdates(800),
                  Center(child: _Statss(300, mobile: true)),
                  Visibility(
                    visible: _viewModel.getReviews.isNotEmpty,
                    child: CustomerReviewSlides(
                        customerReviews: _viewModel.getReviews,
                        height: MediaQuery.of(context).size.width,
                        mobile: true),
                  ),
                  const ContactUs(height: 250, mobile: true),
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
                  _newsAndUpdates(800),
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

  Widget _frequentlyUsedServices(double height, {bool mobile = false}) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Container(
            height: height * 0.75,
            color: AppColors.blueColor,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: height * 3,
              child: Column(
                mainAxisAlignment:
                    mobile ? MainAxisAlignment.start : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(visible: mobile, child: const SizedBox(height: 8)),
                  Padding(
                    padding: mobile == true
                        ? const EdgeInsets.all(0)
                        : const EdgeInsets.all(8.0).copyWith(
                            bottom: MediaQuery.of(context).size.height * 0.04),
                    child: Text("Frequently used services",
                        style: FontStyles.font24Semibold
                            .copyWith(color: AppColors.yellowColor)),
                  ),
                  Visibility(visible: mobile, child: const SizedBox(height: 8)),
                  Wrap(
                    spacing: mobile ? 20 : 8,
                    alignment: WrapAlignment.start,
                    runSpacing: mobile ? 14 : 8,
                    children:
                        // _viewModel.getService.asMap().entries.map((entry) {
                        _viewModel.getService.take(8).map((service) {
                      // int index = entry.key;
                      // model.Service service = entry.value;

                      return FrequentServiceContainer(
                        serviceName: service.title,
                        width: height * 3,
                        mobile: mobile,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _Statss(double height, {bool mobile = false}) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: mobile ? 8 : 0),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: _viewModel.getStats
              .map((e) => StatsContainer(
                  stat: e,
                  width: mobile ? height * 3 : height * 4,
                  b: _viewModel.getStats.indexOf(e) % 2 == 0))
              .toList(),
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
                  ..._viewModel.getNews.map((e) => NewsTile(news: e)).toList(),
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

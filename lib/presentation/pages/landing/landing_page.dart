import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/data/models/customer_review.dart';
import 'package:admin/data/models/general_stat.dart';
import 'package:admin/data/models/news.dart';
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
import 'package:admin/data/models/models.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_builder/responsive_builder.dart';

final landingScaffold = GlobalKey<ScaffoldState>();

class LandingPage extends ConsumerStatefulWidget {
  static const String routeName = "/landing";

  const LandingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  final _customerReviewData = [
    CustomerReview(
      title:
          "Relaxation on levy of additional fees in filling of e-forms AOC-4, AOC-4 Non-XBRL and MGT-7/MGT-7A for the financial year.",
      review:
          "Relaxation on levy of additional fees in filling of e-forms AOC-4, AOC-4 Non-XBRL and MGT-7/MGT-7A for the financial year. Relaxation on levy of additional fees in filling of e-forms AOC-4, AOC-4 Non-XBRL and MGT-7/MGT-7A for the financial year.",
      name: "Abhinav Kushwaha",
      designation: "CEO, QUBEx",
      customerProfilePic: "https://randomuser.me/api/portraits/men/51.jpg",
    ),
    CustomerReview(
      title:
          "Relaxation on levy of additional fees in filling of e-forms AOC-4, AOC-4 Non-XBRL and MGT-7/MGT-7A for the financial year.",
      review:
          "Relaxation on levy of additional fees in filling of e-forms AOC-4, AOC-4 Non-XBRL and MGT-7/MGT-7A for the financial year. Relaxation on levy of additional fees in filling of e-forms AOC-4, AOC-4 Non-XBRL and MGT-7/MGT-7A for the financial year.",
      name: "Abhinav Kushwaha",
      designation: "CEO, QUBEx",
      customerProfilePic: "https://randomuser.me/api/portraits/men/51.jpg",
    ),
    CustomerReview(
      title:
          "Relaxation on levy of additional fees in filling of e-forms AOC-4, AOC-4 Non-XBRL and MGT-7/MGT-7A for the financial year.",
      review:
          "Relaxation on levy of additional fees in filling of e-forms AOC-4, AOC-4 Non-XBRL and MGT-7/MGT-7A for the financial year. Relaxation on levy of additional fees in filling of e-forms AOC-4, AOC-4 Non-XBRL and MGT-7/MGT-7A for the financial year.",
      name: "Abhinav Kushwaha",
      designation: "CEO, QUBEx",
      customerProfilePic: "https://randomuser.me/api/portraits/men/51.jpg",
    ),
  ];

  final _news = [
    News(
        headline:
            "Relaxation on levy of additional fees in filling of e-forms AOC-4, AOC-4 Non-XBRL and MGT-7/MGT-7A for the financial year ended on 31.03.2021 under the Companies Act, 2013",
        createdAt: DateTime.now().millisecondsSinceEpoch),
    News(
        headline:
            "Relaxation on levy of additional fees in filling of e-forms AOC-4, AOC-4 Non-XBRL and MGT-7/MGT-7A for the financial year ended on 31.03.2021 under the Companies Act, 2013",
        createdAt: DateTime.now().millisecondsSinceEpoch),
    News(
        headline:
            "Relaxation on levy of additional fees in filling of e-forms AOC-4, AOC-4 Non-XBRL and MGT-7/MGT-7A for the financial year ended on 31.03.2021 under the Companies Act, 2013",
        createdAt: DateTime.now().millisecondsSinceEpoch),
  ];

  final _generalStatsData = [
    GeneralStat(value: "1500", title: "Orders"),
    GeneralStat(value: "86%", title: "Successful Orders"),
    GeneralStat(value: "15", title: "Lorem Ipsum"),
    GeneralStat(value: "567", title: "Users"),
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

  late bool isAuthenticated;

  late final LandingPageViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ref.read(LandingPageViewModel.provider);
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
                  // _newsAndUpdates(800),
                  Center(child: _generalStats(300, mobile: true)),
                  Visibility(
                    visible: _viewModel.getReviews.isNotEmpty,
                    child: CustomerReviewSlides(
                        customerReviews: _customerReviewData,
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
                  Services(height: 700, category: _viewModel.getCategories),
                  _frequentlyUsedServices(350),
                  // _newsAndUpdates(800),
                  Center(child: _generalStats(300)),
                  Visibility(
                    visible: _viewModel.getReviews.isNotEmpty,
                    child: CustomerReviewSlides(
                        customerReviews: _customerReviewData, height: 700),
                  ),
                  const ContactUs(height: 250),
                  ContactUsCard(contactDetails: _contactDetails, height: 200),
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
                mainAxisAlignment: mobile
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(visible: mobile, child: const SizedBox(height: 8)),
                  Text("Frequently used services",
                      style: FontStyles.font24Semibold
                          .copyWith(color: AppColors.yellowColor)),
                  Visibility(visible: mobile, child: const SizedBox(height: 8)),
                  Wrap(
                    spacing: mobile ? 20 : 8,
                    alignment: WrapAlignment.start,
                    runSpacing: mobile ? 14 : 8,
                    children: _frequentlyUsedServicesList
                        .map((e) => FrequentServiceContainer(
                            serviceName: e, width: height * 3, mobile: mobile))
                        .toList(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _generalStats(double height, {bool mobile = false}) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: mobile ? 8 : 0),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: _generalStatsData
              .map((e) => GeneralStatContainer(
                  stat: e,
                  width: mobile ? height * 3 : height * 4,
                  b: _generalStatsData.indexOf(e) % 2 == 0))
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Recent news and updates",
                    textAlign: TextAlign.left,
                    style: FontStyles.font24Semibold
                        .copyWith(color: AppColors.blackColor, fontSize: 32)),
                const SizedBox(height: 18),
                ..._news.map((e) => NewsTile(news: e)).toList(),
                const SizedBox(height: 18),
                const CTAButton(title: "Show all", radius: 100),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                const Spacer(),
                SizedBox(
                  height: height * 0.8,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: SvgPicture.asset(Assets.iconsVectoryellowSquare,
                            height: 100, width: 100),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SvgPicture.asset(Assets.iconsVectorblueSquare,
                            height: 50, width: 50),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Expanded(
                          child: Container(
                            height: height / 2,
                            width: height / 2,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/data/models/customer_review.dart';
import 'package:admin/data/models/general_stat.dart';
import 'package:admin/data/models/news.dart';
import 'package:admin/presentation/pages/widgets/banner.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:admin/presentation/pages/widgets/customer_review_slider.dart';
import 'package:admin/presentation/pages/widgets/footer.dart';
import 'package:admin/presentation/pages/widgets/frequent_service_container.dart';
import 'package:admin/presentation/pages/widgets/general_stat_container.dart';
import 'package:admin/presentation/pages/widgets/header.dart';
import 'package:admin/presentation/pages/widgets/news_tile.dart';
import 'package:admin/presentation/pages/widgets/service_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin/data/models/models.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_builder/responsive_builder.dart';

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

  final _bannerList = [
    BannerDetail(
        title: "Lorem Ipsum Lorem Ipsum Lorem Ipsum",
        description:
            "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum",
        imageUrl: Assets.personImage,
        btnText: "btnText"),
    BannerDetail(
        title: "1 Lorem Ipsum Lorem Ipsum Lorem Ipsum",
        description:
            "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum",
        imageUrl: Assets.personImage,
        btnText: "btnText"),
    BannerDetail(
        title: "2 Lorem Ipsum Lorem Ipsum Lorem Ipsum",
        description:
            "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum",
        imageUrl: Assets.personImage,
        btnText: "btnText"),
    BannerDetail(
        title: "3 Lorem Ipsum Lorem Ipsum Lorem Ipsum",
        description:
            "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum",
        imageUrl: Assets.personImage,
        btnText: "btnText"),
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

  final _category = [
    Category(
      id: "b",
      name: "Business",
      iconUrl: "",
      description:
          "I have used multiple offline & online CAs/ Lawyers. LegalRaasta clearly provided the best service and fast. Their team helped me protect my brand with trademark registration.",
      addedAt: DateTime.now().millisecondsSinceEpoch,
      addedBy: "",
    ),
    Category(
      id: "f",
      name: "finance",
      iconUrl: "",
      description:
          "I have used multiple offline & online CAs/ Lawyers. LegalRaasta clearly provided the best service and fast. Their team helped me protect my brand with trademark registration.",
      addedAt: DateTime.now().millisecondsSinceEpoch,
      addedBy: "",
    ),
    Category(
      id: "l",
      name: "legal",
      iconUrl: "",
      description:
          "I have used multiple offline & online CAs/ Lawyers. LegalRaasta clearly provided the best service and fast. Their team helped me protect my brand with trademark registration.",
      addedAt: DateTime.now().millisecondsSinceEpoch,
      addedBy: "",
    ),
    Category(
      id: "a",
      name: "Advertisment",
      iconUrl: "",
      description:
          "I have used multiple offline & online CAs/ Lawyers. LegalRaasta clearly provided the best service and fast. Their team helped me protect my brand with trademark registration.",
      addedAt: DateTime.now().millisecondsSinceEpoch,
      addedBy: "",
    ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: ScreenTypeLayout.builder(
        mobile: (context) => ListView(
          children: [
            const Header(mobile: true),
            BannerSlides(
              mobile: true,
              height: 250,
              bannerDetails: _bannerList,
            ),
            _services(700),
            _frequentlyUsedServices(350),
            // _newsAndUpdates(800),
            Center(child: _generalStats(300)),
            CustomerReviewSlides(
                customerReviews: _customerReviewData, height: 700),
            _contactUs(250),
            _contactUsCard(200),
            const Footer(),
          ],
        ),
        desktop: (context) => ListView(
          children: [
            const Header(mobile: false),
            BannerSlides(
              mobile: false,
              height: 700,
              bannerDetails: _bannerList,
            ),
            _services(700),
            _frequentlyUsedServices(350),
            // _newsAndUpdates(800),
            Center(child: _generalStats(300)),
            CustomerReviewSlides(
                customerReviews: _customerReviewData, height: 700),
            _contactUs(250),
            _contactUsCard(200),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _contactUsCard(double height) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height * 0.40,
              width: double.infinity,
              color: AppColors.blueColor,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _contactDetails
                  .map((contact) => ServiceContainer(
                      category: contact,
                      width: MediaQuery.of(context).size.width))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactUs(double height) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Contact us regarding any query",
                    style: FontStyles.font24Semibold
                        .copyWith(color: AppColors.blackColor)),
                const SizedBox(height: 4),
                Text(
                    "Relaxation on levy of additional fees in filling of e-forms AOC-4, AOC-4 Non-XBRL and MGT-7/MGT-7",
                    style: FontStyles.font12Regular
                        .copyWith(color: AppColors.blueColor)),
                const SizedBox(height: 12),
                CTAButton(title: "Contact Us", onTap: () {}, radius: 50),
              ],
            ),
          ),
          Positioned(
              bottom: 20,
              right: 20,
              child:
                  SvgPicture.asset(Assets.iconsVectorblueSquare, width: 120)),
          Positioned(
              top: 15,
              right: 80,
              child:
                  SvgPicture.asset(Assets.iconsVectoryellowSquare, width: 30)),
          Positioned(
              top: 30,
              child: SvgPicture.asset(Assets.ASSETS_ICONS_VECTOROVERLAYLEFT_SVG,
                  width: 110)),
        ],
      ),
    );
  }

  Widget _frequentlyUsedServices(double height) {
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Frequently used services",
                      style: FontStyles.font24Semibold
                          .copyWith(color: AppColors.yellowColor)),
                  Wrap(
                    spacing: 8,
                    alignment: WrapAlignment.start,
                    runSpacing: 8,
                    children: _frequentlyUsedServicesList
                        .map((e) => FrequentServiceContainer(
                            serviceName: e, width: height * 3))
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

  Widget _services(double height) {
    return  SizedBox(
      height: height,
      child: Stack(
        children: [
          SizedBox(
            height: height * 0.55,
            width: double.infinity,
            child: Image.asset(
              Assets.servicesBGDesign,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: height * 1.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Get the best services\nwe offer",
                          textAlign: TextAlign.left,
                          style: FontStyles.font24Semibold.copyWith(
                              color: AppColors.blackColor, fontSize: 32)),
                      const Spacer(),
                      Text(
                          "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem \nIpsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum",
                          textAlign: TextAlign.left,
                          style: FontStyles.font14Semibold
                              .copyWith(color: AppColors.blackLightColor)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _category
                        .map((category) => ServiceContainer(
                            category: category, width: height * 1.6))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _generalStats(double height) {
    return SizedBox(
      height: height,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.start,
        children: _generalStatsData
            .map((e) => GeneralStatContainer(
                stat: e,
                width: height * 4,
                b: _generalStatsData.indexOf(e) % 2 == 0))
            .toList(),
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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: _category
          //       .map((category) =>
          //           ServiceContainer(category: category, width: height * 1.6))
          //       .toList(),
          // ),
        ],
      ),
    );
  }
}

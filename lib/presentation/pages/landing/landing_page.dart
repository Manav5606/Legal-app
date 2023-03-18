import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/presentation/pages/widgets/banner.dart';
import 'package:admin/presentation/pages/widgets/footer.dart';
import 'package:admin/presentation/pages/widgets/header.dart';
import 'package:admin/presentation/pages/widgets/service_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin/data/models/models.dart';

class LandingPage extends ConsumerStatefulWidget {
  static const String routeName = "/landing";

  const LandingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
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
    "Lorem Ipsum"
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: ListView(
        children: [
          const Header(),
          BannerSlides(
            height: 700,
            bannerDetails: _bannerList,
          ),
          _services(700),
          _frequentlyUsedServices(400),
          Stack(
            children: [
              // TODO add contacts us
              const Footer(),
            ],
          ),
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
            height: height * 0.6,
            color: AppColors.blueColor,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: height * 1.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Frequently used services",
                      style: FontStyles.font24Semibold
                          .copyWith(color: AppColors.yellowColor)),
                  Wrap(
                    children:
                        _frequentlyUsedServicesList.map((e) => null).toList(),
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
    return SizedBox(
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
}

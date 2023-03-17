import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/presentation/pages/widgets/banner.dart';
import 'package:admin/presentation/pages/widgets/footer.dart';
import 'package:admin/presentation/pages/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin/data/models/models.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  Widget _services(double height) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          SizedBox(
            height: height * 0.55,
            child: SvgPicture.asset(Assets.servicesBGDesign),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Get the best services we offer",
                      textAlign: TextAlign.left,
                      style: FontStyles.font24Semibold
                          .copyWith(color: AppColors.blackColor)),
                  Text(
                      "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum",
                      textAlign: TextAlign.left,
                      style: FontStyles.font12Regular
                          .copyWith(color: AppColors.blackLightColor)),
                ],
              ),
              ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (_, __) => Container(
                  height: height * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(20)),
                ),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: 4,
              )
            ],
          ),
        ],
      ),
    );
  }
}

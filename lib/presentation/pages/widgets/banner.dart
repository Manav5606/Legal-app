import 'dart:math';
import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../category_client/category_client_page.dart';

class BannerSlides extends StatefulWidget {
  final bool mobile;
  final double height;
  final List<BannerDetail> bannerDetails;

  const BannerSlides(
      {super.key,
      required this.mobile,
      required this.bannerDetails,
      required this.height});

  @override
  State<BannerSlides> createState() => _BannerSlidesState();
}

class _BannerSlidesState extends State<BannerSlides> {
  int currentBannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: widget.bannerDetails.length,
            itemBuilder: (_, i, __) => SizedBox(
              height: widget.height,
              width: widget.height * 1.8,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    // TODO replace with CacheNetworkImage Later
                    child: Image.network(widget.bannerDetails[i].imageUrl,
                        height: widget.height * 0.85),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: widget.height * 0.6, left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.bannerDetails[i].title,
                            style: FontStyles.font48bold
                                .copyWith(fontSize: widget.mobile ? 14 : 48)),
                        const SizedBox(height: 4),
                        Text(widget.bannerDetails[i].description,
                            style: FontStyles.font14Semibold.copyWith(
                                color: AppColors.blackLightColor,
                                fontSize: widget.mobile ? 9 : 14)),
                        const SizedBox(height: 18),
                        CTAButton(
                            mobile: widget.mobile,
                            title: widget.bannerDetails[i].btnText,
                            onTap: () {
                              Routemaster.of(context).push(
                                  CategoryClientPage.routeName,
                                  queryParameters: {
                                    "categoryId":
                                        widget.bannerDetails[i].urlToLoad
                                  });
                            },
                            radius: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            options: CarouselOptions(
                enableInfiniteScroll: true,
                height: widget.height,
                viewportFraction: 1,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.easeInOut,
                onPageChanged: (index, _) =>
                    setState(() => currentBannerIndex = index)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.bannerDetails.map((e) {
                int index = widget.bannerDetails.indexOf(e);
                return Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.blueColor, width: 0.2),
                    color: currentBannerIndex == index
                        ? AppColors.blueColor
                        : AppColors.whiteColor,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/data/models/customer_review.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomerReviewSlides extends StatefulWidget {
  final double height;
  final List<CustomerReview> customerReviews;
  final bool mobile;

  const CustomerReviewSlides({
    super.key,
    required this.customerReviews,
    required this.height,
    this.mobile = false,
  });

  @override
  State<CustomerReviewSlides> createState() => _CustomerReviewSlidesState();
}

class _CustomerReviewSlidesState extends State<CustomerReviewSlides> {
  int currentReviewIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          Container(
            height: widget.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Assets.servicesBGDesign),
                    fit: BoxFit.cover)),
          ),
          Positioned(
              bottom: widget.mobile ? 4 : 20,
              left: widget.mobile ? 4 : 20,
              child: SvgPicture.asset(Assets.iconsVectoryellowSquare,
                  width: widget.mobile ? 40 : 80)),
          Positioned(
              top: widget.mobile ? 4 : 50,
              right: widget.mobile ? 8 : 80,
              child: SvgPicture.asset(Assets.iconsVectorblueSquare,
                  width: widget.mobile ? 20 : 40)),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: 25, horizontal: widget.mobile ? 25 : 0),
            child: Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: widget.customerReviews.length,
                  itemBuilder: (_, i, __) => Container(
                    width: widget.height,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: AppColors.blueColor,
                        borderRadius: BorderRadius.circular(25)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("What our customers has to say",
                            textAlign: TextAlign.center,
                            style: FontStyles.font48bold.copyWith(
                                color: AppColors.yellowColor,
                                fontSize: widget.mobile ? 16 : 34)),
                        Column(
                          children: [
                            Visibility(
                              visible: !widget.mobile,
                              child: Text(widget.customerReviews[i].title,
                                  textAlign: TextAlign.center,
                                  style: FontStyles.font12Regular.copyWith(
                                      color: AppColors.whiteColor,
                                      fontSize: 16)),
                            ),
                            Visibility(
                                visible: !widget.mobile,
                                child: const SizedBox(height: 4)),
                            CircleAvatar(
                                radius: widget.mobile ? 30 : 60,
                                backgroundImage: NetworkImage(widget
                                    .customerReviews[i].customerProfilePic)),
                            const SizedBox(height: 4),
                            Text(widget.customerReviews[i].review,
                                textAlign: TextAlign.center,
                                style: FontStyles.font12Regular.copyWith(
                                    color: AppColors.yellowColor,
                                    fontSize: widget.mobile ? 9 : 18)),
                            const SizedBox(height: 8),
                          ],
                        ),
                        Column(
                          children: [
                            Text(widget.customerReviews[i].name,
                                textAlign: TextAlign.center,
                                style: FontStyles.font14Bold.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: widget.mobile ? 12 : 20)),
                            const SizedBox(height: 2),
                            Text(widget.customerReviews[i].designation,
                                textAlign: TextAlign.center,
                                style: FontStyles.font14Bold.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: widget.mobile ? 12 : 20)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  options: CarouselOptions(
                      enableInfiniteScroll: true,
                      height: widget.height,
                      viewportFraction: 1,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 10),
                      autoPlayAnimationDuration: const Duration(seconds: 1),
                      autoPlayCurve: Curves.easeInOut,
                      onPageChanged: (index, _) =>
                          setState(() => currentReviewIndex = index)),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.customerReviews.map((e) {
                      int index = widget.customerReviews.indexOf(e);
                      return Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.blueColor, width: 0.2),
                          color: currentReviewIndex == index
                              ? AppColors.whiteColor
                              : Colors.white12,
                        ),
                      );
                    }).toList(),
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

import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactUs extends StatelessWidget {
  final double height;
  final bool mobile;
  const ContactUs({
    super.key,
    required this.height,
    this.mobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Positioned(
              bottom: 20,
              right: 20,
              child: SvgPicture.asset(Assets.iconsVectorblueSquare,
                  width: mobile ? 60 : 120)),
          Positioned(
              top: 15,
              right: 80,
              child:
                  SvgPicture.asset(Assets.iconsVectoryellowSquare, width: 30)),
          Positioned(
              top: 30,
              child: SvgPicture.asset(Assets.ASSETS_ICONS_VECTOROVERLAYLEFT_SVG,
                  width: 110)),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(mobile ? 12.0 : 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Contact us regarding any query",
                      style: FontStyles.font24Semibold.copyWith(
                          color: AppColors.blackColor,
                          fontSize: mobile ? 18 : null)),
                  const SizedBox(height: 4),
                  Text(
                      // "Relaxation on levy of additional fees in filling of e-forms AOC-4, AOC-4 Non-XBRL and MGT-7/MGT-7",
                      "Visit our office at SAI NAGAR COLONY,MANSOORABAD Hyderabad TG 500068 IN",
                      textAlign: TextAlign.center,
                      style: FontStyles.font12Regular.copyWith(
                          color: AppColors.blueColor,
                          fontSize: mobile ? 12 : null)),
                  const SizedBox(height: 12),
                  CTAButton(title: "Contact Us", onTap: () {}, radius: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

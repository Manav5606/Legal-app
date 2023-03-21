import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/data/models/general_stat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GeneralStatContainer extends StatelessWidget {
  final double width;
  final GeneralStat stat;
  final bool b;
  const GeneralStatContainer({
    super.key,
    required this.b,
    required this.stat,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width / 5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: b ? AppColors.yellowColor : AppColors.blueColor),
      child: Stack(
        children: [
          Positioned(
              top: 20,
              left: 0,
              child:
                  SvgPicture.asset(Assets.ASSETS_ICONS_VECTOROVERLAYLEFT_SVG)),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(stat.value,
                      style: FontStyles.font14Bold.copyWith(
                          color:
                              b ? AppColors.blueColor : AppColors.yellowColor,
                          fontSize: 24)),
                  Text(stat.title,
                      style: FontStyles.font12Medium.copyWith(
                          color:
                              b ? AppColors.blueColor : AppColors.yellowColor,
                          fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

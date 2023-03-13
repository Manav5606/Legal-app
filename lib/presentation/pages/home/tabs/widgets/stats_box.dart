import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:flutter/material.dart';

class StatsBox extends StatelessWidget {
  final Color darkColor;
  final Color lightColor;
  final Color regColor;
  final String title;
  final String value;
  final bool selected;

  const StatsBox({
    super.key,
    required this.darkColor,
    required this.lightColor,
    required this.regColor,
    required this.title,
    required this.value,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: regColor),
        color: selected ? lightColor : AppColors.whiteColor,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(title,
              style: FontStyles.font18Semibold.copyWith(color: darkColor)),
          Text(value,
              style: FontStyles.font18Semibold.copyWith(color: darkColor)),
        ],
      ),
    );
  }
}

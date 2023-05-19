import 'package:flutter/material.dart';

import '../../../core/constant/colors.dart';
import 'header.dart';

class CustomSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final bool mobile;
  CustomSliverPersistentHeaderDelegate({required this.mobile});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 100, // Adjust the height here as per your requirements
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
      ),
      child: Header(mobile: mobile),
    );
  }

  @override
  double get maxExtent => 100; // Adjust the maxExtent to match the height

  @override
  double get minExtent => 100; // Adjust the minExtent to match the height

  @override
  bool shouldRebuild(CustomSliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
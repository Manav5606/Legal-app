import 'package:admin/core/constant/colors.dart';
import 'package:flutter/material.dart';

class CircularArrow extends StatelessWidget {
  const CircularArrow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.blueColor,
      ),
      child: Icon(
        Icons.arrow_forward,
        color: AppColors.whiteColor,
        size: 14,
      ),
    );
  }
}

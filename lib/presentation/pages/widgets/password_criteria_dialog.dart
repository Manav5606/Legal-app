import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:flutter/material.dart';

class PasswordCriteriaDialog extends StatelessWidget {
  const PasswordCriteriaDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
          color: AppColors.yellowColor,
          borderRadius: BorderRadius.circular(12)),
      textStyle: FontStyles.font12Regular.copyWith(color: AppColors.whiteColor),
      message:
          "Should be of 8 digit\nFour alphabets are must\nFour numbers are must\nNo special characters allowed",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Icon(Icons.info, color: AppColors.yellowColor),
      ),
    );
  }
}

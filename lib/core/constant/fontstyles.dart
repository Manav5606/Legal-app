import 'package:admin/core/constant/colors.dart';
import 'package:flutter/material.dart';

abstract class FontStyles {
  static TextStyle get font12Regular => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.whiteColor,
      );
  static TextStyle get font12Medium => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.whiteColor,
      );
  static TextStyle get font18Semibold => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.blackColor,
      );
  static TextStyle get font10Light => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 10,
        fontWeight: FontWeight.w300,
        color: AppColors.blackColor,
      );
  static TextStyle get font20Semibold => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.yellowColor,
      );
  static TextStyle get font11Light => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: AppColors.blueColor,
      );
  static TextStyle get font14Semibold => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.blueColor,
      );
  static TextStyle get font24Semibold => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.blueColor,
      );
  static TextStyle get font10Medium => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.blueColor,
      );
  static TextStyle get font16Semibold => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.yellowColor,
      );
  static TextStyle get font9Regular => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 9,
        fontWeight: FontWeight.w300,
        color: AppColors.yellowColor,
      );
  static TextStyle get font9Medium => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 9,
        fontWeight: FontWeight.w500,
        color: AppColors.yellowColor,
      );
  static TextStyle get font9Light => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 9,
        fontWeight: FontWeight.w300,
        color: AppColors.blueColor,
      );
  static TextStyle get font11OpenSansLight => TextStyle(
        fontFamily: 'Open sans',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.blueColor,
      );
  static TextStyle get font14Bold => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.whiteColor,
      );
  static TextStyle get font8SemiBold => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 8,
        fontWeight: FontWeight.w600,
        color: AppColors.whiteColor,
      );

  static const kW500S10H9TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 9 / 10,
  );

  static const kW500S10H6TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 6 / 10,
  );

  static const kW500S12H10TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 10 / 12,
  );

  static const kW500S26H34TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 26,
    height: 34 / 26,
  );

  static const kW500S10H10TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 10 / 10,
  );

  static const kW500S10H12TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 10 / 12,
  );

  static const kW500S12H9TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 9 / 12,
  );
  static const kW500S12H7TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 7 / 12,
  );

  static const kW500S12H8TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 8 / 12,
  );

  static const kW600S12H13TextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    height: 13 / 12,
  );

  static const kW500S15H20TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 20 / 15,
  );

  static const kW500S15H11TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 11 / 15,
  );

  static const kW500S15H10TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 10 / 15,
  );

  static const kW500S16H10TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 10 / 16,
  );

  static const kW400S12H10TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 10 / 12,
  );

  static const kW400S12H13TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 13 / 12,
  );

  static const kW400S12H15TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 15 / 12,
  );

  static const kW400S12H9TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 9 / 12,
  );

  static const kW700S12H9TextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 9 / 12,
  );

  static const kW700S17H12TextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 17,
    height: 12 / 17,
  );

  static const kW700S17H20TextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 17,
    height: 20 / 17,
  );

  static const kW700S20H18TextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 18 / 20,
  );

  static const kW700S18H20TextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 20 / 18,
  );

  static const kW700S18H24TextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 24 / 18,
  );

  static const kW700S18H34TextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 34 / 18,
  );

  static const kW700S17H24TextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 17,
    height: 24 / 17,
  );

  static const kW700S14H12TextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 12 / 15,
  );

  static const kW700S15H12TextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 15,
    height: 12 / 15,
  );

  static const kW700S15H14TextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 15,
    height: 14 / 15,
  );

  static const kW700S15H15TextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 15,
    height: 15 / 15,
  );

  static const kW700S15H20TextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 15,
    height: 20 / 15,
  );

  static const kW400S10H15TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 10,
    height: 15 / 10,
  );

  static const kW400S10H12TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 10,
    height: 12 / 10,
  );

  static const kW400S10H14TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 10,
    height: 14 / 10,
  );

  static const kW400S10H24TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 10,
    height: 24 / 10,
  );

  static const kW500S10H7TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 7 / 10,
  );
  static const kW500S15H12TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 12 / 15,
  );
  static const kW500S15H14TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 14 / 15,
  );

  static const kW500S15H15TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 15 / 15,
  );

  static const kW400S15H14TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 15,
    height: 14 / 15,
  );

  static const kW400S15H12TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 15,
    height: 12 / 15,
  );

  static const kW400S15H15TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 15,
    height: 15 / 15,
  );

  static const kW400S15H26TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 15,
    height: 26 / 15,
  );

  static const kW500S16H11TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 11 / 16,
  );

  static const kW500S10H14TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 14 / 10,
  );

  static const kW500S10H15TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 15 / 10,
  );

  static const kW500S11H8TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 11,
    height: 8 / 11,
  );

  static const kW800S8H8TextStyle = TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 8,
    height: 8 / 8,
  );

  static const kW500S13H9TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13,
    height: 9 / 13,
  );

  static const kW500S13H10TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13,
    height: 10 / 13,
  );

  static const kW500S13H12TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13,
    height: 12 / 13,
  );

  static const kW500S13H14TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13,
    height: 14 / 13,
  );

  static const kW500S13H15TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13,
    height: 15 / 13,
  );

  static const kW500S13H18TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13,
    height: 18 / 13,
  );
  static const kW600S16H18TextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 18 / 16,
  );

  static const kW500S12H12TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 12 / 12,
  );
  static const kW500S12H16TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 16 / 12,
  );

  static const kW500S12H14TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 14 / 12,
  );

  static const kW600S12H14TextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    height: 14 / 12,
  );

  static const kW400S12H14TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 14 / 12,
  );

  static const kW400S12H20TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 20 / 12,
  );

  static const kW400S12H24TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 24 / 12,
  );

  static const kW400S13H20TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 20 / 13,
  );

  static const kW400S13H22TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 22 / 13,
  );

  static const kW400S13H24TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 24 / 13,
  );

  static const kW400S13H16TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 16 / 13,
  );
  static const kW400S13H18TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 18 / 13,
  );

  static const kW400S14H10TextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 10 / 14,
  );

  static const kW400S14H12TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 12 / 14,
  );

  static const kW400S14H18TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 18 / 14,
  );
  static const kW400S14H21TextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 21 / 14,
  );
}

import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/sizes.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String imageUrl;
  final String date;
  final bool isOpened;

  const NotificationTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.imageUrl,
    required this.date,
    this.isOpened = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: Sizes.s30.h, vertical: Sizes.s20.h),
      decoration: BoxDecoration(
        color: isOpened ? AppColors.whiteColor : AppColors.lightBlueColor,
        border: Border(
          top: BorderSide(color: AppColors.lighterBlueColor),
          bottom: BorderSide(color: AppColors.lighterBlueColor),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                _renderImage(imageUrl),
                SizedBox(width: Sizes.s10.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(title, FontWeight.w600),
                    _buildLabel(subTitle, FontWeight.w400),
                  ],
                ),
              ],
            ),
            _buildLabel(date, FontWeight.w400),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, FontWeight fontWeight) {
    return AutoSizeText(
      text,
      minFontSize: Sizes.s10.sp,
      style: TextStyle(
        color: AppColors.darkBlueColor,
        fontWeight: fontWeight,
      ),
    );
  }

  Widget _renderImage(String url) {
    return Container(
      height: Sizes.s60.h,
      width: Sizes.s60.h,
      padding: EdgeInsets.all(Sizes.s6.sp),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Sizes.s200.h),
        border: Border.all(color: AppColors.darkBlueColor),
      ),
      child: ClipRRect( 
        borderRadius: BorderRadius.circular(Sizes.s200.sp),
        child: Image.network(
          url,
        ),
      ),
    );
  }
}

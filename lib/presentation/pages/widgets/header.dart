import 'dart:developer';

import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// TODO make all displayed text dynamic
class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        topBar(),
        bottomBar(),
      ],
    );
  }

  Widget bottomBar() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 30,
          ),
          SvgPicture.asset(
            Assets.iconsTitleBarlogo,
            width: 255,
            height: 51,
          ),
          const Spacer(),
          Container(
              width: 180,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: AppColors.yellowColor,
                  borderRadius: BorderRadius.circular(50)),
              child: TextFormField(
                  decoration: const InputDecoration(
                      isDense: true,
                      hintText: "Search...",
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search)))),
          const SizedBox(
            width: 30,
          ),
        ],
      ),
    );
  }

  Widget topBar() {
    return Container(
      height: 26,
      color: AppColors.blueColor,
      child: Row(
        children: [
          const SizedBox(
            width: 30,
          ),
          SvgPicture.asset(Assets.ASSETS_ICONS_VECTORPHONE_SVG),
          const SizedBox(
            width: 9.68,
          ),
          Text(
            "+91-11153-42382",
            style: FontStyles.font12Regular,
          ),
          const SizedBox(
            width: 11.22,
          ),
          SvgPicture.asset(Assets.ASSETS_ICONS_VECTORMAIL_SVG),
          const SizedBox(
            width: 9.68,
          ),
          Text(
            "contact@247legal.in",
            style: FontStyles.font12Regular,
          ),
          const Spacer(),
          Text(
            "Role ⬇️",
            style:
                FontStyles.font12Regular.copyWith(color: AppColors.yellowColor),
          ),
          const SizedBox(
            width: 11.22,
          ),
          Text(
            "Admin Name",
            style: FontStyles.font12Regular,
          ),
          const SizedBox(
            width: 11.22,
          ),
          Divider(color: AppColors.yellowColor, thickness: 3),
          const SizedBox(
            width: 9.68,
            child: CircleAvatar(),
          ),
          DropdownMenu(
              dropdownMenuEntries: ["Profile", "History", "Sign out"]
                  .map((e) => DropdownMenuEntry(value: e, label: e))
                  .toList(),
              onSelected: (value) {
                log(value.toString());
              }),
          const SizedBox(
            width: 11.22,
          ),
        ],
      ),
    );
  }
}

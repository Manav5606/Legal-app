import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/presentation/pages/home/tabs/widgets/stats_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardTab extends ConsumerStatefulWidget {
  const DashboardTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardTabState();
}

class _DashboardTabState extends ConsumerState<DashboardTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _heading(),
          _statsBoxes(),
        ],
      ),
    );
  }

  Widget _heading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Order", style: FontStyles.font24Semibold),
        Text("Your list of order is here", style: FontStyles.font14Semibold),
      ],
    );
  }

  Widget _statsBoxes() {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StatsBox(
            darkColor: AppColors.darkBlueColor,
            lightColor: AppColors.lightBlueColor,
            regColor: AppColors.blueColor,
            title: "Total Orders",
            value: "200",
            selected: true,
          ),
          StatsBox(
            darkColor: AppColors.darkRedColor,
            lightColor: AppColors.lightRedColor,
            regColor: AppColors.redColor,
            title: "New Orders",
            value: "50",
            selected: false,
          ),
          StatsBox(
            darkColor: AppColors.darkOrangeColor,
            lightColor: AppColors.lightOrangeColor,
            regColor: AppColors.orangeColor,
            title: "Ongoing",
            value: "80",
            selected: false,
          ),
          StatsBox(
            darkColor: AppColors.darkGreenColor,
            lightColor: AppColors.lightGreenColor,
            regColor: AppColors.greenColor,
            title: "Completed",
            value: "70",
            selected: false,
          ),
        ],
      ),
    );
  }
}

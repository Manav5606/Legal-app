import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/presentation/pages/widgets/circular_arrow.dart';
import 'package:flutter/material.dart';

class FrequentServiceContainer extends StatelessWidget {
  final String serviceName;
  final double width;
  const FrequentServiceContainer({
    super.key,
    required this.serviceName,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO
      },
      child: Container(
        width: width / 5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.whiteColor,
            boxShadow: const [
              BoxShadow(
                  offset: Offset(4, 4), blurRadius: 8, color: Colors.black12)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(serviceName,
                  style: FontStyles.font12Medium
                      .copyWith(color: AppColors.blueColor, fontSize: 18)),
              const CircularArrow(),
            ],
          ),
        ),
      ),
    );
  }
}

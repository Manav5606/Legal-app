import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blueColor,
      height: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Are you client wanting to \nconnect with us?",
                    textAlign: TextAlign.center,
                    style: FontStyles.font18Semibold
                        .copyWith(color: AppColors.yellowColor, fontSize: 36),
                  ),
                  const SizedBox(height: 20),
                  Text(
                      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Assumenda placeat similique dolore aperiam ad a sunt molestiae debitis molestias. At id consequatur laudantium dolore quo asperiores earum cupiditate, maxime aperiam?",
                      textAlign: TextAlign.center,
                      style: FontStyles.font12Regular.copyWith(
                          color: AppColors.whiteColor,
                          letterSpacing: 0.05,
                          fontSize: 16)),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
                child: CTAButton(title: "Log In / SignUp", onTap: () {})),
          )
        ],
      ),
    );
  }
}

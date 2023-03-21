import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Footer extends ConsumerStatefulWidget {
  const Footer({super.key});

  @override
  ConsumerState<Footer> createState() => _FooterState();
}

class _FooterState extends ConsumerState<Footer> {
  late bool isAuthenticated;
  @override
  void initState() {
    super.initState();
    isAuthenticated = ref.read(AppState.auth).isAuthenticated;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(AppState.auth).isAuthenticated;
    return Visibility(
      visible: !isAuthenticated,
      child: Container(
        color: AppColors.blueColor,
        height: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
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
              child: Center(
                  child: CTAButton(title: "Log In / SignUp", onTap: () {})),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/presentation/pages/authentication/index.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:routemaster/routemaster.dart';

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
    return Container(
      color: AppColors.blueColor,
      height: isAuthenticated ? 50 : 300,
      child: Visibility(
        visible: !isAuthenticated,
        child: ScreenTypeLayout.builder(
          desktop: (context) => Row(
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
                        style: FontStyles.font18Semibold.copyWith(
                            color: AppColors.yellowColor, fontSize: 36),
                      ),
                      const SizedBox(height: 20),
                      Text(
                          "Lorem  elit. debitisiores earum cupiditate, maxime aperiam?",
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
          mobile: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Text(
                  "Are you client wanting to connect with us?",
                  textAlign: TextAlign.center,
                  style: FontStyles.font18Semibold
                      .copyWith(color: AppColors.yellowColor, fontSize: 28),
                ),
              ),
              CTAButton(
                  title: "Log In / SignUp",
                  onTap: () {
                    Routemaster.of(context).push(RegisterPage.routeName);
                  })
            ],
          ),
        ),
      ),
    );
  }
}

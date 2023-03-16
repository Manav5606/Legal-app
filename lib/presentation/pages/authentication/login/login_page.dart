import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/core/constant/sizes.dart';
import 'package:admin/presentation/pages/home/home_page.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:admin/presentation/pages/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routemaster/routemaster.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const String routeName = "/login";
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(flex: 1, child: imageView()),
          Expanded(
            flex: 1,
            child: loginAuth(),
          ),
        ],
      ),
    );
  }

  Widget imageView() {
    return Stack(
      children: [
        Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(Assets.personImage, scale: 1)),
      ],
    );
  }

  Container loginAuth() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBlueColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: Sizes.s100.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox.shrink(),
          Column(
            children: [
              SvgPicture.asset(Assets.iconsTwentyseven, height: 160),
              const SizedBox(height: 24),
              Text("Admin Login",
                  style: FontStyles.font20Semibold
                      .copyWith(color: AppColors.whiteColor)),
            ],
          ),
          Column(
            children: [
              CustomTextField(
                label: "LOGIN",
                hintText: "Username/ Email address/ Phone Number",
                controller: nameController,
              ),
              const SizedBox(height: 18),
              CustomTextField(
                label: "PASSWORD",
                hintText: "Password",
                controller: passwordController,
                obscureText: true,
                suffixIcon: IconButton(
                    onPressed: () {
                      // Toogle password visibility
                    },
                    icon: const Icon(Icons.visibility_off)),
              ),
              const SizedBox(height: 24),
              CTAButton(
                  title: "Log In",
                  onTap: () {
                    Routemaster.of(context).replace(HomePage.routeName);
                  }),
            ],
          ),
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}

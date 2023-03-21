// ignore_for_file: use_build_context_synchronously

import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/core/constant/sizes.dart';
import 'package:admin/core/enum/role.dart';
import 'package:admin/presentation/pages/authentication/index.dart';
import 'package:admin/presentation/pages/authentication/login/login_view_model.dart';
import 'package:admin/presentation/pages/home/home_page.dart';
import 'package:admin/presentation/pages/landing/landing_page.dart';
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
  late final LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(LoginViewModel.provider);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(LoginViewModel.provider);

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
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkBlueColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
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
                    Text("Login",
                        style: FontStyles.font20Semibold
                            .copyWith(color: AppColors.whiteColor)),
                  ],
                ),
                Column(
                  children: [
                    CustomTextField(
                      label: "LOGIN",
                      hintText: "Username/ Email address/ Phone Number",
                      controller: _viewModel.nameController,
                      readOnly: _viewModel.isLoading,
                      errorText: _viewModel.nameError,
                    ),
                    const SizedBox(height: 18),
                    CustomTextField(
                      label: "PASSWORD",
                      hintText: "Password",
                      controller: _viewModel.passwordController,
                      readOnly: _viewModel.isLoading,
                      obscureText: _viewModel.showPassword,
                      errorText: _viewModel.passwordError,
                      suffixIcon: IconButton(
                          onPressed: _viewModel.togglePasswordVisibility,
                          icon: Icon(_viewModel.showPassword
                              ? Icons.visibility_off
                              : Icons.visibility)),
                    ),
                    const SizedBox(height: 24),
                    CTAButton(
                        title: "Log In",
                        loading: _viewModel.isLoading,
                        onTap: _viewModel.isLoading
                            ? null
                            : () async {
                                final user = await _viewModel.login();
                                if (user != null) {
                                  switch (user.userType) {
                                    case UserType.user:
                                      Routemaster.of(context)
                                          .replace(LandingPage.routeName);
                                      break;
                                    case UserType.admin:
                                      Routemaster.of(context)
                                          .replace(HomePage.routeName);
                                      break;
                                    case UserType.client:
                                      Routemaster.of(context)
                                          .replace(LandingPage.routeName);
                                      break;
                                    default:
                                      Routemaster.of(context)
                                          .replace(LandingPage.routeName);
                                  }
                                }
                              }),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?",
                            style: FontStyles.font12Regular
                                .copyWith(color: AppColors.whiteColor)),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () => Routemaster.of(context)
                              .push(RegisterPage.routeName),
                          child: Text("Register",
                              style: FontStyles.font14Bold
                                  .copyWith(color: AppColors.yellowColor)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

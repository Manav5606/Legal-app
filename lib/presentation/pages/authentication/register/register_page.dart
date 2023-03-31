// ignore_for_file: use_build_context_synchronously

import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/core/constant/sizes.dart';
import 'package:admin/core/enum/role.dart';
import 'package:admin/presentation/pages/authentication/index.dart';
import 'package:admin/presentation/pages/authentication/register/register_view_model.dart';
import 'package:admin/presentation/pages/home/home_page.dart';
import 'package:admin/presentation/pages/landing/landing_page.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:admin/presentation/pages/widgets/custom_textfield.dart';
import 'package:admin/presentation/pages/widgets/password_criteria_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:routemaster/routemaster.dart';

class RegisterPage extends ConsumerStatefulWidget {
  static const String routeName = "/register";
  const RegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late final RegisterViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(RegisterViewModel.provider);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(RegisterViewModel.provider);

    return Scaffold(
      body: SafeArea(
        child: ScreenTypeLayout.builder(
          desktop: (context) {
            return Row(
              children: [
                Expanded(flex: 1, child: imageView()),
                Expanded(
                  flex: 1,
                  child: registerAuth(false),
                ),
              ],
            );
          },
          mobile: (context) => registerAuth(true),
        ),
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

  Widget registerAuth(bool mobile) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkBlueColor,
        borderRadius: mobile
            ? null
            : const BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mobile ? Sizes.s20.w : Sizes.s100.w),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 12),
                Column(
                  children: [
                    SvgPicture.asset(Assets.iconsTwentyseven, height: 160),
                    const SizedBox(height: 24),
                    Text("Sign Up",
                        style: FontStyles.font20Semibold
                            .copyWith(color: AppColors.whiteColor)),
                  ],
                ),
                Column(
                  children: [
                    CustomTextField(
                      label: "USERNAME",
                      hintText: "Enter Username",
                      controller: _viewModel.usernameController,
                      readOnly: _viewModel.isLoading,
                      errorText: _viewModel.usernameError,
                    ),
                    const SizedBox(height: 18),
                    CustomTextField(
                      label: "MOBILE NUMBER",
                      hintText: "Enter Mobile Number",
                      controller: _viewModel.numberController,
                      readOnly: _viewModel.isLoading,
                      errorText: _viewModel.numberError,
                    ),
                    const SizedBox(height: 18),
                    CustomTextField(
                      label: "EMAIL",
                      hintText: "Enter your Mail Address",
                      controller: _viewModel.emailController,
                      readOnly: _viewModel.isLoading,
                      errorText: _viewModel.emailError,
                    ),
                    const SizedBox(height: 18),
                    CustomTextField(
                      label: "SET NEW PASSWORD",
                      hintText: "Enter Password",
                      controller: _viewModel.passwordController,
                      readOnly: _viewModel.isLoading,
                      obscureText: !_viewModel.showPassword,
                      errorText: _viewModel.passwordError,
                      suffixIcon: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: _viewModel.togglePasswordVisibility,
                              icon: Icon(_viewModel.showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility)),
                          const PasswordCriteriaDialog(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    CustomTextField(
                      label: "RE-ENTER PASSWORD",
                      hintText: "Enter Confirm Password",
                      controller: _viewModel.password1Controller,
                      readOnly: _viewModel.isLoading,
                      obscureText: !_viewModel.showPassword1,
                      errorText: _viewModel.password1Error,
                      suffixIcon: IconButton(
                          onPressed: _viewModel.togglePassword1Visibility,
                          icon: Icon(_viewModel.showPassword1
                              ? Icons.visibility_off
                              : Icons.visibility)),
                    ),
                    const SizedBox(height: 24),
                    CTAButton(
                        title: "Sign Up",
                        loading: _viewModel.isLoading,
                        onTap: _viewModel.isLoading
                            ? null
                            : () async {
                                final user = await _viewModel.register();
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
                        Text("Already have an account?",
                            style: FontStyles.font12Regular
                                .copyWith(color: AppColors.whiteColor)),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () =>
                              Routemaster.of(context).push(LoginPage.routeName),
                          child: Text("Login",
                              style: FontStyles.font14Bold
                                  .copyWith(color: AppColors.yellowColor)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

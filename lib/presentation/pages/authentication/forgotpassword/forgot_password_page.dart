// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/core/constant/sizes.dart';
import 'package:admin/core/enum/role.dart';
import 'package:admin/presentation/pages/authentication/forgotpassword/forgot_password_view_model.dart';
import 'package:admin/presentation/pages/authentication/index.dart';
import 'package:admin/presentation/pages/authentication/register/register_view_model.dart';
import 'package:admin/presentation/pages/authentication/vendor_register.dart/vendor_personal_details.dart';
import 'package:admin/presentation/pages/authentication/vendor_register.dart/vendor_register_view_model.dart';
import 'package:admin/presentation/pages/home/home_page.dart';
import 'package:admin/presentation/pages/landing/landing_page.dart';
import 'package:admin/presentation/pages/vendor_admin/vendor_view_model.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:admin/presentation/pages/widgets/custom_textfield.dart';
import 'package:admin/presentation/pages/widgets/password_criteria_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/enum/qualification.dart';
import '../../../../data/repositories/auth_repositories_impl.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  static const String routeName = "/forgot_password";
  final bool navigateBack;
  const ForgotPasswordPage({super.key, this.navigateBack = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();
  late final ForgotPasswordViewModel _viewModel;
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(ForgotPasswordViewModel.provider);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(ForgotPasswordViewModel.provider);
    return Scaffold(
      body: SafeArea(
        child: ScreenTypeLayout.builder(
          desktop: (context) {
            return Row(
              children: [
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

  Widget registerAuth(bool mobile) {
    return Container(
      height: double.infinity,
      color: AppColors.darkBlueColor,
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
                    Text("Forgot Password",
                        style: FontStyles.font20Semibold
                            .copyWith(color: AppColors.whiteColor)),
                  ],
                ),
                Column(
                  children: [
                    CustomTextField(
                      label: "Email",
                      hintText: "Enter Email",
                      controller: _viewModel.emailController,
                      // readOnly: _viewModel.isLoading,
                      // errorText: _viewModel.usernameError,
                    ),
                    const SizedBox(height: 18),
                    CTAButton(
                        title: "Send",
                        // loading: _viewModel.isLoading,

                        onTap: () {
                          _viewModel.forgotPassword();
                        }),
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

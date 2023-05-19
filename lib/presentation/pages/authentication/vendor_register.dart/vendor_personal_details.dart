// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/core/constant/sizes.dart';
import 'package:admin/core/enum/role.dart';
import 'package:admin/presentation/pages/authentication/index.dart';
import 'package:admin/presentation/pages/authentication/register/register_view_model.dart';
import 'package:admin/presentation/pages/authentication/vendor_register.dart/vendor_qualifications.dart';
import 'package:admin/presentation/pages/authentication/vendor_register.dart/vendor_register_view_model.dart';
import 'package:admin/presentation/pages/home/home_page.dart';
import 'package:admin/presentation/pages/landing/landing_page.dart';
import 'package:admin/presentation/pages/vendor_admin/vendor_view_model.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:admin/presentation/pages/widgets/custom_textfield.dart';
import 'package:admin/presentation/pages/widgets/password_criteria_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/enum/qualification.dart';

class VendorPersonalDetails extends ConsumerStatefulWidget {
  static const String routeName = "/personal_details";
  final bool navigateBack;
  const VendorPersonalDetails({super.key, this.navigateBack = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VendorPersonalDetailsState();
}

class _VendorPersonalDetailsState extends ConsumerState<VendorPersonalDetails> {
  late final VendorRegisterViewModel _viewModel;
  int _widgetIndex = 0;
  int _widgetDetialIndex = 0;
  QualificationUniversity university =
      QualificationUniversity.barCounsilOfIndia;
  QualificationDegree degree = QualificationDegree.ca;
  YearsQualification years = YearsQualification.year2001;
  bool _showNewWidget = false;

  final text = [
    "Pan Card"
        "Aadhar Card"
        "Practicing Certificate"
        "Validtiy date of Practicing certificate"
        "Passport "
        "Power Bill"
        "google Map"
        "Agreement between 24hrs & partner"
  ];

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(VendorRegisterViewModel.provider);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(VendorRegisterViewModel.provider);
    Widget widgetToShow;
    // switch (_widgetIndex) {
    //   case 1:
    //     widgetToShow = registerAuth(false);
    //     break;
    //   case 2:
    //     widgetToShow = registerAuth1(false);
    //     widgetToShow = detailView1();
    //     break;
    //   case 3:
    //     widgetToShow = registerAuth2(false);
    //     widgetToShow = detailView2();
    //     break;
    //   default:
    //     widgetToShow = registerAuth(false);
    // }
    // Widget widgetToShowdetails;
    // switch (_widgetDetialIndex) {
    //   case 1:
    //     widgetToShowdetails = detailView1();
    //     break;
    //   case 2:
    //     widgetToShowdetails = detailView2();
    //     break;
    //   default:
    //     widgetToShowdetails = detailBlurView();
    // }

    return Scaffold(
      body: SafeArea(
        child: ScreenTypeLayout.builder(
          desktop: (context) {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: detailView1(false),
                ),
                // Visibility(
                //   visible: _widgetIndex == 2,
                //   child: Expanded(
                //     flex: 1,
                //     child: registerAuth2(false),
                //   ),
                // ),
                // // Expanded(flex: 1, child: uploadDocuments()),
                // Visibility(
                //     visible: _widgetIndex == 0,
                //     child: Expanded(flex: 1, child: detailView1())),
                // Visibility(
                //     visible: _widgetIndex == 1,
                //     child: Expanded(flex: 1, child: detailView2())),
              ],
            );
          },
          mobile: (context) => detailView1(true),
        ),
      ),
    );
  }

  Widget detailBlurView() {
    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Personal Details",
                        style: FontStyles.font18Semibold,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // const SizedBox(height: 18),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.20,
                        child: CustomTextField(
                          label: "Name",
                          hintText: "Enter First Name",
                          controller: _viewModel.companyNameController,
                          readOnly: _viewModel.isLoading,
                          errorText: _viewModel.numberError,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Associate Details",
                          style: FontStyles.font18Semibold,
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 18),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: CustomTextField(
                              label: "Name",
                              hintText: "Name Of Associate",
                              controller: _viewModel.associateAddressController,
                              readOnly: _viewModel.isLoading,
                              errorText: _viewModel.numberError,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // const SizedBox(height: 18),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: CustomTextField(
                          label: "Address",
                          hintText: "Address Of Associate as per power bill",
                          controller: _viewModel.associateAddressController,
                          readOnly: _viewModel.isLoading,
                          errorText: _viewModel.numberError,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // const SizedBox(height: 18),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: CustomTextField(
                          label: "Permanent Address",
                          hintText:
                              "Permanent Address Of Associate as per power bill",
                          controller:
                              _viewModel.associatePermanentAddressController,
                          readOnly: _viewModel.isLoading,
                          errorText: _viewModel.numberError,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                CTAButton(
                  title: "Next",
                  onTap: () {
                    _widgetDetialIndex = (_widgetDetialIndex + 1) % 3;
                  },
                ),
              ],
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Color.fromARGB(255, 201, 205, 201).withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget detailView1(bool mobile) {
    return SizedBox(
      height: double.infinity,
      // width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Personal Details",
                    style: FontStyles.font18Semibold,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // const SizedBox(height: 18),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: CustomTextField(
                      label: "Name",
                      hintText: "Enter First Name",
                      controller: _viewModel.usernameController,
                      readOnly: _viewModel.isLoading,
                      errorText: _viewModel.numberError,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Associate Details",
                      style: FontStyles.font18Semibold,
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // const SizedBox(height: 18),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: CustomTextField(
                          label: "Name",
                          hintText: "Name Of Associate",
                          controller: _viewModel.associateNameController,
                          readOnly: _viewModel.isLoading,
                          errorText: _viewModel.numberError,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // const SizedBox(height: 18),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: CustomTextField(
                      label: "Address",
                      hintText: "Address Of Associate as per power bill",
                      controller: _viewModel.associateAddressController,
                      readOnly: _viewModel.isLoading,
                      errorText: _viewModel.numberError,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // const SizedBox(height: 18),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: CustomTextField(
                      label: "Permanent Address",
                      hintText:
                          "Permanent Address Of Associate as per power bill",
                      controller:
                          _viewModel.associatePermanentAddressController,
                      readOnly: _viewModel.isLoading,
                      errorText: _viewModel.numberError,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            CTAButton(
              title: "Next",
              onTap: () {
                print(_viewModel.usernameController.text);
                          print(_viewModel.accountNumberController.text);
                          print(_viewModel.ifscController.text);
                          print(_viewModel.mobileController.text);
                          print(_viewModel.landlineController.text);
                          print(_viewModel.endWorkingHours);
                          print(_viewModel.startWorkingHours);
                          print(_viewModel.qualifiedYearController.text);
                          print(_viewModel.practicingExperienceController.text);
                          print(_viewModel.expertServicesController.text);
                Routemaster.of(context).push(
                  VendorQualificationsDetails.routeName,
                  queryParameters: {"navigateBack": "true"},
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget detailView2() {
    return SizedBox(
      height: double.infinity,
      // width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Eductaional Qualification",
                    style: FontStyles.font18Semibold,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 18),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Qualified"),
                      DropdownMenu(
                        initialSelection: university.name,
                        dropdownMenuEntries: QualificationUniversity.values
                            .map((e) => DropdownMenuEntry(
                                value: e.name, label: e.title))
                            .toList(),
                        onSelected: (v) {
                          if (v != null) {
                            setState(() {
                              university = QualificationUniversity.values
                                  .firstWhere((element) => element.name == v);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Qualification University"),
                        DropdownMenu(
                          initialSelection: degree.name,
                          dropdownMenuEntries: QualificationDegree.values
                              .map((e) => DropdownMenuEntry(
                                  value: e.name, label: e.title))
                              .toList(),
                          onSelected: (v) {
                            if (v != null) {
                              setState(() {
                                degree = QualificationDegree.values
                                    .firstWhere((element) => element.name == v);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Years of Qualification"),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  DropdownMenu(
                    initialSelection: years.name,
                    dropdownMenuEntries: YearsQualification.values
                        .map((e) =>
                            DropdownMenuEntry(value: e.name, label: e.title))
                        .toList(),
                    onSelected: (v) {
                      if (v != null) {
                        setState(() {
                          years = YearsQualification.values
                              .firstWhere((element) => element.name == v);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("Practice Experience"),
                  CustomTextField(
                    label: "Practice Experience",
                    hintText: "Pease enter practice experience details",
                    controller: _viewModel.numberController,
                    readOnly: _viewModel.isLoading,
                    errorText: _viewModel.numberError,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  CustomTextField(
                    label: "Expert Services",
                    hintText: "Pease enter expert service details",
                    controller: _viewModel.numberController,
                    readOnly: _viewModel.isLoading,
                    errorText: _viewModel.numberError,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  CustomTextField(
                    label: "Working Hours",
                    hintText: "Pease enter working hours",
                    controller: _viewModel.numberController,
                    readOnly: _viewModel.isLoading,
                    errorText: _viewModel.numberError,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Account Number"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        CustomTextField(
                          // label: "",
                          hintText: "Please enter bank account number",
                          controller: _viewModel.numberController,
                          readOnly: _viewModel.isLoading,
                          errorText: _viewModel.numberError,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("IFSC Number"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        CustomTextField(
                          // label: "",
                          hintText: "Please enter ifsc number",
                          controller: _viewModel.numberController,
                          readOnly: _viewModel.isLoading,
                          errorText: _viewModel.numberError,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Landline Number"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        CustomTextField(
                          // label: "",
                          hintText: "Please enter landline number",
                          controller: _viewModel.numberController,
                          readOnly: _viewModel.isLoading,
                          errorText: _viewModel.numberError,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Mobile Number"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        CustomTextField(
                          // label: "",
                          hintText: "Please enter mobile number",
                          controller: _viewModel.numberController,
                          readOnly: _viewModel.isLoading,
                          errorText: _viewModel.numberError,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CTAButton(
              title: "Next",
              onTap: () {
                _showNewWidget = !_showNewWidget;
              },
            ),
          ],
        ),
      ),
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
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
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
                    Text("Login/Sign Up",
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
                        title: "Register",
                        loading: _viewModel.isLoading,
                        onTap: () {
                          setState(() {
                            _widgetIndex = 1;
                          });
                        }),
                    // const SizedBox(height: 24),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text("Already have an account?",
                    //         style: FontStyles.font12Regular
                    //             .copyWith(color: AppColors.whiteColor)),
                    //     const SizedBox(width: 4),
                    //     InkWell(
                    //       onTap: () => Routemaster.of(context).replace(
                    //         LoginPage.routeName,
                    //         queryParameters: {
                    //           "navigateBack": widget.navigateBack.toString()
                    //         },
                    //       ),
                    //       child: Text("Login",
                    //           style: FontStyles.font14Bold
                    //               .copyWith(color: AppColors.yellowColor)),
                    //     ),
                    //   ],
                    // ),
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

  Widget registerAuth1(bool mobile) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkBlueColor,
        borderRadius: mobile
            ? null
            : const BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
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
                    Text("Login/Sign Up",
                        style: FontStyles.font20Semibold
                            .copyWith(color: AppColors.whiteColor)),
                  ],
                ),
                Column(
                  children: [
                    // CustomTextField(
                    //   label: "USERNAME",
                    //   hintText: "Enter Username",
                    //   controller: _viewModel.usernameController,
                    //   readOnly: _viewModel.isLoading,
                    //   errorText: _viewModel.usernameError,
                    // ),
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
                      label: "Otp",
                      hintText: "Enter the Otp",
                      controller: _viewModel.otpController,
                      readOnly: _viewModel.isLoading,
                      errorText: _viewModel.otpError,
                    ),
                    const SizedBox(height: 18),

                    CTAButton(
                        title: "Send Otp",
                        loading: _viewModel.isLoading,
                        onTap: () {
                          _widgetIndex = (_widgetIndex + 1) % 3;
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

  Widget registerAuth2(bool mobile) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkBlueColor,
        borderRadius: mobile
            ? null
            : const BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
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
                    Text("Login/Sign Up",
                        style: FontStyles.font20Semibold
                            .copyWith(color: AppColors.whiteColor)),
                  ],
                ),
                Column(
                  children: [
                    CustomTextField(
                      label: "ENTER NEW PASSWORD",
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
                    const SizedBox(height: 18),
                    CustomTextField(
                      label: "Otp",
                      hintText: "Enter the Otp",
                      controller: _viewModel.otpController,
                      readOnly: _viewModel.isLoading,
                      errorText: _viewModel.otpError,
                    ),
                    const SizedBox(height: 18),
                    CTAButton(
                        title: "Proceed",
                        loading: _viewModel.isLoading,
                        onTap: () {
                          _widgetIndex = (_widgetIndex + 1) % 3;
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

  Widget uploadDocuments() {
    return Container(
      height: double.infinity,
      width: MediaQuery.of(context).size.width * 0.7,
      color: AppColors.yellowColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Document Upload",
                  style: FontStyles.font24Semibold,
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(text[index]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text("Upload Pan"),
                                  Icon(Icons.arrow_upward)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            CTAButton(
              title: "Save And Submmits",
              color: AppColors.blueColor,
              onTap: () {
                _showNewWidget = !_showNewWidget;
              },
            )
          ],
        ),
      ),
    );
  }
}

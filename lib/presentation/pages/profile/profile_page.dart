import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:intl/intl.dart';
import 'package:admin/core/enum/role.dart';
import 'package:admin/presentation/pages/profile/profile_view_model.dart';
import 'package:admin/presentation/pages/widgets/custom_textfield.dart';
import 'package:admin/presentation/pages/widgets/footer.dart';
import 'package:admin/presentation/pages/widgets/header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  static const String routeName = "/profile";
  const ProfilePage({super.key, required this.userID});
  final String userID;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late final ProfileViewModel _viewModel;
  @override
  void initState() {
    _viewModel = ref.read(ProfileViewModel.provider);
    _viewModel.fetchUser(widget.userID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(ProfileViewModel.provider);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: _viewModel.isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ListView(
              children: [
                const Header(mobile: false),
                Form(
                  key: _viewModel.formKey,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ListView(
                      children: [
                        ListTile(
                          title: Text("Profile",
                              style: FontStyles.font24Semibold.copyWith(
                                  fontSize: 48, color: AppColors.blueColor)),
                          subtitle: Text(
                              "Your profile details are updated here",
                              style: FontStyles.font12Medium
                                  .copyWith(color: AppColors.blueColor)),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              child: CachedNetworkImage(
                                  imageUrl: "", height: 200, width: 200),
                            ),
                            ListView(
                              shrinkWrap: true,
                              children: [
                                Row(
                                  children: [
                                    const Text("Name"),
                                    CustomTextField(
                                      hintText: "Your Name",
                                      controller: _viewModel.nameController,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Email"),
                                    AbsorbPointer(
                                      child: CustomTextField(
                                        errorText: _viewModel.emailError,
                                        hintText: "Your Email",
                                        controller: _viewModel.emailController,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Phone"),
                                    CustomTextField(
                                      errorText: _viewModel.phoneError,
                                      hintText: "Your Phone number",
                                      controller: _viewModel.phoneController,
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: _viewModel.getUser.userType ==
                                      UserType.vendor,
                                  child: Row(
                                    children: [
                                      const Text("Company Name"),
                                      CustomTextField(
                                        hintText: "Your Company Name",
                                        controller:
                                            _viewModel.companyNameController,
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: _viewModel.getUser.userType ==
                                      UserType.vendor,
                                  child: Row(
                                    children: [
                                      const Text("Permanent Address"),
                                      CustomTextField(
                                        hintText: "Your Permanent Address",
                                        controller: _viewModel
                                            .permanentAddressController,
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: _viewModel.getUser.userType ==
                                      UserType.vendor,
                                  child: Row(
                                    children: [
                                      const Text("Start Working Hour"),
                                      InkWell(
                                        onTap: () async {
                                          TimeOfDay? pickedTime =
                                              await showTimePicker(
                                            initialTime: TimeOfDay.now(),
                                            context: context,
                                          );
                                          if (pickedTime != null) {
                                            _viewModel
                                                    .startingWorkHourController
                                                    .text =
                                                DateFormat.jm()
                                                    .parse(
                                                        pickedTime.toString())
                                                    .toString();
                                          }
                                        },
                                        child: AbsorbPointer(
                                          child: CustomTextField(
                                            hintText: "Your Starting Work Time",
                                            controller: _viewModel
                                                .startingWorkHourController,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Footer(),
              ],
            ),
    );
  }
}

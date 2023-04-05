import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/enum/role.dart';
import 'package:admin/presentation/pages/profile/profile_view_model.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:admin/presentation/pages/widgets/custom_textfield.dart';
import 'package:admin/presentation/pages/widgets/footer.dart';
import 'package:admin/presentation/pages/widgets/header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchUser(widget.userID);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(ProfileViewModel.provider);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: _viewModel.isLoading || _viewModel.getUser == null
          ? const Center(child: CircularProgressIndicator.adaptive())
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  const Header(mobile: false),
                  Form(
                    key: _viewModel.formKey,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ListView(
                        shrinkWrap: true,
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 150,
                                        child: CachedNetworkImage(imageUrl: ""),
                                      ),
                                      TextButton(
                                          onPressed: () {},
                                          child: const Text("Edit")),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height,
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Name"),
                                            CustomTextField(
                                              hintText: "Your Name",
                                              controller:
                                                  _viewModel.nameController,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Email"),
                                            CustomTextField(
                                              disable: true,
                                              errorText: _viewModel.emailError,
                                              hintText: "Your Email",
                                              controller:
                                                  _viewModel.emailController,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Phone"),
                                            CustomTextField(
                                              errorText: _viewModel.phoneError,
                                              hintText: "Your Phone number",
                                              controller:
                                                  _viewModel.phoneController,
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible:
                                              _viewModel.getUser!.userType ==
                                                  UserType.vendor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Company Name"),
                                              CustomTextField(
                                                hintText: "Your Company Name",
                                                controller: _viewModel
                                                    .companyNameController,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              _viewModel.getUser!.userType ==
                                                  UserType.vendor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Permanent Address"),
                                              CustomTextField(
                                                hintText:
                                                    "Your Permanent Address",
                                                controller: _viewModel
                                                    .permanentAddressController,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              _viewModel.getUser!.userType ==
                                                  UserType.vendor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Start Working Hour"),
                                              InkWell(
                                                onTap: () async {
                                                  TimeOfDay? pickedTime =
                                                      await showTimePicker(
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                    context: context,
                                                  );
                                                  if (pickedTime != null) {
                                                    _viewModel
                                                        .startingWorkHourController
                                                        .text = DateFormat
                                                            .jm()
                                                        .parse(pickedTime
                                                            .toString())
                                                        .toString();
                                                  }
                                                },
                                                child: CustomTextField(
                                                  disable: true,
                                                  hintText:
                                                      "Your Starting Work Time",
                                                  controller: _viewModel
                                                      .startingWorkHourController,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              _viewModel.getUser!.userType ==
                                                  UserType.vendor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("End Working Hour"),
                                              InkWell(
                                                onTap: () async {
                                                  TimeOfDay? pickedTime =
                                                      await showTimePicker(
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                    context: context,
                                                  );
                                                  if (pickedTime != null) {
                                                    _viewModel
                                                        .endingWorkHourController
                                                        .text = DateFormat
                                                            .jm()
                                                        .parse(pickedTime
                                                            .toString())
                                                        .toString();
                                                  }
                                                },
                                                child: CustomTextField(
                                                  disable: true,
                                                  hintText:
                                                      "Your Ending Work Time",
                                                  controller: _viewModel
                                                      .endingWorkHourController,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              _viewModel.getUser!.userType ==
                                                  UserType.vendor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Bank Account Number"),
                                              CustomTextField(
                                                errorText: _viewModel
                                                    .accountNumberError,
                                                hintText:
                                                    "Your Bank account number",
                                                controller: _viewModel
                                                    .accountNumberController,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              _viewModel.getUser!.userType ==
                                                  UserType.vendor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Bank IFSC code"),
                                              CustomTextField(
                                                hintText: "Your Bank IFSC code",
                                                controller:
                                                    _viewModel.ifscController,
                                              ),
                                            ],
                                          ),
                                        ),
                                        // TODO qualification (degree and university) dropdown
                                        Visibility(
                                          visible:
                                              _viewModel.getUser!.userType ==
                                                  UserType.vendor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Associate Name"),
                                              CustomTextField(
                                                hintText: "Your Associate name",
                                                controller: _viewModel
                                                    .associateNameController,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              _viewModel.getUser!.userType ==
                                                  UserType.vendor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Associate Address"),
                                              CustomTextField(
                                                hintText: "Same as ",
                                                controller: _viewModel
                                                    .associateAddressController,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              _viewModel.getUser!.userType ==
                                                  UserType.vendor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                  "Associate Permanent Address"),
                                              CustomTextField(
                                                hintText:
                                                    "Your Associate permanet address",
                                                controller: _viewModel
                                                    .associatePermanentAddressController,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              _viewModel.getUser!.userType ==
                                                  UserType.vendor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Qualified Year"),
                                              CustomTextField(
                                                errorText: _viewModel
                                                    .qualifiedYearError,
                                                hintText: "Your qualified year",
                                                controller: _viewModel
                                                    .qualifiedYearController,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              _viewModel.getUser!.userType ==
                                                  UserType.vendor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                  "Practicing Experience"),
                                              CustomTextField(
                                                errorText: _viewModel
                                                    .practicingExperienceError,
                                                hintText:
                                                    "Your practicing experience in months",
                                                controller: _viewModel
                                                    .practicingExperienceController,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              _viewModel.getUser!.userType ==
                                                  UserType.vendor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Landline number"),
                                              CustomTextField(
                                                errorText:
                                                    _viewModel.landlineError,
                                                hintText:
                                                    "Your landline number",
                                                controller: _viewModel
                                                    .landlineController,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              _viewModel.getUser!.userType ==
                                                  UserType.vendor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Mobile"),
                                              CustomTextField(
                                                errorText:
                                                    _viewModel.mobileError,
                                                hintText: "Your mobile number",
                                                controller:
                                                    _viewModel.mobileController,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              _viewModel.getUser!.userType ==
                                                  UserType.vendor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Pan Card"),
                                              Row(
                                                children: [
                                                  ..._viewModel.documents.pan !=
                                                          null
                                                      ? [
                                                          IconButton(
                                                              onPressed: () {
                                                                // TODO
                                                              },
                                                              icon: const Icon(
                                                                  Icons
                                                                      .download)),
                                                          IconButton(
                                                              onPressed: () {
                                                                // TODO
                                                              },
                                                              icon: const Icon(
                                                                  Icons.edit)),
                                                        ]
                                                      : [
                                                          IconButton(
                                                              onPressed:
                                                                  () async {
                                                                final file = await _viewModel.pickFile(
                                                                    await FilePicker
                                                                        .platform
                                                                        .pickFiles());
                                                                if (file !=
                                                                    null) {
                                                                  _viewModel
                                                                      .uploadPan(
                                                                          file:
                                                                              file);
                                                                }
                                                              },
                                                              icon: const Icon(Icons
                                                                  .upload_file))
                                                        ],
                                                  Text(
                                                    "(jpg, jpeg, png, pdf)*",
                                                    style: FontStyles
                                                        .font12Regular
                                                        .copyWith(
                                                            color: AppColors
                                                                .lightBlueColor,
                                                            fontStyle: FontStyle
                                                                .italic),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                                child: const Text("Cancel"),
                                                onPressed: () {
                                                  // TODO
                                                }),
                                            const SizedBox(width: 8),
                                            CTAButton(
                                              title: "Save",
                                              onTap: () {
                                                if (_viewModel.validate()) {
                                                  _viewModel.saveProfileData();
                                                }
                                              },
                                              color: AppColors.darkGreenColor,
                                              fullWidth: false,
                                              radius: 4,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Footer(),
                ],
              ),
            ),
    );
  }
}

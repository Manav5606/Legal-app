// ignore_for_file: prefer_const_constructors

import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/enum/role.dart';
import 'package:admin/presentation/pages/profile/profile_view_model.dart';
import 'package:admin/presentation/pages/profile/widget/add_qualification_degree.dart';
import 'package:admin/presentation/pages/profile/widget/add_qualification_university.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:admin/presentation/pages/widgets/custom_textfield.dart';
import 'package:admin/presentation/pages/widgets/footer.dart';
import 'package:admin/presentation/pages/widgets/header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
      _viewModel.clearSelectedServices();
    });
    super.initState();
  }

  List<CheckboxListTile> checkboxListTiles = [];
  String? docRefId;

  @override
  Widget build(BuildContext context) {
    ref.watch(ProfileViewModel.provider);
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('vendor-service');

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
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.darkBlueColor,
                                            width: 2,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 100,
                                          backgroundImage:
                                              _viewModel.profileLoading
                                                  ? null
                                                  : CachedNetworkImageProvider(
                                                      _viewModel.getUser
                                                              ?.profilePic ??
                                                          ""),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      TextButton(
                                          onPressed: _viewModel.profileLoading
                                              ? null
                                              : () async {
                                                  final file = await _viewModel
                                                      .pickFile(await FilePicker
                                                          .platform
                                                          .pickFiles());
                                                  if (file != null) {
                                                    await _viewModel
                                                        .uploadProfilePic(
                                                            file: file);
                                                  }
                                                },
                                          child: _viewModel.profileLoading
                                              ? const CircularProgressIndicator
                                                  .adaptive()
                                              : const Text("Edit")),
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
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  SizedBox(
                                                    width: 200,
                                                    height: 40,
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Name",
                                                          style: FontStyles
                                                              .font14Semibold
                                                              .copyWith(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                        )),
                                                  ),
                                                  Expanded(
                                                    child: CustomTextField(
                                                      hintText: "Your Name",
                                                      controller: _viewModel
                                                          .nameController,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  SizedBox(
                                                    width: 200,
                                                    height: 40,
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Email",
                                                          style: FontStyles
                                                              .font14Semibold
                                                              .copyWith(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                        )),
                                                  ),
                                                  Expanded(
                                                    child: CustomTextField(
                                                      hintText: "Your Email",
                                                      controller: _viewModel
                                                          .emailController,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  SizedBox(
                                                    width: 200,
                                                    height: 40,
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Phone",
                                                          style: FontStyles
                                                              .font14Semibold
                                                              .copyWith(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                        )),
                                                  ),
                                                  Expanded(
                                                    child: CustomTextField(
                                                      hintText:
                                                          "Your Phone Number",
                                                      controller: _viewModel
                                                          .phoneController,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Company Name",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: CustomTextField(
                                                        hintText:
                                                            "Your Company Name",
                                                        controller: _viewModel
                                                            .companyNameController,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Permanent Adddress",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: CustomTextField(
                                                        hintText:
                                                            "Your Permanent Address",
                                                        controller: _viewModel
                                                            .permanentAddressController,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Start Working Hour",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () async {
                                                          TimeOfDay?
                                                              pickedTime =
                                                              await showTimePicker(
                                                            initialTime:
                                                                TimeOfDay.now(),
                                                            context: context,
                                                          );
                                                          if (pickedTime !=
                                                              null) {
                                                            _viewModel
                                                                .setStartingHour(
                                                                    pickedTime);
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
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Ending Working Hour",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () async {
                                                          TimeOfDay?
                                                              pickedTime =
                                                              await showTimePicker(
                                                            initialTime:
                                                                TimeOfDay.now(),
                                                            context: context,
                                                          );
                                                          if (pickedTime !=
                                                              null) {
                                                            _viewModel
                                                                .setEndingHour(
                                                                    pickedTime);
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
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Bank Account Number",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: CustomTextField(
                                                        hintText:
                                                            "Your Account Number",
                                                        controller: _viewModel
                                                            .accountNumberController,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Bank IFSC code",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: CustomTextField(
                                                        hintText:
                                                            "Your IFSC code",
                                                        controller: _viewModel
                                                            .ifscController,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Qualification Degree",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Wrap(
                                                            spacing: 2,
                                                            children: _viewModel
                                                                .getQualificationDegree
                                                                .map((e) => Chip(
                                                                    label: Text(
                                                                        e)))
                                                                .toList(),
                                                          ),
                                                          TextButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (_) {
                                                                      return const AddQualificationDegree();
                                                                    });
                                                              },
                                                              child: const Text(
                                                                  "Add"))
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Qualification University",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Wrap(
                                                            spacing: 2,
                                                            children: _viewModel
                                                                .getQualificationUniversity
                                                                .map((e) => Chip(
                                                                    label: Text(
                                                                        e)))
                                                                .toList(),
                                                          ),
                                                          TextButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (_) {
                                                                      return const AddQualificationUniversity();
                                                                    });
                                                              },
                                                              child: const Text(
                                                                  "Add"))
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Associate name",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: CustomTextField(
                                                        hintText:
                                                            "Your Associate name",
                                                        controller: _viewModel
                                                            .associateNameController,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Associate address",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: CustomTextField(
                                                        hintText: "Same as",
                                                        controller: _viewModel
                                                            .associateAddressController,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Qualified year",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: CustomTextField(
                                                        hintText:
                                                            "Your qualified year",
                                                        controller: _viewModel
                                                            .qualifiedYearController,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Practicing Experience",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: CustomTextField(
                                                        hintText:
                                                            "Your practicing experience in months",
                                                        controller: _viewModel
                                                            .practicingExperienceController,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Landline number",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: CustomTextField(
                                                        hintText:
                                                            "Your landline number",
                                                        controller: _viewModel
                                                            .landlineController,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Mobile number",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: CustomTextField(
                                                        hintText:
                                                            "Your mobile number",
                                                        controller: _viewModel
                                                            .mobileController,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Pan Card",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          ..._viewModel
                                                                      .documents
                                                                      .pan !=
                                                                  null
                                                              ? [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return Dialog(
                                                                            child:
                                                                                Container(
                                                                              width: 300,
                                                                              height: 400,
                                                                              child: Image.network(
                                                                                _viewModel.documents.pan!,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          20,
                                                                      width: 50,
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors
                                                                              .viewblue,
                                                                          borderRadius:
                                                                              BorderRadius.circular(20)),
                                                                      child: Center(
                                                                          child: Text(
                                                                        "View",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        launchUrlString(_viewModel
                                                                            .documents
                                                                            .pan!);
                                                                      },
                                                                      icon:
                                                                          Expanded(
                                                                        child: const Icon(
                                                                            Icons.download),
                                                                      )),
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .panLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadPan(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .panLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : Expanded(
                                                                              child: const Icon(Icons.edit),
                                                                            )),
                                                                ]
                                                              : [
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .panLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadPan(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .panLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : const Icon(
                                                                              Icons.upload_file))
                                                                ],
                                                          Expanded(
                                                            child: Text(
                                                              "(jpg, jpeg, png, pdf)*",
                                                              style: FontStyles
                                                                  .font12Regular
                                                                  .copyWith(
                                                                      color: AppColors
                                                                          .blueColor,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Aadhar Card",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          ..._viewModel
                                                                      .documents
                                                                      .aadhar !=
                                                                  null
                                                              ? [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return Dialog(
                                                                            child:
                                                                                Container(
                                                                              width: 300,
                                                                              height: 400,
                                                                              child: Image.network(
                                                                                _viewModel.documents.aadhar!,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          20,
                                                                      width: 50,
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors
                                                                              .viewblue,
                                                                          borderRadius:
                                                                              BorderRadius.circular(20)),
                                                                      child: Center(
                                                                          child: Text(
                                                                        "View",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        launchUrlString(_viewModel
                                                                            .documents
                                                                            .aadhar!);
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .download)),
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .aadharLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadAadhar(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .aadharLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : const Icon(
                                                                              Icons.edit)),
                                                                ]
                                                              : [
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .panLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadAadhar(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .aadharLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : const Icon(
                                                                              Icons.upload_file))
                                                                ],
                                                          Expanded(
                                                            child: Text(
                                                              "(jpg, jpeg, png, pdf)*",
                                                              style: FontStyles
                                                                  .font12Regular
                                                                  .copyWith(
                                                                      color: AppColors
                                                                          .blueColor,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Agreement",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          ..._viewModel
                                                                      .documents
                                                                      .agreement !=
                                                                  null
                                                              ? [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return Dialog(
                                                                            child:
                                                                                Container(
                                                                              width: 300,
                                                                              height: 400,
                                                                              child: Image.network(
                                                                                _viewModel.documents.agreement!,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          20,
                                                                      width: 50,
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors
                                                                              .viewblue,
                                                                          borderRadius:
                                                                              BorderRadius.circular(20)),
                                                                      child: Center(
                                                                          child: Text(
                                                                        "View",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        launchUrlString(_viewModel
                                                                            .documents
                                                                            .agreement!);
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .download)),
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .agreementLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadAgreement(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .agreementLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : const Icon(
                                                                              Icons.edit)),
                                                                ]
                                                              : [
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .agreementLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadAgreement(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .agreementLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : const Icon(
                                                                              Icons.upload_file))
                                                                ],
                                                          Expanded(
                                                            child: Text(
                                                              "(jpg, jpeg, png, pdf)*",
                                                              style: FontStyles
                                                                  .font12Regular
                                                                  .copyWith(
                                                                      color: AppColors
                                                                          .blueColor,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Google Map",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          ..._viewModel
                                                                      .documents
                                                                      .googleMap !=
                                                                  null
                                                              ? [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return Dialog(
                                                                            child:
                                                                                Container(
                                                                              width: 300,
                                                                              height: 400,
                                                                              child: Image.network(
                                                                                _viewModel.documents.googleMap!,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          20,
                                                                      width: 50,
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors
                                                                              .viewblue,
                                                                          borderRadius:
                                                                              BorderRadius.circular(20)),
                                                                      child: Center(
                                                                          child: Text(
                                                                        "View",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        launchUrlString(_viewModel
                                                                            .documents
                                                                            .googleMap!);
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .download)),
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .googleMapLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadGoogleMap(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .googleMapLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : const Icon(
                                                                              Icons.edit)),
                                                                ]
                                                              : [
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .googleMapLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadGoogleMap(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .googleMapLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : const Icon(
                                                                              Icons.upload_file))
                                                                ],
                                                          Expanded(
                                                            child: Text(
                                                              "(jpg, jpeg, png, pdf)*",
                                                              style: FontStyles
                                                                  .font12Regular
                                                                  .copyWith(
                                                                      color: AppColors
                                                                          .blueColor,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Name Board",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          ..._viewModel
                                                                      .documents
                                                                      .nameBoard !=
                                                                  null
                                                              ? [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return Dialog(
                                                                            child:
                                                                                Container(
                                                                              width: 300,
                                                                              height: 400,
                                                                              child: Image.network(
                                                                                _viewModel.documents.nameBoard!,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          20,
                                                                      width: 50,
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors
                                                                              .viewblue,
                                                                          borderRadius:
                                                                              BorderRadius.circular(20)),
                                                                      child: Center(
                                                                          child: Text(
                                                                        "View",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        launchUrlString(_viewModel
                                                                            .documents
                                                                            .nameBoard!);
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .download)),
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .nameBoardLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadNameBoard(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .nameBoardLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : const Icon(
                                                                              Icons.edit)),
                                                                ]
                                                              : [
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .nameBoardLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadNameBoard(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .nameBoardLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : const Icon(
                                                                              Icons.upload_file))
                                                                ],
                                                          Expanded(
                                                            child: Text(
                                                              "(jpg, jpeg, png, pdf)*",
                                                              style: FontStyles
                                                                  .font12Regular
                                                                  .copyWith(
                                                                      color: AppColors
                                                                          .blueColor,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Pass Photo",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          ..._viewModel
                                                                      .documents
                                                                      .passPhoto !=
                                                                  null
                                                              ? [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return Dialog(
                                                                            child:
                                                                                Container(
                                                                              width: 300,
                                                                              height: 400,
                                                                              child: Image.network(
                                                                                _viewModel.documents.passPhoto!,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          20,
                                                                      width: 50,
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors
                                                                              .viewblue,
                                                                          borderRadius:
                                                                              BorderRadius.circular(20)),
                                                                      child: Center(
                                                                          child: Text(
                                                                        "View",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        launchUrlString(_viewModel
                                                                            .documents
                                                                            .passPhoto!);
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .download)),
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .passPhotoLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadPassPhoto(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .passPhotoLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : const Icon(
                                                                              Icons.edit)),
                                                                ]
                                                              : [
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .passPhotoLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadPassPhoto(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .passPhotoLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : const Icon(
                                                                              Icons.upload_file))
                                                                ],
                                                          Expanded(
                                                            child: Text(
                                                              "(jpg, jpeg, png, pdf)*",
                                                              style: FontStyles
                                                                  .font12Regular
                                                                  .copyWith(
                                                                      color: AppColors
                                                                          .blueColor,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Power Bill",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          ..._viewModel
                                                                      .documents
                                                                      .powerBill !=
                                                                  null
                                                              ? [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return Dialog(
                                                                            child:
                                                                                Container(
                                                                              width: 300,
                                                                              height: 400,
                                                                              child: Image.network(
                                                                                _viewModel.documents.powerBill!,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          20,
                                                                      width: 50,
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors
                                                                              .viewblue,
                                                                          borderRadius:
                                                                              BorderRadius.circular(20)),
                                                                      child: Center(
                                                                          child: Text(
                                                                        "View",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        launchUrlString(_viewModel
                                                                            .documents
                                                                            .powerBill!);
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .download)),
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .powerBillLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadPowerBill(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .powerBillLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : const Icon(
                                                                              Icons.edit)),
                                                                ]
                                                              : [
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .powerBillLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadPowerBill(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .powerBillLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : const Icon(
                                                                              Icons.upload_file))
                                                                ],
                                                          Expanded(
                                                            child: Text(
                                                              "(jpg, jpeg, png, pdf)*",
                                                              style: FontStyles
                                                                  .font12Regular
                                                                  .copyWith(
                                                                      color: AppColors
                                                                          .blueColor,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Practice Certificate",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          ..._viewModel
                                                                      .documents
                                                                      .practiceCerti !=
                                                                  null
                                                              ? [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return Dialog(
                                                                            child:
                                                                                Container(
                                                                              width: 300,
                                                                              height: 400,
                                                                              child: Image.network(
                                                                                _viewModel.documents.practiceCerti!,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          20,
                                                                      width: 50,
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors
                                                                              .viewblue,
                                                                          borderRadius:
                                                                              BorderRadius.circular(20)),
                                                                      child: Center(
                                                                          child: Text(
                                                                        "View",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        launchUrlString(_viewModel
                                                                            .documents
                                                                            .practiceCerti!);
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .download)),
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .practiceCertiLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadPracticeCerti(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .practiceCertiLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : const Icon(
                                                                              Icons.edit)),
                                                                ]
                                                              : [
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .practiceCertiLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadPan(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .practiceCertiLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : const Icon(
                                                                              Icons.upload_file))
                                                                ],
                                                          Expanded(
                                                            child: Text(
                                                              "(jpg, jpeg, png, pdf)*",
                                                              style: FontStyles
                                                                  .font12Regular
                                                                  .copyWith(
                                                                      color: AppColors
                                                                          .blueColor,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: _viewModel
                                                        .getUser!.userType ==
                                                    UserType.vendor,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      height: 40,
                                                      child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Validity Date of Practice Certificate",
                                                            style: FontStyles
                                                                .font14Semibold
                                                                .copyWith(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          ..._viewModel
                                                                      .documents
                                                                      .validityDateOfPracticeCertificate !=
                                                                  null
                                                              ? [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return Dialog(
                                                                            child:
                                                                                Container(
                                                                              width: 300,
                                                                              height: 400,
                                                                              child: Image.network(
                                                                                _viewModel.documents.validityDateOfPracticeCertificate!,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          20,
                                                                      width: 50,
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors
                                                                              .viewblue,
                                                                          borderRadius:
                                                                              BorderRadius.circular(20)),
                                                                      child: Center(
                                                                          child: Text(
                                                                        "View",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        launchUrlString(_viewModel
                                                                            .documents
                                                                            .validityDateOfPracticeCertificate!);
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .download)),
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .validityDateOfPracticeCertificateLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadPan(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .validityDateOfPracticeCertificateLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : const Icon(
                                                                              Icons.edit)),
                                                                ]
                                                              : [
                                                                  IconButton(
                                                                      onPressed: _viewModel
                                                                              .validityDateOfPracticeCertificateLoading
                                                                          ? null
                                                                          : () async {
                                                                              final file = await _viewModel.pickFile(await FilePicker.platform.pickFiles());
                                                                              if (file != null) {
                                                                                await _viewModel.uploadPan(file: file);
                                                                              }
                                                                            },
                                                                      icon: _viewModel
                                                                              .validityDateOfPracticeCertificateLoading
                                                                          ? const CircularProgressIndicator
                                                                              .adaptive()
                                                                          : const Icon(
                                                                              Icons.upload_file))
                                                                ],
                                                          Expanded(
                                                            child: Text(
                                                              "(jpg, jpeg, png, pdf)*",
                                                              style: FontStyles
                                                                  .font12Regular
                                                                  .copyWith(
                                                                      color: AppColors
                                                                          .blueColor,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              _viewModel.getUser!.userType ==
                                                  UserType.vendor,
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 16),
                                              const SizedBox(height: 8),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 28.0),
                                                child: ExpansionTile(
                                                  title: Text(
                                                    'Select services:',
                                                    style: FontStyles
                                                        .font14Semibold
                                                        .copyWith(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  "Services"),
                                                              content: SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.5,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.7,
                                                                child: ListView
                                                                    .builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount:
                                                                      _viewModel
                                                                          .getService
                                                                          .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    final service =
                                                                        _viewModel
                                                                            .getService[index];

                                                                    return Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                300,
                                                                            child:
                                                                                Text(service.aboutDescription),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                20),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            FutureBuilder<DocumentSnapshot>(
                                                                              future: usersRef.where('vendor_id', isEqualTo: widget.userID).get().then((snapshot) => snapshot.docs.isNotEmpty ? snapshot.docs.first.reference.get() : Future.value(null)),
                                                                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                                                                if (snapshot.connectionState == ConnectionState.done) {
                                                                                  final docRef = snapshot.data;
                                                                                  if (docRef != null && docRef.get('service_id').contains(service.id)) {
                                                                                    return Text("Already Added");
                                                                                  } else {
                                                                                    return ElevatedButton(
                                                                                      onPressed: () async {
                                                                                        final myList = [
                                                                                          service.id!
                                                                                        ];
                                                                                        await _viewModel.addService(myList, widget.userID);
                                                                                        setState(() {}); // Update the dialog content
                                                                                      },
                                                                                      child: Text("Add"),
                                                                                    );
                                                                                  }
                                                                                } else {
                                                                                  return Text("Loading...");
                                                                                }
                                                                              },
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            final myList =
                                                                                [
                                                                              service.id!
                                                                            ];
                                                                            await _viewModel.removeServicesFromVendor(myList,
                                                                                widget.userID);
                                                                            setState(() {}); // Update the dialog content
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            "Remove",
                                                                            style:
                                                                                FontStyles.font14Semibold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                      'Close'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                          'Select Services'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 16),
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
                                                onPressed: () =>
                                                    Routemaster.of(context)
                                                        .history
                                                        .back()),
                                            const SizedBox(width: 8),
                                            CTAButton(
                                              title: "Save",
                                              // loading: _viewModel
                                              //         .aadharLoading ||
                                              //     _viewModel.panLoading ||
                                              //     _viewModel.agreementLoading ||
                                              //     _viewModel.googleMapLoading ||
                                              //     _viewModel.nameBoardLoading ||
                                              //     _viewModel.passPhotoLoading ||
                                              //     _viewModel.powerBillLoading ||
                                              //     _viewModel
                                              //         .practiceCertiLoading ||
                                              //     _viewModel
                                              //         .validityDateOfPracticeCertificateLoading,
                                              onTap: () async {
                                                // if (_viewModel.validate()) {
                                                _viewModel.saveProfileData();
                                                // }

                                                // final selectedServices =
                                                //     _viewModel
                                                //         .getSelectedServices();
                                                // final serviceIds =
                                                //     selectedServices
                                                //         .map((service) =>
                                                //             service.id)
                                                //         .toList();
                                                // // Check if the "users" collection exists
                                                // final usersRef =
                                                //     FirebaseFirestore.instance
                                                //         .collection(
                                                //             'vendor-service');
                                                // final userSnapshot =
                                                //     await usersRef
                                                //         .where('vendor_id',
                                                //             isEqualTo:
                                                //                 widget.userID)
                                                //         .get();
                                                // if (userSnapshot.docs.isEmpty) {
                                                //   // Collection doesn't exist, create document with "service" field
                                                //   final DocumentReference
                                                //       docRef = userSnapshot
                                                //           .docs.first.reference;
                                                //   await docRef.update({
                                                //     // 'vendor_id': widget.userID,
                                                //     'service_id': serviceIds,
                                                //   });
                                                // } else {
                                                //   await usersRef.add({
                                                //     'vendor_id': widget.userID,
                                                //     'service_id': serviceIds,
                                                //   });

                                                //   if (_viewModel.validate()) {
                                                //     _viewModel
                                                //         .saveProfileData();
                                                //   }

                                                // final selectedServices =
                                                //     _viewModel
                                                //         .getSelectedServices();
                                                // final serviceIds =
                                                //     selectedServices
                                                //         .map((service) =>
                                                //             service.id)
                                                //         .toList();
                                                // // Check if the "users" collection exists
                                                // final usersRef =
                                                //     FirebaseFirestore.instance
                                                //         .collection(
                                                //             'vendor-service');
                                                // final userSnapshot =
                                                //     await usersRef
                                                //         .where('vendor_id',
                                                //             isEqualTo:
                                                //                 widget.userID)
                                                //         .get();
                                                // if (userSnapshot.docs.isEmpty) {
                                                //   // Collection doesn't exist, create document with "service" field
                                                //   final DocumentReference
                                                //       docRef = userSnapshot
                                                //           .docs.first.reference;
                                                //   await docRef.update({
                                                //     // 'vendor_id': widget.userID,
                                                //     'service_id': serviceIds,
                                                //   });
                                                // } else {
                                                //   await usersRef.add({
                                                //     'vendor_id': widget.userID,
                                                //     'service_id': serviceIds,
                                                //   });
                                                // }
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

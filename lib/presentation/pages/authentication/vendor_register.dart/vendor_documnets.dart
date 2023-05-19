// ignore_for_file: use_build_context_synchronously
import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/presentation/pages/authentication/vendor_register.dart/vendor_register_view_model.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../../core/enum/qualification.dart';

class VendorDocumentsDetails extends ConsumerStatefulWidget {
  static const String routeName = "/vendor_documents_details";
  final bool navigateBack;
  const VendorDocumentsDetails({super.key, this.navigateBack = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VendorDocumentsDetailsState();
}

class _VendorDocumentsDetailsState
    extends ConsumerState<VendorDocumentsDetails> {
  late final VendorRegisterViewModel _viewModel;
  QualificationUniversity university =
      QualificationUniversity.barCounsilOfIndia;
  QualificationDegree degree = QualificationDegree.ca;
  YearsQualification years = YearsQualification.year2001;

  final text = [
    "Pan Card",
    "Aadhar Card",
    "Practicing Certificate",
    "Validtiy date of Practicing certificate",
    "Passport ",
    "Power Bill",
    "google Map",
    "Agreement between 24hrs & partner",
  ];

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(VendorRegisterViewModel.provider);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(VendorRegisterViewModel.provider);

    return Scaffold(
      body: SafeArea(
        child: ScreenTypeLayout.builder(
          desktop: (context) {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: uploadDocuments(false),
                ),
              ],
            );
          },
          mobile: (context) => uploadDocuments(true),
        ),
      ),
    );
  }

  Widget uploadDocuments(bool mobile) {
    return !mobile
        ? Container(
            height: double.infinity,
            width: MediaQuery.of(context).size.width,
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
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              switch (index) {
                                case 0:
                                  final file = await _viewModel.pickFile(
                                      await FilePicker.platform.pickFiles());
                                  if (file != null) {
                                    await _viewModel.uploadPan(file: file);
                                  }
                                  break;
                                case 1:
                                  final file = await _viewModel.pickFile(
                                      await FilePicker.platform.pickFiles());
                                  if (file != null) {
                                    await _viewModel.uploadAadhar(file: file);
                                  }
                                  break;
                                case 2:
                                  final file = await _viewModel.pickFile(
                                      await FilePicker.platform.pickFiles());
                                  if (file != null) {
                                    await _viewModel.uploadPracticeCerti(
                                        file: file);
                                  }
                                  break;

                                case 3:
                                  final file = await _viewModel.pickFile(
                                      await FilePicker.platform.pickFiles());
                                  if (file != null) {
                                    await _viewModel
                                        .uploadValidityDateOfPracticeCertificate(
                                            file: file);
                                  }
                                  break;

                                case 4:
                                  final file = await _viewModel.pickFile(
                                      await FilePicker.platform.pickFiles());
                                  if (file != null) {
                                    await _viewModel.uploadPassPhoto(
                                        file: file);
                                  }
                                  break;
                                case 5:
                                  final file = await _viewModel.pickFile(
                                      await FilePicker.platform.pickFiles());
                                  if (file != null) {
                                    await _viewModel.uploadPowerBill(
                                        file: file);
                                  }
                                  break;
                                case 6:
                                  final file = await _viewModel.pickFile(
                                      await FilePicker.platform.pickFiles());
                                  if (file != null) {
                                    await _viewModel.uploadGoogleMap(
                                        file: file);
                                  }
                                  break;
                                case 7:
                                  final file = await _viewModel.pickFile(
                                      await FilePicker.platform.pickFiles());
                                  if (file != null) {
                                    await _viewModel.uploadAgreement(
                                        file: file);
                                  }
                                  break;
                                // Add more cases for other indices if needed
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Wrap(
                                          alignment: WrapAlignment.start,
                                          children: [
                                            Text(
                                              text[index],
                                              maxLines: text[index].length > 10
                                                  ? null
                                                  : 1,
                                            ),
                                          ]),
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
                            ),
                          );
                        }),
                  ),
                  CTAButton(
                    title: "Save And Submit",
                    color: AppColors.blueColor,
                    onTap: () async {
                      await _viewModel.register();
                      // await _viewModel.saveProfileData(id);
                    },
                  )
                ],
              ),
            ),
          )
        : Container(
            height: double.infinity,
            width: MediaQuery.of(context).size.width,
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
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              switch (index) {
                                case 0:
                                  final file = await _viewModel.pickFile(
                                      await FilePicker.platform.pickFiles());
                                  if (file != null) {
                                    await _viewModel.uploadPan(file: file);
                                  }
                                  break;
                                case 1:
                                  final file = await _viewModel.pickFile(
                                      await FilePicker.platform.pickFiles());
                                  if (file != null) {
                                    await _viewModel.uploadAadhar(file: file);
                                  }
                                  break;
                                case 2:
                                  final file = await _viewModel.pickFile(
                                      await FilePicker.platform.pickFiles());
                                  if (file != null) {
                                    await _viewModel.uploadPracticeCerti(
                                        file: file);
                                  }
                                  break;

                                case 3:
                                  final file = await _viewModel.pickFile(
                                      await FilePicker.platform.pickFiles());
                                  if (file != null) {
                                    await _viewModel
                                        .uploadValidityDateOfPracticeCertificate(
                                            file: file);
                                  }
                                  break;

                                case 4:
                                  final file = await _viewModel.pickFile(
                                      await FilePicker.platform.pickFiles());
                                  if (file != null) {
                                    await _viewModel.uploadPassPhoto(
                                        file: file);
                                  }
                                  break;
                                case 5:
                                  final file = await _viewModel.pickFile(
                                      await FilePicker.platform.pickFiles());
                                  if (file != null) {
                                    await _viewModel.uploadPowerBill(
                                        file: file);
                                  }
                                  break;
                                case 6:
                                  final file = await _viewModel.pickFile(
                                      await FilePicker.platform.pickFiles());
                                  if (file != null) {
                                    await _viewModel.uploadGoogleMap(
                                        file: file);
                                  }
                                  break;
                                case 7:
                                  final file = await _viewModel.pickFile(
                                      await FilePicker.platform.pickFiles());
                                  if (file != null) {
                                    await _viewModel.uploadAgreement(
                                        file: file);
                                  }
                                  break;
                                // Add more cases for other indices if needed
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Wrap(
                                          alignment: WrapAlignment.start,
                                          children: [
                                            Text(
                                              text[index],
                                              maxLines: text[index].length > 10
                                                  ? null
                                                  : 1,
                                            ),
                                          ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: const [
                                          Text("Upload Pan"),
                                          Icon(Icons.arrow_upward)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  CTAButton(
                    title: "Save And Submit",
                    color: AppColors.blueColor,
                    onTap: () async {
                      // final id = await _viewModel.register();
                      // await _viewModel.saveProfileData();
                    },
                  )
                ],
              ),
            ),
          );
  }
}

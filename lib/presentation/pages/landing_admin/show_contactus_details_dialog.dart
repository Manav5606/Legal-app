import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/landing_admin/dialog/add_banner_view_model.dart';
import 'package:admin/presentation/pages/landing_admin/dialog/contact_us_view_model.dart';
import 'package:admin/presentation/pages/landing_admin/edit_landing_view_model.dart';
import 'package:admin/presentation/pages/landing_admin/show_contact_us_view_model.dart';
import 'package:admin/presentation/pages/widgets/contactus_custom_textfield.dart';
import 'package:admin/presentation/pages/widgets/dialog_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminShowContactUsDialog extends ConsumerStatefulWidget {
  final ContactUsForm? contact;
  const AdminShowContactUsDialog({
    super.key,
    this.contact,
  });

  @override
  ConsumerState<AdminShowContactUsDialog> createState() =>
      _AdminShowContactUsDialogState();
}

class _AdminShowContactUsDialogState
    extends ConsumerState<AdminShowContactUsDialog> {
  late final AdminShowContactUsViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(AdminShowContactUsViewModel.provider);
    _viewModel.firstNameController.text = widget.contact!.firstName;
    _viewModel.lastNameController.text = widget.contact!.lastName;
    _viewModel.mobileNumberController.text = widget.contact!.mobileNumber;
    _viewModel.companyNameController.text = widget.contact!.companyName;
    _viewModel.emailController.text = widget.contact!.email ?? "";
    _viewModel.notesController.text = widget.contact!.notes;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(AdminShowContactUsViewModel.provider);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Contact Us",
                  style: FontStyles.font24Semibold
                      .copyWith(color: AppColors.blueColor)),
              const SizedBox(height: 12),
              ContactUsCustomTextField(
                label: "First Name",
                hintText: "Enter Your First Name",

                controller: _viewModel.firstNameController,
                readOnly: true,
                backgroundColor: AppColors.whiteColor,
                showBorder: true,
                // obscureText: !_viewModel.showPassword,
                errorText: _viewModel.firstNameError,
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
              const SizedBox(height: 12),
              ContactUsCustomTextField(
                label: "Last Name",
                hintText: "Enter Your Last Name",
                controller: _viewModel.lastNameController,
                readOnly: true,
                backgroundColor: AppColors.whiteColor,
                showBorder: true,
                // obscureText: !_viewModel.showPassword,
                errorText: _viewModel.lastNameError,
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
              const SizedBox(height: 12),
              ContactUsCustomTextField(
                label: "Mobile Number",
                hintText: "Enter Your Mobile Number",
                controller: _viewModel.mobileNumberController,
                readOnly: true,
                backgroundColor: AppColors.whiteColor,
                showBorder: true,
                // obscureText: !_viewModel.showPassword,
                errorText: _viewModel.mobileNumberError,
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
              const SizedBox(height: 12),
              ContactUsCustomTextField(
                label: "Company Name",
                hintText: "Enter Your Company Name",
                controller: _viewModel.companyNameController,
                readOnly: true,
                backgroundColor: AppColors.whiteColor,
                showBorder: true,
                // obscureText: !_viewModel.showPassword,
                errorText: _viewModel.companyNameError,
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
              const SizedBox(height: 12),
              ContactUsCustomTextField(
                label: "Email",
                hintText: "Enter Your Email",
                controller: _viewModel.emailController,
                readOnly: true,
                backgroundColor: AppColors.whiteColor,
                showBorder: true,
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
              const SizedBox(height: 12),
              ContactUsCustomTextField(
                label: "Notes",
                hintText: "Type here...",
                controller: _viewModel.notesController,
                readOnly: true,
                backgroundColor: AppColors.whiteColor,
                showBorder: true,
                maxLines: 7,
                // obscureText: !_viewModel.showPassword,
                errorText: _viewModel.notesError,
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: _viewModel.isLoading
                          ? null
                          : () => Navigator.pop(context),
                      child: Text("Back",
                          style: FontStyles.font12Regular
                              .copyWith(color: AppColors.blueColor))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

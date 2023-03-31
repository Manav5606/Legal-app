import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/vendor_admin/vendor_view_model.dart';
import 'package:admin/presentation/pages/vendor_admin/dialog/add_vendor_view_model.dart';
import 'package:admin/presentation/pages/widgets/dialog_textfield.dart';
import 'package:admin/presentation/pages/widgets/password_criteria_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddVendorDialog extends ConsumerStatefulWidget {
  final User? vendorUser;
  const AddVendorDialog({super.key, this.vendorUser});

  @override
  ConsumerState<AddVendorDialog> createState() => _AddVendorDialogState();
}

class _AddVendorDialogState extends ConsumerState<AddVendorDialog> {
  late final AddVendorViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(AddVendorViewModel.provider);
    _viewModel.initVendorUser(widget.vendorUser);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(AddVendorViewModel.provider);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                widget.vendorUser == null
                    ? "Add New Vendor"
                    : "Update Existing Vendor",
                style: FontStyles.font24Semibold
                    .copyWith(color: AppColors.blueColor)),
            Text(
                widget.vendorUser == null
                    ? "Add your new vendor here"
                    : "Update your existing vendor here",
                style: FontStyles.font12Regular
                    .copyWith(color: AppColors.blueColor)),
            const SizedBox(height: 12),
            DialogTextField(
              width: 600 * 0.8,
              errorText: _viewModel.nameError,
              label: "Full Name / Company Name",
              hintText: "Name",
              controller: _viewModel.nameController,
            ),
            const SizedBox(height: 12),
            DialogTextField(
                width: 600 * 0.8,
                errorText: _viewModel.numberError,
                hintText: "9999999999",
                label: "Phone Number",
                controller: _viewModel.numberController),
            const SizedBox(height: 12),
            DialogTextField(
                width: 600 * 0.8,
                hintText: "xyz@abc.com",
                errorText: _viewModel.emailError,
                label: "Email ID",
                controller: _viewModel.emailController),
            const SizedBox(height: 12),
            Visibility(
              visible: widget.vendorUser == null,
              child: DialogTextField(
                  width: 600 * 0.8,
                  hintText: "Password",
                  errorText: _viewModel.passwordError,
                  obscureText: !_viewModel.showPassword,
                  label: "Password",
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
                  controller: _viewModel.passwordController),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: widget.vendorUser != null,
                  child: TextButton(
                      onPressed: _viewModel.isLoading
                          ? null
                          : () async {
                              await _viewModel
                                  .deactivateVendor(widget.vendorUser!)
                                  .then((value) => Navigator.pop(context));
                              await ref
                                  .read(VendorViewModel.provider)
                                  .fetchVendors();
                            },
                      child: Text("Deactivate Vendor",
                          style: FontStyles.font12Regular
                              .copyWith(color: AppColors.redColor))),
                ),
                TextButton(
                    onPressed: _viewModel.isLoading
                        ? null
                        : () => Navigator.pop(context),
                    child: Text("Back",
                        style: FontStyles.font12Regular
                            .copyWith(color: AppColors.blueColor))),
                ElevatedButton(
                  onPressed: _viewModel.isLoading
                      ? null
                      : () async {
                          await _viewModel
                              .createVendor(widget.vendorUser)
                              .then((value) async {
                            if (value != null) {
                              Navigator.pop(context);
                              await ref
                                  .read(VendorViewModel.provider)
                                  .fetchVendors();
                            }
                          });
                        },
                  child: _viewModel.isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : Text(
                          widget.vendorUser == null
                              ? "Add Vendor"
                              : "Update Vendor",
                          style: FontStyles.font12Regular
                              .copyWith(color: AppColors.whiteColor),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

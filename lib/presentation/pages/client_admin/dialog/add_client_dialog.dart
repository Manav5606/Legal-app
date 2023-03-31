import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/client_admin/dialog/add_client_view_model.dart';
import 'package:admin/presentation/pages/client_admin/client_view_model.dart';
import 'package:admin/presentation/pages/widgets/dialog_textfield.dart';
import 'package:admin/presentation/pages/widgets/password_criteria_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddClientDialog extends ConsumerStatefulWidget {
  final User? clientUser;
  const AddClientDialog({super.key, this.clientUser});

  @override
  ConsumerState<AddClientDialog> createState() => _AddClientDialogState();
}

class _AddClientDialogState extends ConsumerState<AddClientDialog> {
  late final AddClientViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(AddClientViewModel.provider);
    _viewModel.initUserUser(widget.clientUser);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(AddClientViewModel.provider);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                widget.clientUser == null
                    ? "Add New Client"
                    : "Update Existing Client",
                style: FontStyles.font24Semibold
                    .copyWith(color: AppColors.blueColor)),
            Text(
                widget.clientUser == null
                    ? "Add your new client here"
                    : "Update your existing client here",
                style: FontStyles.font12Regular
                    .copyWith(color: AppColors.blueColor)),
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
              visible: widget.clientUser == null,
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
                  visible: widget.clientUser != null,
                  child: TextButton(
                      onPressed: _viewModel.isLoading
                          ? null
                          : () async {
                              await _viewModel
                                  .deactivateUser(widget.clientUser!)
                                  .then((value) => Navigator.pop(context));
                              await ref
                                  .read(UserViewModel.provider)
                                  .fetchUsers();
                            },
                      child: Text("Deactivate Client",
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
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreenColor),
                  onPressed: _viewModel.isLoading
                      ? null
                      : () async {
                          await _viewModel
                              .createUser(widget.clientUser)
                              .then((value) async {
                            if (value != null) {
                              Navigator.pop(context);
                              await ref
                                  .read(UserViewModel.provider)
                                  .fetchUsers();
                            }
                          });
                        },
                  child: _viewModel.isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : Text(
                          widget.clientUser == null
                              ? "Add Client"
                              : "Update Client",
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

import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/user_admin/dialog/add_user_view_model.dart';
import 'package:admin/presentation/pages/user_admin/user_view_model.dart';
import 'package:admin/presentation/pages/widgets/dialog_textfield.dart';
import 'package:admin/presentation/pages/widgets/password_criteria_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddUserDialog extends ConsumerStatefulWidget {
  final User? userUser;
  const AddUserDialog({super.key, this.userUser});

  @override
  ConsumerState<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends ConsumerState<AddUserDialog> {
  late final AddUserViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(AddUserViewModel.provider);
    _viewModel.initUserUser(widget.userUser);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(AddUserViewModel.provider);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                widget.userUser == null
                    ? "Add New User"
                    : "Update Existing User",
                style: FontStyles.font24Semibold
                    .copyWith(color: AppColors.blueColor)),
            Text(
                widget.userUser == null
                    ? "Add your new user here"
                    : "Update your existing user here",
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
              visible: widget.userUser == null,
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
                  visible: widget.userUser != null,
                  child: TextButton(
                      onPressed: _viewModel.isLoading
                          ? null
                          : () async {
                              await _viewModel
                                  .deactivateUser(widget.userUser!)
                                  .then((value) => Navigator.pop(context));
                              await ref
                                  .read(UserViewModel.provider)
                                  .fetchUsers();
                            },
                      child: Text("Deactivate User",
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
                              .createUser(widget.userUser)
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
                          widget.userUser == null ? "Add User" : "Update User",
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

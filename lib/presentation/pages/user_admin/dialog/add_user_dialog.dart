import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/user_admin/dialog/add_user_view_model.dart';
import 'package:admin/presentation/pages/user_admin/user_view_model.dart';
import 'package:admin/presentation/pages/widgets/dialog_textfield.dart';
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
              hintText: "Full Name / Company Name",
              controller: _viewModel.nameController,
              errorText: _viewModel.nameError,
            ),
            DialogTextField(
              hintText: "Phone Number",
              errorText: _viewModel.numberError,
              controller: _viewModel.numberController,
            ),
            DialogTextField(
              hintText: "Email ID",
              controller: _viewModel.emailController,
              errorText: _viewModel.emailError,
            ),
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
                  onPressed: _viewModel.isLoading
                      ? null
                      : () async {
                          await _viewModel
                              .createUser(widget.userUser)
                              .then((value) => Navigator.pop(context));
                          await ref.read(UserViewModel.provider).fetchUsers();
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

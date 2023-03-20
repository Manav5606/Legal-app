import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/client_admin/client_view_model.dart';
import 'package:admin/presentation/pages/client_admin/dialog/add_client_view_model.dart';
import 'package:admin/presentation/pages/widgets/dialog_textfield.dart';
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
    _viewModel.initClientUser(widget.clientUser);
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
              errorText: _viewModel.nameError,
              hintText: "Full Name / Company Name",
              controller: _viewModel.nameController,
            ),
            DialogTextField(
                errorText: _viewModel.numberError,
                hintText: "Phone Number",
                controller: _viewModel.numberController),
            DialogTextField(
                errorText: _viewModel.emailError,
                hintText: "Email ID",
                controller: _viewModel.emailController),
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
                                  .deactivateClient(widget.clientUser!)
                                  .then((value) => Navigator.pop(context));
                              await ref
                                  .read(ClientViewModel.provider)
                                  .fetchClients();
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
                  onPressed: _viewModel.isLoading
                      ? null
                      : () async {
                          await _viewModel
                              .createClient(widget.clientUser)
                              .then((value) => Navigator.pop(context));
                          await ref
                              .read(ClientViewModel.provider)
                              .fetchClients();
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

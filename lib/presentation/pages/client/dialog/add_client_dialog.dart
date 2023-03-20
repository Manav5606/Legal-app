import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/presentation/pages/client/client_view_model.dart';
import 'package:admin/presentation/pages/client/dialog/add_client_view_model.dart';
import 'package:admin/presentation/pages/widgets/dialog_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddClientDialog extends ConsumerStatefulWidget {
  const AddClientDialog({super.key});

  @override
  ConsumerState<AddClientDialog> createState() => _AddClientDialogState();
}

class _AddClientDialogState extends ConsumerState<AddClientDialog> {
  late final AddClientViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(AddClientViewModel.provider);
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
            Text("Add New Client",
                style: FontStyles.font24Semibold
                    .copyWith(color: AppColors.blueColor)),
            Text("Add your new client here",
                style: FontStyles.font12Regular
                    .copyWith(color: AppColors.blueColor)),
            DialogTextField(
              hintText: "Full Name / Company Name",
              controller: _viewModel.nameController,
            ),
            DialogTextField(
                hintText: "Phone Number",
                controller: _viewModel.numberController),
            DialogTextField(
                hintText: "Email ID", controller: _viewModel.emailController),
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
                ElevatedButton(
                  onPressed: _viewModel.isLoading
                      ? null
                      : () async {
                          await _viewModel
                              .createClient()
                              .then((value) => Navigator.pop(context));
                          await ref
                              .read(ClientViewModel.provider)
                              .fetchClients();
                        },
                  child: _viewModel.isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : Text(
                          "Add Client",
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

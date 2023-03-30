import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/service_admin/service_view_model.dart';
import 'package:admin/presentation/pages/service_admin/dialog/add_service_view_model.dart';
import 'package:admin/presentation/pages/widgets/dialog_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddServiceDialog extends ConsumerStatefulWidget {
  final Service? serviceDetail;
  const AddServiceDialog({super.key, this.serviceDetail});

  @override
  ConsumerState<AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends ConsumerState<AddServiceDialog> {
  late final AddServiceViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(AddServiceViewModel.provider);
    _viewModel.initService(widget.serviceDetail);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(AddServiceViewModel.provider);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                widget.serviceDetail == null
                    ? "Add Service Service"
                    : "Update Existing Service Service",
                style: FontStyles.font24Semibold
                    .copyWith(color: AppColors.blueColor)),
            Text(
                widget.serviceDetail == null
                    ? "Add service service"
                    : "Update existing service service",
                style: FontStyles.font12Regular
                    .copyWith(color: AppColors.blueColor)),
            const SizedBox(height: 12),
            DialogTextField(
              width: 600 * 0.8,
              errorText: _viewModel.nameError,
              label: "Service Name",
              hintText: "Type here",
              controller: _viewModel.nameController,
            ),
            const SizedBox(height: 12),
            DialogTextField(
              width: 600 * 0.8,
              errorText: _viewModel.descriptionError,
              label: "Service Description",
              hintText: "Type here",
              controller: _viewModel.descriptionController,
              maxLines: 6,
              maxLength: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: widget.serviceDetail != null,
                  child: TextButton(
                      onPressed: _viewModel.isLoading
                          ? null
                          : () async {
                              await _viewModel
                                  .deactivateService(widget.serviceDetail!)
                                  .then((value) => Navigator.pop(context));
                              await ref
                                  .read(ServiceViewModel.provider)
                                  .fetchServices();
                            },
                      child: Text("Deactivate Service",
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
                              .createService(widget.serviceDetail)
                              .then((value) async {
                            if (value != null) {
                              Navigator.pop(context);
                              await ref
                                  .read(ServiceViewModel.provider)
                                  .fetchServices();
                            }
                          });
                        },
                  child: _viewModel.isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : Text(
                          widget.serviceDetail == null
                              ? "Add Service"
                              : "Update Service",
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

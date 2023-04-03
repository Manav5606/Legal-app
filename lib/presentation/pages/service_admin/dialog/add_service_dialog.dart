import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/service_admin/service_view_model.dart';
import 'package:admin/presentation/pages/service_admin/dialog/add_service_view_model.dart';
import 'package:admin/presentation/pages/widgets/dialog_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddServiceDialog extends ConsumerStatefulWidget {
  final String categoryID;
  final Service? serviceDetail;
  final Service? parentServiceDetail;
  const AddServiceDialog({
    super.key,
    required this.categoryID,
    this.serviceDetail,
    this.parentServiceDetail,
  });

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
                widget.serviceDetail == null ||
                        widget.parentServiceDetail != null
                    ? "Add Service"
                    : "Update Existing Service",
                style: FontStyles.font24Semibold
                    .copyWith(color: AppColors.blueColor)),
            Text(
                widget.serviceDetail == null ||
                        widget.parentServiceDetail != null
                    ? "Add service "
                    : "Update existing service",
                style: FontStyles.font12Regular
                    .copyWith(color: AppColors.blueColor)),
            const SizedBox(height: 12),
            DialogTextField(
              width: 600 * 0.8,
              errorText: _viewModel.shortDescError,
              label: "Short Description",
              hintText: "Type here",
              maxLines: 3,
              maxLength: null,
              controller: _viewModel.shortDescController,
            ),
            const SizedBox(height: 12),
            DialogTextField(
              width: 600 * 0.8,
              errorText: _viewModel.aboutDescError,
              label: "About Description",
              hintText: "Type here",
              controller: _viewModel.aboutDescController,
              maxLines: 3,
              maxLength: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 12),
            DialogTextField(
              width: 600 * 0.8,
              errorText: _viewModel.marketPriceError,
              label: "Market Price",
              hintText: "Type here",
              controller: _viewModel.marketPriceController,
            ),
            const SizedBox(height: 12),
            DialogTextField(
              width: 600 * 0.8,
              errorText: _viewModel.ourPriceError,
              label: "Our Price",
              hintText: "Type here",
              controller: _viewModel.ourPriceController,
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
                                  .initCategory(widget.categoryID);
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
                              .createService(
                            existingService: widget.serviceDetail,
                            parentService: widget.parentServiceDetail,
                            categoryID: widget.categoryID,
                          )
                              .then((value) async {
                            if (value != null) {
                              Navigator.pop(context);
                              await ref
                                  .read(ServiceViewModel.provider)
                                  .initCategory(widget.categoryID);
                            }
                          });
                        },
                  child: _viewModel.isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : Text(
                          widget.serviceDetail == null ||
                                  widget.parentServiceDetail != null
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

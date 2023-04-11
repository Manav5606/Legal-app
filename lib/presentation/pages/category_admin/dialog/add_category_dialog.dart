import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/category_admin/category_view_model.dart';
import 'package:admin/presentation/pages/category_admin/dialog/add_category_view_model.dart';
import 'package:admin/presentation/pages/widgets/dialog_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCategoryDialog extends ConsumerStatefulWidget {
  final Category? categoryDetail;
  const AddCategoryDialog({super.key, this.categoryDetail});

  @override
  ConsumerState<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends ConsumerState<AddCategoryDialog> {
  late final AddCategoryViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(AddCategoryViewModel.provider);
    _viewModel.initCategory(widget.categoryDetail);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(AddCategoryViewModel.provider);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                widget.categoryDetail == null
                    ? "Add Service Category"
                    : "Update Existing Service Category",
                style: FontStyles.font24Semibold
                    .copyWith(color: AppColors.blueColor)),
            Text(
                widget.categoryDetail == null
                    ? "Add service category"
                    : "Update existing service category",
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
                  visible: widget.categoryDetail != null,
                  child: TextButton(
                      onPressed: _viewModel.isLoading
                          ? null
                          : () async {
                              if (widget.categoryDetail?.isDeactivated ??
                                  false) {
                                await _viewModel
                                    .activateCategory(widget.categoryDetail!)
                                    .then((value) => Navigator.pop(context));
                              } else {
                                await _viewModel
                                    .deactivateCategory(widget.categoryDetail!)
                                    .then((value) => Navigator.pop(context));
                              }
                              await ref
                                  .read(CategoryViewModel.provider)
                                  .fetchCategories();
                            },
                      child: Text(
                          (widget.categoryDetail?.isDeactivated ?? false)
                              ? "Activate Category"
                              : "Deactivate Category",
                          style: FontStyles.font12Regular.copyWith(
                              color:
                                  widget.categoryDetail?.isDeactivated ?? false
                                      ? AppColors.greenColor
                                      : AppColors.redColor))),
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
                              .createCategory(widget.categoryDetail)
                              .then((value) async {
                            if (value != null) {
                              Navigator.pop(context);
                              await ref
                                  .read(CategoryViewModel.provider)
                                  .fetchCategories();
                            }
                          });
                        },
                  child: _viewModel.isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : Text(
                          widget.categoryDetail == null
                              ? "Add Category"
                              : "Update Category",
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

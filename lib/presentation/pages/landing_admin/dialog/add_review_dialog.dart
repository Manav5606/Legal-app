import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/data/models/customer_review.dart';
import 'package:admin/presentation/pages/landing_admin/dialog/add_review_view_model.dart';
import 'package:admin/presentation/pages/landing_admin/edit_landing_view_model.dart';
import 'package:admin/presentation/pages/widgets/dialog_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddReviewDialog extends ConsumerStatefulWidget {
  final CustomerReview? customerReview;
  const AddReviewDialog({
    super.key,
    this.customerReview,
  });

  @override
  ConsumerState<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends ConsumerState<AddReviewDialog> {
  late final AddReviewViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(AddReviewViewModel.provider);
    _viewModel.initReview(widget.customerReview);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(AddReviewViewModel.provider);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                widget.customerReview == null
                    ? "Add Customer Review"
                    : "Update Existing Customer Review",
                style: FontStyles.font24Semibold
                    .copyWith(color: AppColors.blueColor)),
            Text(
                widget.customerReview == null
                    ? "Add Customer Review"
                    : "Update existing Customer Review",
                style: FontStyles.font12Regular
                    .copyWith(color: AppColors.blueColor)),
            const SizedBox(height: 12),
            DialogTextField(
              width: 600 * 0.8,
              errorText: _viewModel.titleError,
              label: "Title",
              hintText: "Type here",
              controller: _viewModel.titleController,
            ),
            const SizedBox(height: 12),
            DialogTextField(
              width: 600 * 0.8,
              errorText: _viewModel.reviewError,
              label: "Review",
              hintText: "Type here",
              controller: _viewModel.reviewController,
              maxLines: 3,
              maxLength: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 12),
            DialogTextField(
              width: 600 * 0.8,
              errorText: _viewModel.nameError,
              label: "Customer Name",
              hintText: "Type here",
              controller: _viewModel.nameController,
            ),
            const SizedBox(height: 12),
            DialogTextField(
              width: 600 * 0.8,
              errorText: _viewModel.designationError,
              label: "Designation",
              hintText: "Type here",
              controller: _viewModel.designationController,
            ),
            const SizedBox(height: 12),
            SizedBox(
                width: 600 * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        height: 200,
                        width: 600 * 0.3,
                        child: Center(
                            child: _viewModel.imageLoading
                                ? const CircularProgressIndicator.adaptive()
                                : _viewModel.imageUrl == null
                                    ? const Text("Add Profile Pic")
                                    : Image.network(_viewModel.imageUrl!))),
                    TextButton(
                      onPressed: () async {
                        final file = await _viewModel
                            .pickFile(await FilePicker.platform.pickFiles());
                        if (file != null) {
                          await _viewModel.uploadImage(file: file);
                        }
                      },
                      child: const Text("Upload new Image"),
                    )
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: widget.customerReview != null,
                  child: TextButton(
                      onPressed: _viewModel.isLoading
                          ? null
                          : () async {
                              await _viewModel
                                  .deleteReview(widget.customerReview!)
                                  .then((value) => Navigator.pop(context));
                              await ref
                                  .read(EditLandingViewModel.provider)
                                  .initReview();
                            },
                      child: Text("Delete Review",
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
                              .createReview(
                                  existingReview: widget.customerReview)
                              .then((value) async {
                            if (value != null) {
                              Navigator.pop(context);
                              await ref
                                  .read(EditLandingViewModel.provider)
                                  .initReview();
                            }
                          });
                        },
                  child: _viewModel.isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : Text(
                          widget.customerReview == null
                              ? "Add Review"
                              : "Update Review",
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

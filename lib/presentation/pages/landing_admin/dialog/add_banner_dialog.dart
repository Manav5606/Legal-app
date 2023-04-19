import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/landing_admin/dialog/add_banner_view_model.dart';
import 'package:admin/presentation/pages/landing_admin/edit_landing_view_model.dart';
import 'package:admin/presentation/pages/widgets/dialog_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBannerDialog extends ConsumerStatefulWidget {
  final BannerDetail? bannerDetail;
  const AddBannerDialog({
    super.key,
    this.bannerDetail,
  });

  @override
  ConsumerState<AddBannerDialog> createState() => _AddBannerDialogState();
}

class _AddBannerDialogState extends ConsumerState<AddBannerDialog> {
  late final AddBannerViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(AddBannerViewModel.provider);
    _viewModel.initBanner(widget.bannerDetail);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(AddBannerViewModel.provider);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                widget.bannerDetail == null
                    ? "Add Banner"
                    : "Update Existing Banner",
                style: FontStyles.font24Semibold
                    .copyWith(color: AppColors.blueColor)),
            Text(
                widget.bannerDetail == null
                    ? "Add Banner "
                    : "Update existing Banner",
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
              errorText: _viewModel.descriptionError,
              label: "Description",
              hintText: "Type here",
              controller: _viewModel.descriptionController,
              maxLines: 3,
              maxLength: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 12),
            DialogTextField(
              width: 600 * 0.8,
              errorText: _viewModel.btnError,
              label: "Button Name",
              hintText: "Type here",
              controller: _viewModel.btnController,
            ),
            const SizedBox(height: 12),
            DialogTextField(
              width: 600 * 0.8,
              errorText: _viewModel.urlError,
              label: "Url to Load",
              hintText: "Type here",
              controller: _viewModel.urlController,
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
                                    ? const Text("Add Image")
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
                  visible: widget.bannerDetail != null,
                  child: TextButton(
                      onPressed: _viewModel.isLoading
                          ? null
                          : () async {
                              await _viewModel
                                  .deleteBanner(widget.bannerDetail!)
                                  .then((value) => Navigator.pop(context));
                              await ref
                                  .read(EditLandingViewModel.provider)
                                  .initBanner();
                            },
                      child: Text("Delete Banner",
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
                              .createBanner(existingBanner: widget.bannerDetail)
                              .then((value) async {
                            if (value != null) {
                              Navigator.pop(context);
                              await ref
                                  .read(EditLandingViewModel.provider)
                                  .initBanner();
                            }
                          });
                        },
                  child: _viewModel.isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : Text(
                          widget.bannerDetail == null
                              ? "Add Banner"
                              : "Update Banner",
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

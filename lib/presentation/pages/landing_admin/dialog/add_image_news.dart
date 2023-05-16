import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/landing_admin/dialog/add_banner_view_model.dart';
import 'package:admin/presentation/pages/landing_admin/dialog/add_image_news_view_model.dart';
import 'package:admin/presentation/pages/landing_admin/edit_landing_view_model.dart';
import 'package:admin/presentation/pages/widgets/dialog_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddImageNewsDialog extends ConsumerStatefulWidget {
  final NewsImage? newsImageDetail;
  const AddImageNewsDialog({
    super.key,
    this.newsImageDetail,
  });

  @override
  ConsumerState<AddImageNewsDialog> createState() => _AddImageNewsDialogState();
}

class _AddImageNewsDialogState extends ConsumerState<AddImageNewsDialog> {
  late final AddImageNewsViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(AddImageNewsViewModel.provider);
    // _viewModel.initBanner(widget.newsImageDetail);
    _viewModel.fetchNewsImage();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(AddImageNewsViewModel.provider);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  widget.newsImageDetail == null
                      ? "Add News Image"
                      : "Update News Image",
                  style: FontStyles.font24Semibold
                      .copyWith(color: AppColors.blueColor)),
              Text(
                  widget.newsImageDetail == null
                      ? "Add News Image "
                      : "Update existing News Image",
                  style: FontStyles.font12Regular
                      .copyWith(color: AppColors.blueColor)),
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
                                      ? const Text("Add NewsImage")
                                      : Image.network(_viewModel.imageUrl!))),
                      TextButton(
                        onPressed: () async {
                          final file = await _viewModel
                              .pickFile(await FilePicker.platform.pickFiles());
                          if (file != null) {
                            await _viewModel.uploadImage(file: file);
                          }
                        },
                        child: const Text("Upload new NewsImage"),
                      )
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Visibility(
                  //   visible: widget.newsImageDetail != null,
                  //   child: TextButton(
                  //       onPressed: _viewModel.isLoading
                  //           ? null
                  //           : () async {
                  //               await _viewModel
                  //                   .deleteNewsImageDetails(
                  //                       widget.newsImageDetail!)
                  //                   .then((value) => Navigator.pop(context));
                  //               await ref
                  //                   .read(EditLandingViewModel.provider)
                  //                   .initNewsImage();
                  //             },
                  //       child: Text("Delete NewsImage",
                  //           style: FontStyles.font12Regular
                  //               .copyWith(color: AppColors.redColor))),
                  // ),
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
                                .createnewsImageDetails(
                                    existingnewsImageDetails:
                                        widget.newsImageDetail)
                                .then((value) async {
                              if (value != null) {
                                Navigator.pop(context);
                                await ref
                                    .read(EditLandingViewModel.provider)
                                    .initNewsImage();
                              }
                            });
                          },
                    child: _viewModel.isLoading
                        ? const CircularProgressIndicator.adaptive()
                        : Text(
                            widget.newsImageDetail == null
                                ? "Add NewsImage"
                                : "Update NewsImage",
                            style: FontStyles.font12Regular
                                .copyWith(color: AppColors.whiteColor),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

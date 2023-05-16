import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/landing_admin/dialog/add_news_view_model.dart';
import 'package:admin/presentation/pages/landing_admin/edit_landing_view_model.dart';
import 'package:admin/presentation/pages/widgets/dialog_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewsDialog extends ConsumerStatefulWidget {
  final News? news;
  const AddNewsDialog({
    super.key,
    this.news,
  });

  @override
  ConsumerState<AddNewsDialog> createState() => _AddNewsDialogState();
}

class _AddNewsDialogState extends ConsumerState<AddNewsDialog> {
  late final AddNewsViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(AddNewsViewModel.provider);
    _viewModel.initNews(widget.news);
    _viewModel.fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(AddNewsViewModel.provider);
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
              Text(widget.news == null ? "Add News" : "Update Existing News",
                  style: FontStyles.font24Semibold
                      .copyWith(color: AppColors.blueColor)),
              Text(widget.news == null ? "Add Bews " : "Update existing News",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: widget.news != null,
                    child: TextButton(
                        onPressed: _viewModel.isLoading
                            ? null
                            : () async {
                                await _viewModel
                                    .deleteNews(widget.news!)
                                    .then((value) => Navigator.pop(context));
                                await ref
                                    .read(EditLandingViewModel.provider)
                                    .initNews();
                              },
                        child: Text("Delete News",
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
                                .createNews(existingNews: widget.news)
                                .then((value) async {
                              if (value != null) {
                                Navigator.pop(context);
                                await ref
                                    .read(EditLandingViewModel.provider)
                                    .initNews();
                              }
                            });
                          },
                    child: _viewModel.isLoading
                        ? const CircularProgressIndicator.adaptive()
                        : Text(
                            widget.news == null ? "Add News" : "Update News",
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

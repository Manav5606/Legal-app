import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/data/models/models.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/dialog_textfield.dart';
import '../edit_landing_view_model.dart';
import 'add_stats_view_model.dart';

class AddStatsDilaog extends ConsumerStatefulWidget {
  final Stats? statsDetails;
  const AddStatsDilaog({
    super.key,
    this.statsDetails,
  });

  @override
  ConsumerState<AddStatsDilaog> createState() => _AddStatsDilaogState();
}

class _AddStatsDilaogState extends ConsumerState<AddStatsDilaog> {
  late final AddStatsViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(AddStatsViewModel.provider);
    _viewModel.initStats(widget.statsDetails);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(AddStatsViewModel.provider);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                widget.statsDetails == null
                    ? "Add Stats"
                    : "Update Existing Stats",
                style: FontStyles.font24Semibold
                    .copyWith(color: AppColors.blueColor)),
            Text(
                widget.statsDetails == null
                    ? "Add Stats "
                    : "Update existing Stats",
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
                  visible: widget.statsDetails != null,
                  child: TextButton(
                      onPressed: _viewModel.isLoading
                          ? null
                          : () async {
                              await _viewModel
                                  .deleteStats(widget.statsDetails!)
                                  .then((value) => Navigator.pop(context));
                              await ref
                                  .read(EditLandingViewModel.provider)
                                  .initStats();
                            },
                      child: Text("Delete Stats",
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
                              .createStats(existingStats: widget.statsDetails)
                              .then((value) async {
                            if (value != null) {
                              Navigator.pop(context);
                              await ref
                                  .read(EditLandingViewModel.provider)
                                  .initStats();
                            }
                          });
                        },
                  child: _viewModel.isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : Text(
                          widget.statsDetails == null
                              ? "Add Stats"
                              : "Update Stats",
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

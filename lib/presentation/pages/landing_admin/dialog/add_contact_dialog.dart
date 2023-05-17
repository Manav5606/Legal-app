import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/landing_admin/dialog/add_contact_view_model.dart';
import 'package:admin/presentation/pages/landing_admin/edit_landing_view_model.dart';
import 'package:admin/presentation/pages/widgets/dialog_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddContactDialog extends ConsumerStatefulWidget {
  final Category? contactDetail;
  const AddContactDialog({
    super.key,
    this.contactDetail,
  });

  @override
  ConsumerState<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends ConsumerState<AddContactDialog> {
  late final AddContactViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(AddContactViewModel.provider);
    _viewModel.initContact(widget.contactDetail);
  }

  final contact = [
    "Phone",
    "Address",
    "None",
  ];
  String? _selectedCategory;
  bool? _isExpanded;
  @override
  Widget build(BuildContext context) {
    ref.watch(AddContactViewModel.provider);
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
                  widget.contactDetail == null
                      ? "Add Contact"
                      : "Update Existing Contact",
                  style: FontStyles.font24Semibold
                      .copyWith(color: AppColors.blueColor)),
              Text(
                  widget.contactDetail == null
                      ? "Add Contact "
                      : "Update existing Contact",
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
              ExpansionTile(
                title: Text(_selectedCategory == null
                    ? "Select Details"
                    : _selectedCategory.toString()),
                onExpansionChanged: (value) {
                  setState(() {
                    _isExpanded = value;
                  });
                },
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: contact.length,
                      itemBuilder: (BuildContext context, int index) {
                        final category = contact[index];
                        return ListTile(
                          title: Text(category),
                          selected: _selectedCategory == category,
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                              _viewModel.detailController.text = category;
                            });
                          },
                        );
                      }),
                ],
              ),
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
                    visible: widget.contactDetail != null,
                    child: TextButton(
                        onPressed: _viewModel.isLoading
                            ? null
                            : () async {
                                await _viewModel
                                    .deleteContact(widget.contactDetail!)
                                    .then((value) => Navigator.pop(context));
                                await ref
                                    .read(EditLandingViewModel.provider)
                                    .initContactDetails();
                              },
                        child: Text("Delete Contact",
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
                                .createContact(
                                    existingContact: widget.contactDetail)
                                .then((value) async {
                              if (value != null) {
                                Navigator.pop(context);
                                await ref
                                    .read(EditLandingViewModel.provider)
                                    .initContactDetails();
                              }
                            });
                          },
                    child: _viewModel.isLoading
                        ? const CircularProgressIndicator.adaptive()
                        : Text(
                            widget.contactDetail == null
                                ? "Add Contact"
                                : "Update Contact",
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

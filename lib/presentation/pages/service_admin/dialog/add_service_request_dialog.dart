import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/enum/field_type.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/service_admin/dialog/add_service_request_view_model.dart';
import 'package:admin/presentation/pages/service_admin/dialog/manage_service_request_view_model.dart';
import 'package:admin/presentation/pages/widgets/dialog_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddServiceRequestDialog extends ConsumerStatefulWidget {
  final String serviceID;
  final ServiceRequest? serviceRequest;
  const AddServiceRequestDialog({
    super.key,
    required this.serviceID,
    this.serviceRequest,
  });

  @override
  ConsumerState<AddServiceRequestDialog> createState() =>
      _AddServiceDialogState();
}

class _AddServiceDialogState extends ConsumerState<AddServiceRequestDialog> {
  late final AddServiceRequestViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(AddServiceRequestViewModel.provider);
    _viewModel.initServiceRequest(widget.serviceRequest);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(AddServiceRequestViewModel.provider);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                widget.serviceRequest == null
                    ? "Add Service Request"
                    : "Update Existing Service Request",
                style: FontStyles.font24Semibold
                    .copyWith(color: AppColors.blueColor)),
            Text(
                widget.serviceRequest == null
                    ? "Add Service Request"
                    : "Update Existing Service Request",
                style: FontStyles.font12Regular
                    .copyWith(color: AppColors.blueColor)),
            const SizedBox(height: 12),
            DialogTextField(
              width: 600 * 0.8,
              errorText: _viewModel.fieldNameError,
              label: "Field Name",
              hintText: "Type here",
              controller: _viewModel.fieldNameController,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 600 * 0.8,
              child: FormField<ServiceFieldType>(
                builder: (FormFieldState<ServiceFieldType> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      isDense: true,
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.blueColor)),
                      errorText: "",
                      hintText: 'Please select field type',
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<ServiceFieldType>(
                        value: _viewModel.getSelectedFieldType,
                        isDense: true,
                        onChanged: (ServiceFieldType? newValue) {
                          if (newValue != null) {
                            _viewModel.setSelectedFieldType(newValue);
                          }
                        },
                        items: ServiceFieldType.values
                            .map((ServiceFieldType value) {
                          return DropdownMenuItem<ServiceFieldType>(
                            value: value,
                            child: Text(value.name),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: widget.serviceRequest != null,
                  child: TextButton(
                      onPressed: _viewModel.isLoading
                          ? null
                          : () async {
                              await _viewModel
                                  .removeServiceRequest(widget.serviceRequest!)
                                  .then((value) => Navigator.pop(context));
                              await ref
                                  .read(ManageServiceRequestViewModel.provider)
                                  .getAllServiceRequests(
                                      serviceID: widget.serviceID);
                            },
                      child: Text("Delete Service Request",
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
                              .createNewServiceRequest(
                                  serviceID: widget.serviceID)
                              .then((value) async {
                            if (value != null) {
                              Navigator.pop(context);
                              await ref
                                  .read(ManageServiceRequestViewModel.provider)
                                  .getAllServiceRequests(
                                      serviceID: widget.serviceID);
                            }
                          });
                        },
                  child: _viewModel.isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : Text(
                          widget.serviceRequest == null
                              ? "Add Service Request"
                              : "Update Service Request",
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

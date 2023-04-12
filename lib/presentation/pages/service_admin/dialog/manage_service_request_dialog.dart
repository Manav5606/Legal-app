import 'package:admin/presentation/pages/service_admin/dialog/add_service_request_dialog.dart';
import 'package:admin/presentation/pages/service_admin/dialog/add_service_request_view_model.dart';
import 'package:admin/presentation/pages/service_admin/dialog/manage_service_request_view_model.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageServiceRequestDialog extends ConsumerStatefulWidget {
  final String serviceID;
  const ManageServiceRequestDialog({
    super.key,
    required this.serviceID,
  });

  @override
  ConsumerState<ManageServiceRequestDialog> createState() =>
      _AddServiceDialogState();
}

class _AddServiceDialogState extends ConsumerState<ManageServiceRequestDialog> {
  late final ManageServiceRequestViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(ManageServiceRequestViewModel.provider);
    _viewModel.getAllServiceRequests(serviceID: widget.serviceID);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(ManageServiceRequestViewModel.provider);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 600,
        child: _viewModel.isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Close")),
                      CTAButton(
                        title: "Add Service Request",
                        radius: 4,
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => Dialog(
                              insetPadding: const EdgeInsets.all(24),
                              child: AddServiceRequestDialog(
                                  serviceID: widget.serviceID),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _viewModel.getServiceRequests.length,
                    itemBuilder: (_, i) {
                      final sReq = _viewModel.getServiceRequests[i];
                      return ListTile(
                        leading: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => Dialog(
                                  insetPadding: const EdgeInsets.all(24),
                                  child: AddServiceRequestDialog(
                                      serviceRequest: sReq,
                                      serviceID: widget.serviceID),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit)),
                        title: Text(sReq.fieldName),
                        subtitle: Text(sReq.fieldType.name),
                        trailing: IconButton(
                            onPressed: () async {
                              await ref
                                  .read(AddServiceRequestViewModel.provider)
                                  .removeServiceRequest(sReq);
                              await _viewModel.getAllServiceRequests(
                                  serviceID: widget.serviceID);
                            },
                            icon: const Icon(Icons.delete_forever)),
                      );
                    },
                  ),
                ],
              ),
        // : Column(
        //     mainAxisSize: MainAxisSize.min,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //           widget.serviceDetail == null ||
        //                   widget.parentServiceDetail != null
        //               ? "Add Service"
        //               : "Update Existing Service",
        //           style: FontStyles.font24Semibold
        //               .copyWith(color: AppColors.blueColor)),
        //       Text(
        //           widget.serviceDetail == null ||
        //                   widget.parentServiceDetail != null
        //               ? "Add service "
        //               : "Update existing service",
        //           style: FontStyles.font12Regular
        //               .copyWith(color: AppColors.blueColor)),
        //       const SizedBox(height: 12),
        //       DialogTextField(
        //         width: 600 * 0.8,
        //         errorText: _viewModel.shortDescError,
        //         label: "Short Description",
        //         hintText: "Type here",
        //         maxLines: 3,
        //         maxLength: null,
        //         controller: _viewModel.shortDescController,
        //       ),
        //       const SizedBox(height: 12),
        //       DialogTextField(
        //         width: 600 * 0.8,
        //         errorText: _viewModel.aboutDescError,
        //         label: "About Description",
        //         hintText: "Type here",
        //         controller: _viewModel.aboutDescController,
        //         maxLines: 3,
        //         maxLength: null,
        //         keyboardType: TextInputType.multiline,
        //       ),
        //       const SizedBox(height: 12),
        //       DialogTextField(
        //         width: 600 * 0.8,
        //         errorText: _viewModel.marketPriceError,
        //         label: "Market Price",
        //         hintText: "Type here",
        //         controller: _viewModel.marketPriceController,
        //       ),
        //       const SizedBox(height: 12),
        //       DialogTextField(
        //         width: 600 * 0.8,
        //         errorText: _viewModel.ourPriceError,
        //         label: "Our Price",
        //         hintText: "Type here",
        //         controller: _viewModel.ourPriceController,
        //       ),
        //       const SizedBox(height: 12),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.end,
        //         children: [
        //           Visibility(
        //             visible: widget.serviceDetail != null,
        //             child: TextButton(
        //                 onPressed: _viewModel.isLoading
        //                     ? null
        //                     : () async {
        //                         if (widget.serviceDetail?.isDeactivated ??
        //                             false) {
        //                           await _viewModel
        //                               .activateService(
        //                                   widget.serviceDetail!)
        //                               .then((value) =>
        //                                   Navigator.pop(context));
        //                         } else {
        //                           await _viewModel
        //                               .deactivateService(
        //                                   widget.serviceDetail!)
        //                               .then((value) =>
        //                                   Navigator.pop(context));
        //                         }
        //                         await ref
        //                             .read(ServiceViewModel.provider)
        //                             .initCategory(widget.categoryID);
        //                       },
        //                 child: Text(
        //                     widget.serviceDetail?.isDeactivated ?? false
        //                         ? "Activate Category"
        //                         : "Deactivate Service",
        //                     style: FontStyles.font12Regular.copyWith(
        //                         color:
        //                             widget.serviceDetail?.isDeactivated ??
        //                                     false
        //                                 ? AppColors.greenColor
        //                                 : AppColors.redColor))),
        //           ),
        //           TextButton(
        //               onPressed: _viewModel.isLoading
        //                   ? null
        //                   : () => Navigator.pop(context),
        //               child: Text("Back",
        //                   style: FontStyles.font12Regular
        //                       .copyWith(color: AppColors.blueColor))),
        //           ElevatedButton(
        //             onPressed: _viewModel.isLoading
        //                 ? null
        //                 : () async {
        //                     await _viewModel
        //                         .createService(
        //                       existingService: widget.serviceDetail,
        //                       parentService: widget.parentServiceDetail,
        //                       categoryID: widget.categoryID,
        //                     )
        //                         .then((value) async {
        //                       if (value != null) {
        //                         Navigator.pop(context);
        //                         await ref
        //                             .read(ServiceViewModel.provider)
        //                             .initCategory(widget.categoryID);
        //                       }
        //                     });
        //                   },
        //             child: _viewModel.isLoading
        //                 ? const CircularProgressIndicator.adaptive()
        //                 : Text(
        //                     widget.serviceDetail == null ||
        //                             widget.parentServiceDetail != null
        //                         ? "Add Service"
        //                         : "Update Service",
        //                     style: FontStyles.font12Regular
        //                         .copyWith(color: AppColors.whiteColor),
        //                   ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
      ),
    );
  }
}

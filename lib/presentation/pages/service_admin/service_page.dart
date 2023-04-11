import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/data/models/service.dart';
import 'package:admin/presentation/pages/service_admin/service_view_model.dart';
import 'package:admin/presentation/pages/service_admin/dialog/add_service_dialog.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:admin/presentation/utils/web_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServicePage extends ConsumerStatefulWidget {
  static const String routeName = "/service";

  final String categoryID;
  final String categoryName;

  const ServicePage({
    super.key,
    required this.categoryID,
    required this.categoryName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServicePageState();
}

class _ServicePageState extends ConsumerState<ServicePage> {
  late final ServiceViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ref.read(ServiceViewModel.provider);
    _viewModel.initCategory(widget.categoryID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(ServiceViewModel.provider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _heading(),
          const SizedBox(height: 28),
          Expanded(child: _dataTable()),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _dataTable() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: _viewModel.isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : _viewModel.error != null
                ? Center(child: Text("⚠️ ${_viewModel.error}"))
                : ScrollConfiguration(
                    behavior: WebScrollBehavior(),
                    child: ListView(
                      shrinkWrap: true,
                      children: _viewModel.getServices
                          .map((data) => serviceDataNested(data, context))
                          .toList(),
                    ),
                  ));
  }

  Widget serviceDataNested(Service data, BuildContext context) {
    return ExpansionTile(
      title: serviceData(data, context),
      children: data.childServices.map((e) {
        final service = _viewModel.getServiceByID(e);
        return service.childServices.isNotEmpty
            ? serviceDataNested(service, context)
            : serviceData(service, context);
      }).toList(),
    );
  }

  Widget serviceData(Service data, BuildContext context) {
    return data.shortDescription.isEmpty
        ? const SizedBox.shrink()
        : data.ourPrice != null
            ? ListTile(
                tileColor: data.isDeactivated ? AppColors.lightRedColor : null,
                dense: true,
                title: Text(data.shortDescription),
                subtitle: Text(data.aboutDescription),
                leading: PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case "edit":
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => Dialog(
                              insetPadding: const EdgeInsets.all(24),
                              child: AddServiceDialog(
                                  serviceDetail: data,
                                  categoryID: widget.categoryID),
                            ),
                          );
                          break;
                        case "request":
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => Dialog(
                              insetPadding: const EdgeInsets.all(24),
                              child: AddServiceDialog(
                                  serviceDetail: data,
                                  categoryID: widget.categoryID),
                            ),
                          );
                          break;
                      }
                    },
                    itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: "edit",
                            child: Text("Edit"),
                          ),
                          const PopupMenuItem(
                            value: "request",
                            child: Text("Add Request File"),
                          ),
                        ]),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Market Price: ${data.marketPrice}"),
                    Text("Our Price: ${data.ourPrice}"),
                  ],
                ),
              )
            : ListTile(
                dense: true,
                tileColor: data.isDeactivated ? AppColors.lightRedColor : null,
                title: Text(data.shortDescription),
                subtitle: Text(data.aboutDescription),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => Dialog(
                              insetPadding: const EdgeInsets.all(24),
                              child: AddServiceDialog(
                                  serviceDetail: data,
                                  categoryID: widget.categoryID),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => Dialog(
                              insetPadding: const EdgeInsets.all(24),
                              child: AddServiceDialog(
                                parentServiceDetail: data,
                                categoryID: widget.categoryID,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add)),
                  ],
                ),
              );
  }

  // ExpandableTableRow createExpandableTableRow(
  //     Service data, BuildContext context) {
  //   return ExpandableTableRow(
  //     height: 50,
  //     firstCell: const SizedBox.shrink(),
  //     legend: Row(
  //       children: [
  //         (Text(data.id.toString())),
  //         (Text(data.shortDescription.toString())),
  //         (Text(data.aboutDescription.toString())),
  //         (Text((data.marketPrice ?? "").toString())),
  //         (Text((data.ourPrice ?? "").toString())),
  //         (Text(data.createdAt!.formatToDate())),
  //         (Text(data.createdBy.toString())),
  //         (Row(
  //           children: [
  //             TextButton(
  //                 child: const Text("Edit"),
  //                 onPressed: () {
  //                   showDialog(
  //                     context: context,
  //                     barrierDismissible: false,
  //                     builder: (_) => Dialog(
  //                       insetPadding: const EdgeInsets.all(24),
  //                       child: AddServiceDialog(
  //                           serviceDetail: data, categoryID: widget.categoryID),
  //                     ),
  //                   );
  //                 }),
  //             TextButton(
  //                 child: const Text("Add Service"),
  //                 onPressed: () {
  //                   showDialog(
  //                     context: context,
  //                     barrierDismissible: false,
  //                     builder: (_) => Dialog(
  //                       insetPadding: const EdgeInsets.all(24),
  //                       child: AddServiceDialog(
  //                         parentServiceDetail: data,
  //                         categoryID: widget.categoryID,
  //                       ),
  //                     ),
  //                   );
  //                 }),
  //           ],
  //         )),
  //       ],
  //     ),
  //     children: data.childServices.map((e) {
  //       final service = _viewModel.getServiceByID(e);
  //       return createExpandableTableRow(service, context);
  //     }).toList(),
  //   );
  // }

  Widget _heading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Service (${widget.categoryName})",
                style: FontStyles.font24Semibold),
            Text("Your list of service is here",
                style: FontStyles.font14Semibold),
          ],
        ),
        CTAButton(
            title: "Add Service",
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => Dialog(
                  insetPadding: const EdgeInsets.all(24),
                  child: AddServiceDialog(categoryID: widget.categoryID),
                ),
              );
            }),
      ],
    );
  }
}

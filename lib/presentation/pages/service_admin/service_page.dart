import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/extension/date.dart';
import 'package:admin/data/models/service.dart';
import 'package:admin/presentation/pages/service_admin/service_view_model.dart';
import 'package:admin/presentation/pages/service_admin/dialog/add_service_dialog.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:admin/presentation/utils/web_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServicePage extends ConsumerStatefulWidget {
  static const String routeName = "/service";

  final String categoryID;

  const ServicePage({super.key, required this.categoryID});

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
      child: _viewModel.isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : _viewModel.error != null
              ? Center(child: Text("⚠️ ${_viewModel.error}"))
              : LayoutBuilder(builder: (context, constraints) {
                  return ScrollConfiguration(
                    behavior: WebScrollBehavior(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: constraints.minWidth),
                          child: ExpandableTable(
                              header: ExpandableTableHeader(children: [
                                const Text("Service ID"),
                                const Text("Short Description"),
                                const Text("About Description"),
                                const Text("Market Price"),
                                const Text("Our Price"),
                                const Text("Created at"),
                                const Text("Created by"),
                                const Text("Action"),
                              ], firstCell: const SizedBox.shrink()),
                              rows: _viewModel.getServices
                                  .map((data) =>
                                      createExpandableTableRow(data, context))
                                  .toList()),
                          // child: DataTable(
                          //     clipBehavior: Clip.antiAlias,
                          //     border: TableBorder.symmetric(
                          //         outside:
                          //             BorderSide(color: AppColors.greyColor)),
                          //     sortAscending: !_viewModel.sortAscending,
                          //     sortColumnIndex: _viewModel.sortIndex,
                          //     dataRowColor: MaterialStateProperty.all(
                          //         AppColors.lightGreyColor),
                          //     headingRowColor: MaterialStateProperty.all(
                          //         AppColors.whiteColor),
                          //     dataTextStyle: FontStyles.font14Semibold
                          //         .copyWith(color: AppColors.blueColor),
                          //     headingTextStyle: FontStyles.font16Semibold
                          //         .copyWith(color: AppColors.blackColor),
                          //     columns: [
                          //       DataColumn(
                          //         label: const Text("Service ID"),
                          //
                          //       ),
                          //       DataColumn(
                          //         label: const Text("Short Description"),
                          //
                          //       ),
                          //       const DataColumn(
                          //         label: Text("About Description"),
                          //       ),
                          //       const DataColumn(
                          //         label: Text("Market Price"),
                          //       ),
                          //       DataColumn(
                          //         numeric: true,
                          //         label: const Text("Our Price"),
                          //
                          //       ),
                          //       DataColumn(
                          //         label: const Text("Created at"),
                          //
                          //       ),
                          //       DataColumn(
                          //         label: const Text("Created by"),
                          //
                          //       ),
                          //       const DataColumn(label: Text("Action")),
                          //     ],
                          //     rows: _viewModel.getServices
                          //         .where((service) =>
                          //             service.categoryID == widget.categoryID &&
                          //             service.parentServiceID == null)
                          //         .map(
                          //       (data) {
                          //         return DataRow(
                          //           color: data.isDeactivated
                          //               ? MaterialStateProperty.all(
                          //                   AppColors.lightRedColor)
                          //               : null,
                          //           cells: [
                          //             DataCell(Text(data.id.toString())),
                          //             DataCell(Text(
                          //                 data.shortDescription.toString())),
                          //             DataCell(Text(
                          //                 data.aboutDescription.toString())),
                          //             DataCell(Text(
                          //                 (data.marketPrice ?? "").toString())),
                          //             DataCell(Text(
                          //                 (data.ourPrice ?? "").toString())),
                          //             DataCell(
                          //                 Text(data.createdAt!.formatToDate())),
                          //             DataCell(Text(data.createdBy.toString())),
                          //             DataCell(Row(
                          //               children: [
                          //                 TextButton(
                          //                     child: const Text("Edit"),
                          //                     onPressed: () {
                          //                       showDialog(
                          //                         context: context,
                          //                         barrierDismissible: false,
                          //                         builder: (_) => Dialog(
                          //                           insetPadding:
                          //                               const EdgeInsets.all(
                          //                                   24),
                          //                           child: AddServiceDialog(
                          //                               serviceDetail: data,
                          //                               categoryID:
                          //                                   widget.categoryID),
                          //                         ),
                          //                       );
                          //                     }),
                          //                 TextButton(
                          //                     child: const Text("Add Service"),
                          //                     onPressed: () {
                          //                       showDialog(
                          //                         context: context,
                          //                         barrierDismissible: false,
                          //                         builder: (_) => Dialog(
                          //                           insetPadding:
                          //                               const EdgeInsets.all(
                          //                                   24),
                          //                           child: AddServiceDialog(
                          //                             parentServiceDetail: data,
                          //                             categoryID:
                          //                                 widget.categoryID,
                          //                           ),
                          //                         ),
                          //                       );
                          //                     }),
                          //               ],
                          //             )),
                          //           ],
                          //         );
                          //       },
                          //     ).toList()),
                        ),
                      ),
                    ),
                  );
                }),
    );
  }

  ExpandableTableRow createExpandableTableRow(
      Service data, BuildContext context) {
    return ExpandableTableRow(
      height: 50,
      firstCell: const SizedBox.shrink(),
      legend: Row(
        children: [
          (Text(data.id.toString())),
          (Text(data.shortDescription.toString())),
          (Text(data.aboutDescription.toString())),
          (Text((data.marketPrice ?? "").toString())),
          (Text((data.ourPrice ?? "").toString())),
          (Text(data.createdAt!.formatToDate())),
          (Text(data.createdBy.toString())),
          (Row(
            children: [
              TextButton(
                  child: const Text("Edit"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => Dialog(
                        insetPadding: const EdgeInsets.all(24),
                        child: AddServiceDialog(
                            serviceDetail: data, categoryID: widget.categoryID),
                      ),
                    );
                  }),
              TextButton(
                  child: const Text("Add Service"),
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
                  }),
            ],
          )),
        ],
      ),
      children: data.childServices.map((e) {
        final service = _viewModel.getServiceByID(e);
        return createExpandableTableRow(service, context);
      }).toList(),
    );
  }

  Widget _heading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Service", style: FontStyles.font24Semibold),
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

import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/extension/date.dart';
import 'package:admin/presentation/pages/assign_order_dialog/vendor_admin/assign_order_view_model.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:admin/presentation/utils/web_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/user.dart';
import '../../../../data/repositories/database_repositories_impl.dart';

class AssignOrderToVendor extends ConsumerStatefulWidget {
  static const String routeName = "/assign_order";

  const AssignOrderToVendor(this.orderID, this.serviceID, {super.key});
  final String orderID;
  final String serviceID;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AssignOrderToVendorState();
}

class _AssignOrderToVendorState extends ConsumerState<AssignOrderToVendor> {
  late final AssignOrderToVendorViewModel _viewModel;
  // List<User> us = [];
  // Future<void> fetchData() async {
  //   List<String> vendorIds =
  //       await _viewModel.getVendorIdsByService(widget.serviceID);
  //   _viewModel.fetch(vendorIds);

  // }

  @override
  void initState() {
    _viewModel = ref.read(AssignOrderToVendorViewModel.provider);

    _viewModel.fetchData(widget.serviceID, widget.orderID);

    super.initState();
  }

  int? _selectedRadio;
  @override
  Widget build(BuildContext context) {
    ref.watch(AssignOrderToVendorViewModel.provider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _heading(),
          const SizedBox(height: 28),
          Expanded(child: _dataTable()),
          _headingAssignedVendor(),
          const SizedBox(height: 28),
          Expanded(child: _dataTableForAssignedVendors()),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_button()],
          ),
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
                          child: DataTable(
                              clipBehavior: Clip.antiAlias,
                              border: TableBorder.symmetric(
                                  outside:
                                      BorderSide(color: AppColors.greyColor)),
                              sortAscending: !_viewModel.sortAscending,
                              sortColumnIndex: _viewModel.sortIndex,
                              dataRowColor: MaterialStateProperty.all(
                                  AppColors.lightGreyColor),
                              headingRowColor: MaterialStateProperty.all(
                                  AppColors.whiteColor),
                              dataTextStyle: FontStyles.font14Semibold
                                  .copyWith(color: AppColors.blueColor),
                              headingTextStyle: FontStyles.font16Semibold
                                  .copyWith(color: AppColors.blackColor),
                              columns: [
                                DataColumn(
                                  label: const Text(""),
                                  onSort: _viewModel.sortVendors,
                                ),
                                DataColumn(
                                  label: const Text("Vendor ID"),
                                  onSort: _viewModel.sortVendors,
                                ),
                                DataColumn(
                                  numeric: true,
                                  label: const Text("Date"),
                                  onSort: _viewModel.sortVendors,
                                ),
                                DataColumn(
                                  label: const Text("Username"),
                                  onSort: _viewModel.sortVendors,
                                ),
                                DataColumn(
                                  numeric: true,
                                  label: const Text("Contact"),
                                  onSort: _viewModel.sortVendors,
                                ),
                                DataColumn(
                                  label: const Text("Email"),
                                  onSort: _viewModel.sortVendors,
                                ),
                                // const DataColumn(label: Text("Action")),
                              ],
                              rows: _viewModel.getVendors.map(
                                (data) {
                                  return DataRow(
                                    color: data.isDeactivated
                                        ? MaterialStateProperty.all(
                                            AppColors.lightRedColor)
                                        : null,
                                    cells: [
                                      DataCell(
                                        Row(
                                          children: [
                                            InkWell(
                                                onTap: () async {
                                                  _viewModel.updateOrder(
                                                      widget.orderID, data.id!);
                                                  _viewModel.fetchData(
                                                      widget.serviceID,
                                                      widget.orderID);
                                                },
                                                child:
                                                    const Text("Assign Order")),
                                          ],
                                        ),
                                      ),
                                      DataCell(Text(data.id.toString())),
                                      DataCell(
                                          Text(data.createdAt!.formatToDate())),
                                      DataCell(Text(data.name.toString())),
                                      DataCell(
                                          Text(data.phoneNumber.toString())),
                                      DataCell(Text(data.email.toString())),
                                      // DataCell(Row(
                                      //   children: [
                                      //     TextButton(
                                      //         child: const Text("Edit"),
                                      //         onPressed: () {
                                      //           showDialog(
                                      //             context: context,
                                      //             barrierDismissible: false,
                                      //             builder: (_) => Dialog(
                                      //               insetPadding:
                                      //                   const EdgeInsets.all(
                                      //                       24),
                                      //               child: AddVendorDialog(
                                      //                   vendorUser: data),
                                      //             ),
                                      //           );
                                      //         }),
                                      //     TextButton(
                                      //         child: const Text("View"),
                                      //         onPressed: () {
                                      //           if (data.id != null) {
                                      //             Routemaster.of(context).push(
                                      //                 ProfilePage.routeName,
                                      //                 queryParameters: {
                                      //                   "userID": data.id!
                                      //                 });
                                      //           }
                                      //         }),
                                      //   ],
                                      // )),
                                    ],
                                  );
                                },
                              ).toList()),
                        ),
                      ),
                    ),
                  );
                }),
    );
  }

  Widget _dataTableForAssignedVendors() {
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
                          child: DataTable(
                              clipBehavior: Clip.antiAlias,
                              border: TableBorder.symmetric(
                                  outside:
                                      BorderSide(color: AppColors.greyColor)),
                              sortAscending: !_viewModel.sortAscending,
                              sortColumnIndex: _viewModel.sortIndex,
                              dataRowColor: MaterialStateProperty.all(
                                  AppColors.lightGreyColor),
                              headingRowColor: MaterialStateProperty.all(
                                  AppColors.whiteColor),
                              dataTextStyle: FontStyles.font14Semibold
                                  .copyWith(color: AppColors.blueColor),
                              headingTextStyle: FontStyles.font16Semibold
                                  .copyWith(color: AppColors.blackColor),
                              columns: [
                                DataColumn(
                                  label: const Text(""),
                                  onSort: _viewModel.sortVendors,
                                ),
                                DataColumn(
                                  label: const Text("Vendor ID"),
                                  onSort: _viewModel.sortVendors,
                                ),
                                DataColumn(
                                  numeric: true,
                                  label: const Text("Date"),
                                  onSort: _viewModel.sortVendors,
                                ),
                                DataColumn(
                                  label: const Text("Username"),
                                  onSort: _viewModel.sortVendors,
                                ),
                                DataColumn(
                                  numeric: true,
                                  label: const Text("Contact"),
                                  onSort: _viewModel.sortVendors,
                                ),
                                DataColumn(
                                  label: const Text("Email"),
                                  onSort: _viewModel.sortVendors,
                                ),
                                // const DataColumn(label: Text("Action")),
                              ],
                              rows: _viewModel.getAssignedVendors.map(
                                (data) {
                                  return DataRow(
                                    color: data.isDeactivated
                                        ? MaterialStateProperty.all(
                                            AppColors.lightRedColor)
                                        : null,
                                    cells: [
                                      DataCell(
                                        Row(
                                          children: [
                                            InkWell(
                                                onTap: () async {
                                                  _viewModel.updateOrder(
                                                      widget.orderID,
                                                      null.toString());
                                                  _viewModel.fetchData(
                                                      widget.serviceID,
                                                      widget.orderID);
                                                },
                                                child: const Text(
                                                    "Remove Assigned Order")),
                                          ],
                                        ),
                                      ),
                                      DataCell(Text(data.id.toString())),
                                      DataCell(
                                          Text(data.createdAt!.formatToDate())),
                                      DataCell(Text(data.name.toString())),
                                      DataCell(
                                          Text(data.phoneNumber.toString())),
                                      DataCell(Text(data.email.toString())),
                                      // DataCell(Row(
                                      //   children: [
                                      //     TextButton(
                                      //         child: const Text("Edit"),
                                      //         onPressed: () {
                                      //           showDialog(
                                      //             context: context,
                                      //             barrierDismissible: false,
                                      //             builder: (_) => Dialog(
                                      //               insetPadding:
                                      //                   const EdgeInsets.all(
                                      //                       24),
                                      //               child: AddVendorDialog(
                                      //                   vendorUser: data),
                                      //             ),
                                      //           );
                                      //         }),
                                      //     TextButton(
                                      //         child: const Text("View"),
                                      //         onPressed: () {
                                      //           if (data.id != null) {
                                      //             Routemaster.of(context).push(
                                      //                 ProfilePage.routeName,
                                      //                 queryParameters: {
                                      //                   "userID": data.id!
                                      //                 });
                                      //           }
                                      //         }),
                                      //   ],
                                      // )),
                                    ],
                                  );
                                },
                              ).toList()),
                        ),
                      ),
                    ),
                  );
                }),
    );
  }

  Widget _heading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Vendor", style: FontStyles.font24Semibold),
            Text("Your list of vendor is here",
                style: FontStyles.font14Semibold),
          ],
        ),
        // CTAButton(
        //     title: "Add Vendor",
        //     onTap: () {
        //       showDialog(
        //         context: context,
        //         barrierDismissible: false,
        //         builder: (_) => const Dialog(
        //           insetPadding: EdgeInsets.all(24),
        //           child: AddVendorDialog(),
        //         ),
        //       );
        //     }),
      ],
    );
  }

  Widget _headingAssignedVendor() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Assigned Vendor", style: FontStyles.font24Semibold),
            Text("Your list of Assigned vendor is here",
                style: FontStyles.font14Semibold),
          ],
        ),
        // CTAButton(
        //     title: "Add Vendor",
        //     onTap: () {
        //       showDialog(
        //         context: context,
        //         barrierDismissible: false,
        //         builder: (_) => const Dialog(
        //           insetPadding: EdgeInsets.all(24),
        //           child: AddVendorDialog(),
        //         ),
        //       );
        //     }),
      ],
    );
  }

  Widget _button() {
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              "Back",
              style: TextStyle(color: AppColors.blueColor, fontSize: 20),
            )),
        const SizedBox(
          width: 10,
        ),
        CTAButton(
            color: AppColors.blueColor,
            title: "Share",
            onTap: () {
              final List<String> vendorIdss = [];
              final vendorIds =
                  _viewModel.getVendorIdsByService("n6T7diwwWtQ2qxy5t0vr");
              // Navigator.pop(context);
            }),
      ],
    );
  }
}

import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/presentation/pages/home/tabs/dashboard/dashboard_view_model.dart';
import 'package:admin/presentation/pages/home/tabs/widgets/stats_box.dart';
import 'package:admin/presentation/utils/web_scroll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:admin/core/extension/date.dart';
import '../../../../../core/enum/order_status.dart';
import '../../../orders_admin_page/order_page.dart';
import '../../../profile/profile_page.dart';

class DashboardTab extends ConsumerStatefulWidget {
  const DashboardTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardTabState();
}

class _DashboardTabState extends ConsumerState<DashboardTab> {
  late final DashboardViewModel _viewModel;
  @override
  void initState() {
    _viewModel = ref.read(DashboardViewModel.provider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(DashboardViewModel.provider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _heading(),
          _statsBoxes(),
          const SizedBox(height: 28),
          Expanded(child: _dataTable()),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _dataTable() {
    return Center(
        //   child: SizedBox(
        //     width: MediaQuery.of(context).size.width * 0.8,

        //     child: LayoutBuilder(builder: (context, constraints) {
        //       return ScrollConfiguration(
        //         behavior: WebScrollBehavior(),
        //         child: SingleChildScrollView(
        //           scrollDirection: Axis.vertical,
        //           child: SingleChildScrollView(
        //             scrollDirection: Axis.horizontal,
        //             child: ConstrainedBox(
        //               constraints: BoxConstraints(minWidth: constraints.minWidth),
        //               child: DataTable(
        //                   clipBehavior: Clip.antiAlias,
        //                   border: TableBorder.symmetric(
        //                       outside: BorderSide(color: AppColors.greyColor)),
        //                   sortAscending: true,
        //                   sortColumnIndex: 0,
        //                   dataRowColor:
        //                       MaterialStateProperty.all(AppColors.lightGreyColor),
        //                   headingRowColor:
        //                       MaterialStateProperty.all(AppColors.whiteColor),
        //                   dataTextStyle: FontStyles.font14Semibold
        //                       .copyWith(color: AppColors.blueColor),
        //                   headingTextStyle: FontStyles.font16Semibold
        //                       .copyWith(color: AppColors.blackColor),
        //                   columns: [
        //                     DataColumn(
        //                         label: const Text("Order ID"), onSort: (_, __) {}),
        //                     const DataColumn(label: Text("Date")),
        //                     const DataColumn(label: Text("Username")),
        //                     const DataColumn(label: Text("Status")),
        //                     const DataColumn(label: Text("Details")),
        //                   ],
        //                   rows: [
        //                     {
        //                       "id": "#123456",
        //                       "date": DateTime.now(),
        //                       "name": "Vipin Chandra",
        //                       "status": "Current"
        //                     },
        //                     {
        //                       "id": "#123456",
        //                       "date": DateTime.now(),
        //                       "name": "Vipin Chandra",
        //                       "status": "Ongoing"
        //                     },
        //                     {
        //                       "id": "#123456",
        //                       "date": DateTime.now(),
        //                       "name": "Vipin Chandra",
        //                       "status": "Completed"
        //                     },
        //                     {
        //                       "id": "#123456",
        //                       "date": DateTime.now(),
        //                       "name": "Vipin Chandra",
        //                       "status": "Completed"
        //                     },
        //                     {
        //                       "id": "#123456",
        //                       "date": DateTime.now(),
        //                       "name": "Vipin Chandra",
        //                       "status": "Completed"
        //                     },
        //                     {
        //                       "id": "#123456",
        //                       "date": DateTime.now(),
        //                       "name": "Vipin Chandra",
        //                       "status": "Completed"
        //                     },
        //                     {
        //                       "id": "#123456",
        //                       "date": DateTime.now(),
        //                       "name": "Vipin Chandra",
        //                       "status": "Current"
        //                     },
        //                     {
        //                       "id": "#123456",
        //                       "date": DateTime.now(),
        //                       "name": "Vipin Chandra",
        //                       "status": "Current"
        //                     },
        //                     {
        //                       "id": "#123456",
        //                       "date": DateTime.now(),
        //                       "name": "Vipin Chandra",
        //                       "status": "Current"
        //                     },
        //                   ].map(
        //                     (data) {
        //                       Color statusColor = AppColors.blueColor;
        //                       switch (data['status'].toString()) {
        //                         case "Completed":
        //                           statusColor = AppColors.greenColor;
        //                           break;
        //                         case "Ongoing":
        //                           statusColor = AppColors.orangeColor;
        //                           break;
        //                       }
        //                       return DataRow(
        //                         cells: [
        //                           DataCell(Text(data['id'].toString())),
        //                           DataCell(Text(data['date'].toString())),
        //                           DataCell(Text(data['name'].toString())),
        //                           DataCell(Text(data['status'].toString(),
        //                               style: TextStyle(color: statusColor))),
        //                           DataCell(TextButton(
        //                               child: const Text("View"), onPressed: () {})),
        //                         ],
        //                       );
        //                     },
        //                   ).toList()),
        //             ),
        //           ),
        //         ),
        //       );
        //     }),

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
                                      label: const Text("Order ID"),
                                      onSort: (_, __) {}),
                                  const DataColumn(label: Text("Date")),
                                  const DataColumn(label: Text("Username")),
                                  const DataColumn(label: Text("Name")),
                                  const DataColumn(label: Text("Status")),
                                  const DataColumn(label: Text("Details")),
                                ],
                                rows: _viewModel.getOrders.map(
                                  (data) {
                                    Color statusColor = AppColors.blueColor;
                                    switch (data.status) {
                                      case OrderStatus.completed:
                                        statusColor = AppColors.greenColor;
                                        break;
                                      case OrderStatus.assignedToClient:
                                        statusColor = AppColors.orangeColor;
                                        break;
                                      case OrderStatus.created:
                                        statusColor =
                                            AppColors.lightOrangeColor;

                                        break;
                                      case OrderStatus.approved:
                                        statusColor = AppColors.lightGreenColor;

                                        break;
                                      case OrderStatus.rejected:
                                        statusColor = AppColors.redColor;

                                        break;
                                    }
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(data.id ?? "")),
                                        DataCell(Text(
                                            data.createdAt?.formatToDate() ??
                                                "-")),
                                        DataCell(Text(data.userID)),
                                        DataCell(
                                          Container(
                                            child: FutureBuilder<String?>(
                                              future:
                                                  getNameFromOtherCollection(
                                                      data.userID ?? ""),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String?>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator();
                                                } else if (snapshot.hasError) {
                                                  return const Text("Error");
                                                } else {
                                                  final String name =
                                                      snapshot.data ?? "-";
                                                  return Container(
                                                    child: Text(name),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),

                                        // DataCell(Text("name")),
                                        DataCell(Text(data.status.name,
                                            style:
                                                TextStyle(color: statusColor))),
                                        DataCell(TextButton(
                                            child: const Text("View"),
                                            onPressed: () {
                                              if (data.id != null) {
                                                Routemaster.of(context).push(
                                                    OrderPage.routeName,
                                                    queryParameters: {
                                                      "orderID": data.id!
                                                    });
                                              }
                                            })),
                                      ],
                                    );
                                  },
                                ).toList()),
                          ),
                        ),
                      ),
                    );
                  }));
  }

  Widget _heading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Order", style: FontStyles.font24Semibold),
        Text("Your list of order is here", style: FontStyles.font14Semibold),
      ],
    );
  }

  Widget _statsBoxes() {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StatsBox(
            darkColor: AppColors.darkBlueColor,
            lightColor: AppColors.lightBlueColor,
            regColor: AppColors.blueColor,
            title: "Total Orders",
            value: _viewModel.getOrders.length.toString(),
            selected: true,
            onTap: null,
          ),
          StatsBox(
            darkColor: AppColors.darkRedColor,
            lightColor: AppColors.lightRedColor,
            regColor: AppColors.redColor,
            title: "New Orders",
            value: _viewModel.getOrders
                .where((order) => order.status == OrderStatus.created)
                .length
                .toString(),
            selected: false,
            onTap: null,
          ),
          StatsBox(
            darkColor: AppColors.darkOrangeColor,
            lightColor: AppColors.lightOrangeColor,
            regColor: AppColors.orangeColor,
            title: "Ongoing",
            value: _viewModel.getOrders
                .where((order) => order.status == OrderStatus.assignedToClient)
                .length
                .toString(),
            selected: false,
            onTap: null,
          ),
          StatsBox(
            darkColor: AppColors.darkGreenColor,
            lightColor: AppColors.lightGreenColor,
            regColor: AppColors.greenColor,
            title: "Completed",
            value: _viewModel.getOrders
                .where((order) => order.status == OrderStatus.completed)
                .length
                .toString(),
            selected: false,
            onTap: null,
          ),
        ],
      ),
    );
  }

  Future<String?> getNameFromOtherCollection(String id) async {
    final collection = FirebaseFirestore.instance.collection('user');
    final docSnapshot = await collection.doc(id).get();
    final data = docSnapshot.data();
    print(id);
    if (data != null) {
      return data['name'];
      // print(object)
    } else {
      return null;
    }
  }
}

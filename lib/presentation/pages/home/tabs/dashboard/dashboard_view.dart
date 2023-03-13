import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/presentation/pages/home/tabs/widgets/stats_box.dart';
import 'package:admin/presentation/utils/web_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardTab extends ConsumerStatefulWidget {
  const DashboardTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardTabState();
}

class _DashboardTabState extends ConsumerState<DashboardTab> {
  @override
  Widget build(BuildContext context) {
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
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: LayoutBuilder(builder: (context, constraints) {
          return ScrollConfiguration(
            behavior: WebScrollBehavior(),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.minWidth),
                  child: DataTable(
                      clipBehavior: Clip.antiAlias,
                      border: TableBorder.all(
                          borderRadius: BorderRadius.circular(30),
                          color: AppColors.greyColor),
                      sortAscending: true,
                      sortColumnIndex: 0,
                      dataRowColor:
                          MaterialStateProperty.all(AppColors.lightGreyColor),
                      headingRowColor:
                          MaterialStateProperty.all(AppColors.whiteColor),
                      dataTextStyle: FontStyles.font14Semibold
                          .copyWith(color: AppColors.blueColor),
                      headingTextStyle: FontStyles.font16Semibold
                          .copyWith(color: AppColors.blackColor),
                      columns: [
                        DataColumn(
                            label: const Text("Order ID"), onSort: (_, __) {}),
                        const DataColumn(label: Text("Date")),
                        const DataColumn(label: Text("Username")),
                        const DataColumn(label: Text("Status")),
                        const DataColumn(label: Text("Details")),
                      ],
                      rows: [
                        {
                          "id": "#123456",
                          "date": DateTime.now(),
                          "name": "Vipin Chandra",
                          "status": "Current"
                        },
                        {
                          "id": "#123456",
                          "date": DateTime.now(),
                          "name": "Vipin Chandra",
                          "status": "Ongoing"
                        },
                        {
                          "id": "#123456",
                          "date": DateTime.now(),
                          "name": "Vipin Chandra",
                          "status": "Completed"
                        },
                        {
                          "id": "#123456",
                          "date": DateTime.now(),
                          "name": "Vipin Chandra",
                          "status": "Completed"
                        },
                        {
                          "id": "#123456",
                          "date": DateTime.now(),
                          "name": "Vipin Chandra",
                          "status": "Completed"
                        },
                        {
                          "id": "#123456",
                          "date": DateTime.now(),
                          "name": "Vipin Chandra",
                          "status": "Completed"
                        },
                        {
                          "id": "#123456",
                          "date": DateTime.now(),
                          "name": "Vipin Chandra",
                          "status": "Current"
                        },
                        {
                          "id": "#123456",
                          "date": DateTime.now(),
                          "name": "Vipin Chandra",
                          "status": "Current"
                        },
                        {
                          "id": "#123456",
                          "date": DateTime.now(),
                          "name": "Vipin Chandra",
                          "status": "Current"
                        },
                      ].map(
                        (data) {
                          Color statusColor = AppColors.blueColor;
                          switch (data['status'].toString()) {
                            case "Completed":
                              statusColor = AppColors.greenColor;
                              break;
                            case "Ongoing":
                              statusColor = AppColors.orangeColor;
                              break;
                          }
                          return DataRow(
                            cells: [
                              DataCell(Text(data['id'].toString())),
                              DataCell(Text(data['date'].toString())),
                              DataCell(Text(data['name'].toString())),
                              DataCell(Text(data['status'].toString(),
                                  style: TextStyle(color: statusColor))),
                              DataCell(TextButton(
                                  child: const Text("View"), onPressed: () {})),
                            ],
                          );
                        },
                      ).toList()),
                ),
              ),
            ),
          );
        }),
      ),
    );
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
            value: "200",
            selected: true,
            onTap: () {
              // TODO
            },
          ),
          StatsBox(
            darkColor: AppColors.darkRedColor,
            lightColor: AppColors.lightRedColor,
            regColor: AppColors.redColor,
            title: "New Orders",
            value: "50",
            selected: false,
            onTap: () {
              // TODO
            },
          ),
          StatsBox(
            darkColor: AppColors.darkOrangeColor,
            lightColor: AppColors.lightOrangeColor,
            regColor: AppColors.orangeColor,
            title: "Ongoing",
            value: "80",
            selected: false,
            onTap: () {
              // TODO
            },
          ),
          StatsBox(
            darkColor: AppColors.darkGreenColor,
            lightColor: AppColors.lightGreenColor,
            regColor: AppColors.greenColor,
            title: "Completed",
            value: "70",
            selected: false,
            onTap: () {
              // TODO
            },
          ),
        ],
      ),
    );
  }
}

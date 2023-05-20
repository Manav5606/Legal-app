import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/enum/order_status.dart';
import 'package:admin/core/extension/date.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/my_orders/my_orders_view_model.dart';
import 'package:admin/presentation/pages/order_detail_client/order_detail_page.dart';
import 'package:admin/presentation/pages/widgets/contact_us.dart';
import 'package:admin/presentation/pages/widgets/contact_us_card.dart';
import 'package:admin/presentation/pages/widgets/footer.dart';
import 'package:admin/presentation/pages/widgets/header.dart';
import 'package:admin/presentation/utils/web_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:routemaster/routemaster.dart';

import '../widgets/freeze_header.dart';

class MyOrdersPage extends ConsumerStatefulWidget {
  static const String routeName = "/myOrders";
  const MyOrdersPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends ConsumerState<MyOrdersPage> {
  late final MyOrdersPageViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ref.read(MyOrdersPageViewModel.provider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchContacts();
    });
    super.initState();
  }

  late bool isAuthenticated;

  // TODO make it dynamic
  final _contactDetails = [
    Category(
      id: "b",
      name: "Phone",
      iconUrl: "",
      description: "Lorem Ipsum",
      addedAt: DateTime.now().millisecondsSinceEpoch,
      addedBy: "",
    ),
    Category(
      id: "f",
      name: "Office",
      iconUrl: "",
      description: "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum",
      addedAt: DateTime.now().millisecondsSinceEpoch,
      addedBy: "",
    ),
    Category(
      id: "l",
      name: "Working hours",
      iconUrl: "",
      description: "Lorem Ipsum",
      addedAt: DateTime.now().millisecondsSinceEpoch,
      addedBy: "",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: ScreenTypeLayout.builder(
        mobile: (context) => CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: CustomSliverPersistentHeaderDelegate(mobile: true),
              floating: false,
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  MyOrdersList(),
                  ContactUs(height: 250, mobile: true),
                  Footer(),
                ],
              ),
            ),
          ],
        ),
        desktop: (context) => CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: CustomSliverPersistentHeaderDelegate(mobile: false),
              floating: false,
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const MyOrdersList(),
                  const ContactUs(height: 250),
                  ContactUsCard(
                      contactDetails: _viewModel.getContacts, height: 300),
                  const Footer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyOrdersList extends ConsumerStatefulWidget {
  const MyOrdersList({super.key});

  @override
  ConsumerState<MyOrdersList> createState() => _MyOrdersListState();
}

class _MyOrdersListState extends ConsumerState<MyOrdersList> {
  late final MyOrdersPageViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ref.read(MyOrdersPageViewModel.provider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.initMyOrders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(MyOrdersPageViewModel.provider);
    return _viewModel.isLoading
        ? const Center(child: CircularProgressIndicator.adaptive())
        : LayoutBuilder(builder: (context, constraints) {
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
                        border: TableBorder.symmetric(
                            outside: BorderSide(color: AppColors.greyColor)),
                        // sortAscending: !_viewModel.sortAscending,
                        // sortColumnIndex: _viewModel.sortIndex,
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
                              label: const Text("Order ID"),
                              onSort: (_, __) {}),
                          const DataColumn(label: Text("Date")),
                          const DataColumn(label: Text("Username")),
                          // const DataColumn(label: Text("Name")),
                          const DataColumn(label: Text("Status")),
                          const DataColumn(label: Text("Details")),
                        ],
                        rows: _viewModel.getMyOrders.map(
                          (data) {
                            Color statusColor = AppColors.blueColor;
                            switch (data.status ?? OrderStatus.created) {
                              case OrderStatus.completed:
                                statusColor = AppColors.greenColor;
                                break;
                              case OrderStatus.assignedToClient:
                                statusColor = AppColors.orangeColor;
                                break;
                              case OrderStatus.created:
                                statusColor = AppColors.lightOrangeColor;

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
                                    data.createdAt?.formatToDate() ?? "-")),
                                DataCell(Text(data.clientID!)),
                                // DataCell(
                                //   Container(
                                //     child: FutureBuilder<String?>(
                                //       future: getNameFromOtherCollection(
                                //           data.clientID ?? ""),
                                //       builder: (BuildContext context,
                                //           AsyncSnapshot<String?> snapshot) {
                                //         if (snapshot.connectionState ==
                                //             ConnectionState.waiting) {
                                //           return const CircularProgressIndicator();
                                //         } else if (snapshot.hasError) {
                                //           return const Text("Error");
                                //         } else {
                                //           final String name =
                                //               snapshot.data ?? "-";
                                //           return Container(
                                //             child: Text(name),
                                //           );
                                //         }
                                //       },
                                //     ),
                                //   ),
                                // ),

                                // DataCell(Text("name")),
                                DataCell(Text(data.status!.name,
                                    style: TextStyle(color: statusColor))),
                                DataCell(TextButton(
                                    child: const Text("View"),
                                    onPressed: () {
                                      if (data.id != null) {
                                        Routemaster.of(context).push(
                                            OrderDetailPage.routeName,
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
          });
  }
}

import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/enum/order_status.dart';
import 'package:admin/presentation/pages/assign_order_dialog/vendor_admin/assign_order_view_model.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:admin/presentation/pages/widgets/custom_textfield.dart';
import 'package:admin/presentation/pages/widgets/footer.dart';
import 'package:admin/presentation/pages/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../assign_order_dialog/vendor_admin/assign_order_page.dart';
import 'order_page_model.dart';

class OrderPage extends ConsumerStatefulWidget {
  static const String routeName = "/order_page";
  const OrderPage({super.key, required this.orderID});
  final String orderID;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> {
  late final OrderPageModel _viewModel;
  late final AssignOrderToVendorViewModel _assignOrderModel;
  @override
  void initState() {
    _viewModel = ref.read(OrderPageModel.provider);
    _assignOrderModel = ref.read(AssignOrderToVendorViewModel.provider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchUser(widget.orderID);
      _viewModel.clearSelectedServices();
    });
    super.initState();
  }

  List<CheckboxListTile> checkboxListTiles = [];
  String? docRefId;
  Color myColor = Color(0xffFAFBFF);
  @override
  Widget build(BuildContext context) {
    ref.watch(OrderPageModel.provider);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            const Header(mobile: false),
            Form(
              key: _viewModel.formKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: Text("Order Details",
                          style: FontStyles.font24Semibold.copyWith(
                              fontSize: 48, color: AppColors.blueColor)),
                      subtitle: Text("Your order details are updated here",
                          style: FontStyles.font12Medium
                              .copyWith(color: AppColors.blueColor)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            height: 300,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      // CircleAvatar(
                                      //   radius: 150,
                                      //   child: _viewModel.profileLoading
                                      //       ? const CircularProgressIndicator
                                      //           .adaptive()
                                      //       : CachedNetworkImage(
                                      //           imageUrl: _viewModel
                                      //                   .getUser?.profilePic ??
                                      //               ""),
                                      // ),
                                      const SizedBox(height: 4),
                                      // TextButton(
                                      //     onPressed: _viewModel.profileLoading
                                      //         ? null
                                      //         : () async {
                                      //             final file = await _viewModel
                                      //                 .pickFile(await FilePicker
                                      //                     .platform
                                      //                     .pickFiles());
                                      //             if (file != null) {
                                      //               await _viewModel
                                      //                   .uploadProfilePic(
                                      //                       file: file);
                                      //             }
                                      //           },
                                      //     child: _viewModel.profileLoading
                                      //         ? const CircularProgressIndicator
                                      //             .adaptive()
                                      //         : const Text("Edit")),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height,
                                    child:
                                        ListView(shrinkWrap: true, children: [
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     const Text("Name"),
                                      //     CustomTextField(
                                      //       hintText: "Your Name",
                                      //       controller:
                                      //           _viewModel.nameController,
                                      //     ),
                                      //   ],
                                      // ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     const Text("Email"),
                                      //     CustomTextField(
                                      //       disable: true,
                                      //       errorText: _viewModel.emailError,
                                      //       hintText: "Your Email",
                                      //       controller:
                                      //           _viewModel.emailController,
                                      //     ),
                                      //   ],
                                      // ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Email"),
                                          CustomTextField(
                                            errorText: _viewModel.phoneError,
                                            hintText: "Your email",
                                            controller:
                                                _viewModel.emailController,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Name"),
                                          CustomTextField(
                                            hintText: "Name",
                                            controller:
                                                _viewModel.userNameController,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Mobile Number"),
                                          CustomTextField(
                                            hintText: "Mobile Number",
                                            controller: _viewModel
                                                .mobileNumberController,
                                          ),
                                        ],
                                      ),

                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     const Text("Start Working Hour"),
                                      //     InkWell(
                                      //       onTap: () async {
                                      //         TimeOfDay? pickedTime =
                                      //             await showTimePicker(
                                      //           initialTime: TimeOfDay.now(),
                                      //           context: context,
                                      //         );
                                      //         if (pickedTime != null) {
                                      //           _viewModel
                                      //               .setStartingHour(pickedTime);
                                      //         }
                                      //       },
                                      //       child: CustomTextField(
                                      //         disable: true,
                                      //         hintText: "Your Starting Work Time",
                                      //         controller: _viewModel
                                      //             .startingWorkHourController,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ]),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                                color: myColor,
                                borderRadius: BorderRadius.circular(25)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    alignment: Alignment.topLeft,
                                    // width:
                                    //     MediaQuery.of(context).size.width * 0.8,
                                    color: myColor,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Notes:",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.blue),
                                      ),
                                    )),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: CustomTextField(
                                    maxLines: 10,
                                    hintText: "Type here...",
                                    controller: _viewModel.notesController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      child: const Text(
                                        "Assign to Vendor",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 0, 71, 130)),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (_) => Dialog(
                                            insetPadding:
                                                const EdgeInsets.all(24),
                                            child: AssignOrderToVendor(
                                                widget.orderID),
                                          ),
                                        );
                                      }),
                                  const SizedBox(width: 8),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      child: const Text(
                                        "Reject",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () async {
                                        await _assignOrderModel
                                            .updateOrderStatus(
                                              widget.orderID,
                                              OrderStatus.rejected,
                                            )
                                            .then((value) =>
                                                Routemaster.of(context).pop());
                                      }),
                                  const SizedBox(width: 8),
                                  CTAButton(
                                    title: "Accept",
                                    onTap: () async {
                                      await _assignOrderModel
                                          .updateOrderStatus(
                                            widget.orderID,
                                            OrderStatus.approved,
                                          )
                                          .then((value) =>
                                              Routemaster.of(context).pop());
                                    },
                                    color: AppColors.darkGreenColor,
                                    fullWidth: false,
                                    radius: 4,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

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

class SuccessfullOrder extends ConsumerStatefulWidget {
  static const String routeName = "/assign_order";

  const SuccessfullOrder({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SuccessfullOrderState();
}

class _SuccessfullOrderState extends ConsumerState<SuccessfullOrder> {
  // List<User> us = [];
  // Future<void> fetchData() async {
  //   List<String> vendorIds =
  //       await _viewModel.getVendorIdsByService(widget.serviceID);
  //   _viewModel.fetch(vendorIds);

  // }

  @override
  void initState() {
    super.initState();
  }

  int? _selectedRadio;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.3,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          orderSuccess(),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget orderSuccess() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/order.png',
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        SizedBox(height: 10),
        Text('Order successfully placed!', style: FontStyles.font14Semibold),
      ],
    );
  }
}

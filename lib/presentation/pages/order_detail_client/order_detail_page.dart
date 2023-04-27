import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/enum/field_type.dart';
import 'package:admin/core/enum/order_status.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/order_detail_client/order_detail_view_model.dart';
import 'package:admin/presentation/pages/widgets/contact_us.dart';
import 'package:admin/presentation/pages/widgets/footer.dart';
import 'package:admin/presentation/pages/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';

class OrderDetailPage extends ConsumerStatefulWidget {
  static const String routeName = "/order_detail_page";
  const OrderDetailPage({super.key, required this.orderID});
  final String orderID;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrderDetailPageState();
}

class _OrderDetailPageState extends ConsumerState<OrderDetailPage> {
  late final OrderDetailViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ref.read(OrderDetailViewModel.provider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.initOrderDetails(orderId: widget.orderID);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: _viewModel.isLoading || _viewModel.order == null
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ScreenTypeLayout.builder(
              mobile: (context) => ListView(
                children: [
                  const Header(mobile: true),
                  _orderDetails(mobile: true),
                  const ContactUs(height: 250, mobile: true),
                  const Footer(),
                ],
              ),
              desktop: (context) => ListView(
                children: [
                  const Header(mobile: false),
                  _orderDetails(),
                  const ContactUs(height: 250),
                  const Footer(),
                ],
              ),
            ),
    );
  }

  Widget _orderDetails({bool mobile = false}) {
    Color statusColor = AppColors.blueColor;
    switch (_viewModel.order?.status ?? OrderStatus.created) {
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
    return ListView(
      children: [
        ListTile(
            title: Text(_viewModel.service.shortDescription),
            subtitle: Text(_viewModel.service.ourPrice.toString()),
            trailing: Text(_viewModel.order!.status!.name,
                style: TextStyle(color: statusColor))),
        ...(_viewModel.order?.orderServiceRequest ?? [])
            .map((e) => renderInputWidget(e))
            .toList()
      ],
    );
  }

  Widget renderInputWidget(ServiceRequest serviceRequest) {
    switch (serviceRequest.fieldType) {
      case ServiceFieldType.text:
        return TextFormField(
          decoration: InputDecoration(
            labelText: serviceRequest.fieldName,
          ),
          onChanged: (value) {},
        );
      case ServiceFieldType.number:
        return TextFormField(
          decoration: InputDecoration(
            labelText: serviceRequest.fieldName,
          ),
          onChanged: (value) {},
        );
      case ServiceFieldType.date:
        return const SizedBox.shrink();

        break;
      case ServiceFieldType.file:
        return const SizedBox.shrink();

        break;
      case ServiceFieldType.image:
        return const SizedBox.shrink();
        break;
      default:
        return const SizedBox.shrink();
    }
  }
}

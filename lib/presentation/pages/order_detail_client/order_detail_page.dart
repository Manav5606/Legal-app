import 'dart:developer';
import 'package:admin/core/extension/date.dart';
import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/enum/field_type.dart';
import 'package:admin/core/enum/order_status.dart';
import 'package:admin/core/state/auth_state.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/pages/order_detail_client/order_detail_view_model.dart';
import 'package:admin/presentation/pages/widgets/contact_us.dart';
import 'package:admin/presentation/pages/widgets/footer.dart';
import 'package:admin/presentation/pages/widgets/header.dart';
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey();

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
    ref.watch(OrderDetailViewModel.provider);
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
    final list = _viewModel.order?.orderServiceRequest ?? [];
    list.sort((a, b) => a.fieldName.compareTo(b.fieldName));
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      children: [
        ListTile(
            title: Text(_viewModel.service?.shortDescription ?? ""),
            subtitle: Text(_viewModel.service?.ourPrice.toString() ?? ""),
            trailing: Text(_viewModel.order!.status!.name,
                style: TextStyle(color: statusColor))),
        Visibility(
            visible: _viewModel.vendor != null,
            child: ListTile(
                title: Text("Assigned to ${_viewModel.vendor?.companyName}"),
                subtitle: InkWell(
                    child: Text("Contact: ${_viewModel.vendor?.mobile}"),
                    onTap: () {
                      launchUrlString("tel:${_viewModel.vendor?.mobile}");
                    }))),
        Form(
            key: _formKey,
            child: ListView(
                shrinkWrap: true,
                children: list.map((e) => renderInputWidget(e)).toList())),
        OutlinedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                _formKey.currentState?.save();
              }
            },
            child: const Text("Save")),
      ],
    );
  }

  Widget renderInputWidget(ServiceRequest serviceRequest) {
    switch (serviceRequest.fieldType) {
      case ServiceFieldType.text:
        return OrderFormField(serviceRequest: serviceRequest);
      case ServiceFieldType.number:
        return OrderFormField(serviceRequest: serviceRequest);
      case ServiceFieldType.date:
        return OrderDateField(serviceRequest: serviceRequest);
      case ServiceFieldType.file:
        return OrderFileField(serviceRequest: serviceRequest);
      case ServiceFieldType.image:
        return OrderFileField(serviceRequest: serviceRequest);
      default:
        return const SizedBox.shrink();
    }
  }
}

class OrderFileField extends ConsumerStatefulWidget {
  final ServiceRequest serviceRequest;
  const OrderFileField({super.key, required this.serviceRequest});

  @override
  ConsumerState<OrderFileField> createState() => _OrderFileFieldState();
}

class _OrderFileFieldState extends ConsumerState<OrderFileField> {
  String? fileUrl;

  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    // ignore: prefer_conditional_assignment
    if (fileUrl == null) {
      fileUrl = widget.serviceRequest.value;
      controller.text = widget.serviceRequest.value ?? "";
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.serviceRequest.fieldName),
        Row(
          children: [
            uploading
                ? const CircularProgressIndicator.adaptive()
                : OutlinedButton(
                    onPressed: fileUrl == null
                        ? () async {
                            final file = await pickFile(
                                await FilePicker.platform.pickFiles(
                              type: widget.serviceRequest.fieldType ==
                                      ServiceFieldType.image
                                  ? FileType.image
                                  : FileType.any,
                            ));
                            if (file == null) {
                              Messenger.showSnackbar("Please pick a file");
                              return;
                            }
                            fileUrl = await uploadFile(file: file);
                            if (fileUrl != null) {
                              final service = widget.serviceRequest
                                  .copyWith(value: fileUrl);
                              log(service.toOrderJson().toString());
                              await ref
                                  .read(OrderDetailViewModel.provider)
                                  .saveServiceRequestData(
                                      service: service,
                                      oldService: widget.serviceRequest);
                              Messenger.showSnackbar(
                                  "${widget.serviceRequest.fieldName} Uploaded.");
                            }
                            setState(() {});
                          }
                        : () {
                            launchUrlString(fileUrl ?? "");
                          },
                    child: Text(fileUrl == null ? "Upload" : "View"),
                  ),
            Visibility(
                visible: fileUrl != null, child: const SizedBox(width: 8)),
            Visibility(
              visible: fileUrl != null && !uploading,
              child: OutlinedButton(
                onPressed: () async {
                  final file =
                      await pickFile(await FilePicker.platform.pickFiles(
                    type: widget.serviceRequest.fieldType ==
                            ServiceFieldType.image
                        ? FileType.image
                        : FileType.any,
                  ));
                  if (file == null) {
                    Messenger.showSnackbar("Please pick a file to replace.");
                    return;
                  }
                  fileUrl = await uploadFile(file: file);
                  if (fileUrl != null) {
                    final service =
                        widget.serviceRequest.copyWith(value: fileUrl);
                    log(service.toOrderJson().toString());
                    await ref
                        .read(OrderDetailViewModel.provider)
                        .saveServiceRequestData(
                            service: service,
                            oldService: widget.serviceRequest);
                    Messenger.showSnackbar(
                        "${widget.serviceRequest.fieldName} Uploaded.");
                  }
                  setState(() {});
                },
                child: const Text("Replace"),
              ),
            )
          ],
        ),
      ],
    );
  }

  Future<XFile?> pickFile(FilePickerResult? result) async {
    if (result != null) {
      final choosenFile = result.files.first;
      return kIsWeb
          ? XFile.fromData(choosenFile.bytes!, name: choosenFile.name)
          : XFile(choosenFile.path ?? "", name: choosenFile.name);
    }
    return null;
  }

  Future<String?> uploadFile({required XFile file}) async {
    setState(() {
      uploading = true;
    });
    try {
      final downloadUrl =
          await ref.read(DatabaseRepositoryImpl.provider).uploadToFirestore(
                file: file,
                userID: ref.read(AuthService.provider).user?.id ?? "",
              );
      return downloadUrl;
    } catch (_) {
      return null;
    } finally {
      setState(() {
        uploading = false;
      });
    }
  }
}

class OrderDateField extends ConsumerStatefulWidget {
  final ServiceRequest serviceRequest;
  const OrderDateField({super.key, required this.serviceRequest});

  @override
  ConsumerState<OrderDateField> createState() => _OrderDateFieldState();
}

class _OrderDateFieldState extends ConsumerState<OrderDateField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
        text: int.tryParse(widget.serviceRequest.value ?? "")?.formatToDate());
    super.initState();
  }

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_conditional_assignment
    if (selectedDate == null) {
      selectedDate = int.tryParse(widget.serviceRequest.value ?? "") == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(
              int.parse(widget.serviceRequest.value!));
    }
    _controller.text = selectedDate!.millisecondsSinceEpoch.formatToDate();
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate!,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );

        if (date != null) {
          setState(() {
            selectedDate = date;
          });
        }
      },
      child: AbsorbPointer(
        absorbing: true,
        child: TextFormField(
          controller: _controller,
          decoration:
              InputDecoration(labelText: widget.serviceRequest.fieldName),
          onSaved: (_) {
            final service = widget.serviceRequest.copyWith(
                value: selectedDate!.millisecondsSinceEpoch.toString());
            log(service.toOrderJson().toString());
            ref.read(OrderDetailViewModel.provider).saveServiceRequestData(
                service: service, oldService: widget.serviceRequest);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
      ),
    );
  }
}

class OrderFormField extends ConsumerStatefulWidget {
  final ServiceRequest serviceRequest;
  const OrderFormField({super.key, required this.serviceRequest});

  @override
  ConsumerState<OrderFormField> createState() => _OrderFormFieldState();
}

class _OrderFormFieldState extends ConsumerState<OrderFormField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.serviceRequest.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.serviceRequest.value ?? _controller.text;
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(labelText: widget.serviceRequest.fieldName),
      onSaved: (value) {
        final service = widget.serviceRequest.copyWith(value: value);
        log(service.toOrderJson().toString());
        ref.read(OrderDetailViewModel.provider).saveServiceRequestData(
            service: service, oldService: widget.serviceRequest);
      },
      validator: (value) {
        if (widget.serviceRequest.fieldType == ServiceFieldType.number) {
          if (value == null || value.isEmpty || num.tryParse(value) == null) {
            return "Please enter a valid number";
          }
        } else {
          if (value == null || value.isEmpty) {
            return "This field is required";
          }
        }
        return null;
      },
    );
  }
}

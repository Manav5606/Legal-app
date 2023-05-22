import 'package:admin/core/enum/role.dart';
import 'package:admin/presentation/pages/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constant/colors.dart';
import '../../../../../core/constant/firebase_config.dart';
import '../../../../../core/constant/fontstyles.dart';
import '../../../../../core/provider.dart';
import '../../../../../data/models/user.dart';
import '../../../widgets/chat_custom_textformfield.dart';
import 'chat_view_mode.dart';

class ChatView extends ConsumerStatefulWidget {
  static const String routeName = "/chat_view";
  const ChatView(this.orderId, this.userId, this.vendorId, this.clientName,
      this.vendorName, this.adminId, this.serviceName,
      {super.key});
  final String orderId;
  final String userId;
  final String vendorId;
  final String clientName;
  final String vendorName;
  final String adminId;
  final String? serviceName;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatViewState();
}

final TextEditingController notesController = TextEditingController();

class _ChatViewState extends ConsumerState<ChatView> {
  late User? user;
  late final ChatViewModel _viewModel;
  final ScrollController _controller = ScrollController();

  // String id = "aZdMLXed1UV5UOAzMADpnWhlYqk1";
  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(ChatViewModel.provider);
    user = ref.read(AppState.auth).user;
    _viewModel.updateReadBy(
      widget.orderId,
      user!.userType.name,
      user!.id!,
    );
  }

  late final ChatViewModel chat;

  @override
  Widget build(BuildContext context) {
    // final routeSettings = ModalRoute.of(context)!.settings;
    // if (routeSettings != null) {
    //   final args = routeSettings.arguments as Map<String, dynamic>;
    //   String orderId = args['orderId'] ?? "";
    //   if (orderId == null) {
    //     orderId = 'default_order_id';
    //   }
    //   // rest of the code
    // }

    ref.watch(AppState.auth).user;
    return Scaffold(
      body: Container(
          // height: 500,
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02,
                  left: MediaQuery.of(context).size.width * 0.01,
                  right: MediaQuery.of(context).size.width * 0.02),
              child: data(user!.userType.name),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.greyColor)),
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: ChatCustomTextField(
                    width: MediaQuery.of(context).size.width,
                    hintText: "Your Text is written here...",
                    controller: notesController,
                    backgroundColor: AppColors.lightBlueColor,
                    maxLines: null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    String notes = notesController.text.trim();
                    if (notes.isNotEmpty) {
                      _viewModel.addChatWithUserName(
                          widget.orderId.toString(),
                          notesController.text.toString(),
                          user!.userType.name,
                          widget.userId,
                          widget.vendorId,
                          widget.adminId);
                      notesController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      )),
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: IconButton(
          color: AppColors.blueColor,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Routemaster.of(context).pop(),
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.serviceName!,
                style: FontStyles.font24Semibold,
              ),
              Text(
                'Your chat list is here',
                style: FontStyles.font11Light,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget data(String user) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: _viewModel.getChatStream(widget.orderId.toString()),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final documents = snapshot.data!.docs;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _controller.animateTo(
              _controller.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
          return ListView.builder(
            controller: _controller,
            scrollDirection: Axis.vertical,
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              String senderId = data["user_id"] ?? "";
              bool isSentByUser = senderId == widget.userId;
              bool isSentByVendor = senderId == widget.vendorId;
              bool isSentByAdmin = senderId == widget.adminId;
              Timestamp timestamp = data["createdAt"];
              DateTime dateTime = timestamp.toDate();

              String formattedTime = DateFormat.jm().format(dateTime);
              if (isSentByUser) {
                return Column(
                  crossAxisAlignment: user == UserType.client.name
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Container(
                      // color: Colors.red,
                      child: Wrap(
                        alignment: user == UserType.client.name
                            ? WrapAlignment.start
                            : WrapAlignment.end,
                        crossAxisAlignment: user == UserType.client.name
                            ? WrapCrossAlignment.start
                            : WrapCrossAlignment.end,
                        children: [
                          SizedBox(width: 8.0),
                          IntrinsicWidth(
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.35,
                              ),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: AppColors.lightBlueColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.clientName,
                                    style: FontStyles.font10Light,
                                  ),
                                  Text(
                                    data["msg"] ?? "",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: SizedBox(
                                      width: 100.0,
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          formattedTime ?? "",
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }
              if (isSentByVendor) {
                return Column(
                  crossAxisAlignment: user == UserType.vendor.name
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Container(
                      // color: Colors.red,
                      child: Wrap(
                        alignment: user == UserType.vendor.name
                            ? WrapAlignment.start
                            : WrapAlignment.end,
                        crossAxisAlignment: user == UserType.vendor.name
                            ? WrapCrossAlignment.start
                            : WrapCrossAlignment.end,
                        children: [
                          SizedBox(width: 8.0),
                          IntrinsicWidth(
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.35,
                              ),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: AppColors.blueColor,
                                  width: 2.0,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.clientName}:Vendor",
                                    style: FontStyles.font10Light,
                                  ),
                                  Text(
                                    data["msg"] ?? "",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: SizedBox(
                                      width: 100.0,
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          formattedTime ?? "",
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }
              if (isSentByAdmin) {
                return Column(
                  crossAxisAlignment: user == UserType.admin.name
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Container(
                      // color: Colors.red,
                      child: Wrap(
                        alignment: user == UserType.admin.name
                            ? WrapAlignment.start
                            : WrapAlignment.end,
                        crossAxisAlignment: user == UserType.admin.name
                            ? WrapCrossAlignment.start
                            : WrapCrossAlignment.end,
                        children: [
                          SizedBox(width: 8.0),
                          IntrinsicWidth(
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.35,
                              ),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: AppColors.blueColor,
                                  width: 2.0,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Admin",
                                    style: FontStyles.font10Light,
                                  ),
                                  Text(
                                    data["msg"] ?? "",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: SizedBox(
                                      width: 100.0,
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          formattedTime ?? "",
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }

              return SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

// This is what you're looking for!
}

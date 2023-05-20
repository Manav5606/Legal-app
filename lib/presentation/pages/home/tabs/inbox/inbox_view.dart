import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/firebase_config.dart';
import 'package:admin/presentation/pages/home/tabs/inbox/inbox_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constant/fontstyles.dart';
import '../../../../../core/provider.dart';
import '../../../../../data/models/user.dart';
import 'chat_view.dart';

class InboxTab extends ConsumerStatefulWidget {
  const InboxTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InboxTabState();
}

class _InboxTabState extends ConsumerState<InboxTab> {
  late User? user;
  late final InboxViewModel _viewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewModel = ref.read(InboxViewModel.provider);
    user = ref.read(AppState.auth).user;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(AppState.auth).user;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 65),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Inbox",
                    style: FontStyles.font24Semibold
                        .copyWith(color: AppColors.blueColor)),
                Text("Your chat list is here",
                    style: FontStyles.font16Semibold
                        .copyWith(color: AppColors.blueColor)),
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 35, right: 35),
            child: _chatList(),
          )),
        ],
      ),
    );
  }

  CollectionReference _chatRef =
      FirebaseFirestore.instance.collection(FirebaseConfig.orderCollection);

  Widget _chatList() {
    return StreamBuilder<QuerySnapshot>(
      stream: user!.userType.name == "Client"
          ? _chatRef
              .where("client_id", isEqualTo: user!.id)
              // .orderBy("created_at", descending: true)
              .snapshots()
          : user!.userType.name == "Vendor"
              ? _chatRef
                  .where("vendor_id", isEqualTo: user!.id)
                  // .orderBy("created_at", descending: true)
                  .snapshots()
              : _chatRef.orderBy("created_at", descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        // Sort the documents based on the "created_at" field
        documents.sort((a, b) {
          int created_atA = a["created_at"];
          int created_atB = b["created_at"];
          return created_atB.compareTo(created_atA);
        });

        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            QueryDocumentSnapshot doc = documents[index];
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            String clientId = data["client_id"] ?? "";
            String vendorId = data["vendor_id"] ?? "";
            String serviceName = data["serviceName"] ?? "";
            String status = data["status"] ?? "";
            String orderId = doc.id;

            return FutureBuilder<Map<String, dynamic>?>(
              future: getNameFromOtherCollectionn(clientId),
              builder: (context, snapshot) {
                String clientName = snapshot.data?['name'] ?? clientId;
                String vendorName = snapshot.data?['name'] ?? vendorId;

                return StreamBuilder<int>(
                    stream: _viewModel.getReadByCount(orderId, vendorId,
                        user!.userType.name, user!.id!, clientId),
                    builder: (context, snapshot) {
                      final readByCounts = snapshot.data ?? " ";

                      return Column(
                        children: [
                          ListTile(
                            leading: Container(
                              width: 60,
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.darkBlueColor,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 100,
                                backgroundImage: CachedNetworkImageProvider(user!
                                        .profilePic ??
                                    "data:image/png;base64,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"),
                              ),
                            ),
                            title: Text(
                              "$serviceName : $orderId",
                              style: FontStyles.font14Semibold,
                            ),

                            subtitle: Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                children: [
                                  Text(
                                    readByCounts.toString() == "0"
                                        ? "no new messages"
                                        : "$readByCounts new messages",
                                    style: FontStyles.font11Light
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "Status : $status",
                                    textAlign: TextAlign.end,
                                    style: FontStyles.font11Light
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            // trailing: Text(data["created_at"].toString()),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatView(
                                        orderId,
                                        clientId,
                                        vendorId,
                                        clientName,
                                        vendorName,
                                        user!.id!,
                                        serviceName)),
                              );
                            },
                          ),
                          Divider(),
                        ],
                      );
                    });
              },
            );
          },
        );
      },
    );
  }

  Future<String?> getNameFromOtherCollection(String id) async {
    final collection = FirebaseFirestore.instance.collection('user');
    final docSnapshot = await collection.doc(id).get();
    final data = docSnapshot.data();

    if (data != null) {
      return data['name'];
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getNameFromOtherCollectionn(String id) async {
    final collection = FirebaseFirestore.instance.collection('user');
    final docSnapshot = await collection.doc(id).get();
    final data = docSnapshot.data();

    if (data != null) {
      return {'name': data['name'], 'profile_pic': data['profile_pic']};
    } else {
      return null;
    }
  }
}

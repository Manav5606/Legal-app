import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/presentation/pages/home/tabs/notification/dialog/create_notification.dart';
import 'package:admin/presentation/pages/home/tabs/notification/notification_view_model.dart';
import 'package:admin/presentation/pages/home/tabs/widgets/notification_tile.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

import '../../../orders_admin_page/order_page.dart';

class NotificationTab extends ConsumerStatefulWidget {
  const NotificationTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationTabState();
}

class _NotificationTabState extends ConsumerState<NotificationTab> {
  late final NotificationviewModel _viewModel;
  @override
  void initState() {
    _viewModel = ref.read(NotificationviewModel.provider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(NotificationviewModel.provider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _heading(),
              CTAButton(
                title: "Create\nNotification",
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) => const Dialog(
                      insetPadding: EdgeInsets.all(24),
                      child: CreateNotification(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 28),

          /// List View For All the Notification
          Expanded(
            child: ListView.builder(
              itemCount: _viewModel.getNotifications.length,
              itemBuilder: (BuildContext context, int i) {
                final notification = _viewModel.getNotifications[i];
                DateTime dateTime = notification.createdAt!.toDate();
                String formattedTime = DateFormat('h:mm a').format(dateTime);
                // getNameFromOtherCollection(notification.userId!);
                return FutureBuilder<String?>(
                    future: getNameFromOtherCollection(notification.userId!),
                    builder: (context, snapshot) {
                      final profilePic = snapshot.data;
                      return GestureDetector(
                        onTap: () {
                          Routemaster.of(context).push(OrderPage.routeName,
                              queryParameters: {
                                "orderID": notification.orderId!,
                                "serviceId": notification.serviceId!
                              });
                          _viewModel.markAsRead(notification.id.toString());
                        },
                        child: NotificationTile(
                          imageUrl: profilePic ??
                              "data:image/png;base64,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",
                          title: notification.message.toString(),
                          subTitle: 'Notification brief is written here...',
                          date: formattedTime,
                          isOpened: notification.isRead,
                        ),
                      );
                    });
              },
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _heading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Notifications", style: FontStyles.font24Semibold),
        Text("Your updates are here", style: FontStyles.font14Semibold),
      ],
    );
  }

  Future<String?> getNameFromOtherCollection(String id) async {
    final collection = FirebaseFirestore.instance.collection('user');
    final docSnapshot = await collection.doc(id).get();
    final data = docSnapshot.data();

    if (data != null) {
      return data['profile_pic'];
    } else {
      return null;
    }
  }
}

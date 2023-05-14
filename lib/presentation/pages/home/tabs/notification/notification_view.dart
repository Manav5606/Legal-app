import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationTab extends ConsumerStatefulWidget {
  const NotificationTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationTabState();
}

class _NotificationTabState extends ConsumerState<NotificationTab> {
  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return Container();
=======
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
                    imageUrl:
                        'https://xsgames.co/randomusers/assets/avatars/female/62.jpg',
                    title: notification.message.toString(),
                    subTitle: 'Notification brief is written here...',
                    date: formattedTime,
                    isOpened: notification.isRead,
                  ),
                );
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
>>>>>>> Stashed changes
  }
}

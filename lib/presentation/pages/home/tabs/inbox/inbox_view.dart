import 'package:admin/core/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constant/fontstyles.dart';
import 'chat_view.dart';

class InboxTab extends ConsumerStatefulWidget {
  const InboxTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InboxTabState();
}

class _InboxTabState extends ConsumerState<InboxTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 20),
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
          Expanded(child: _chatList()),
        ],
      ),
    );
  }
}

Widget _chatList() {
  return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                "https://www.google.com/imgres?imgurl=https%3A%2F%2Fwww.whatobuy.in%2Fwp-content%2Fuploads%2F2017%2F09%2Fprogrammer-whatsapp-status.png&tbnid=HrxMrLorcPWZzM&vet=12ahUKEwivh-yRsMf-AhX1H7cAHauqDmoQMygAegQIARAm..i&imgrefurl=https%3A%2F%2Fwww.whatobuy.in%2Fprogrammer-whatsapp-status%2F&docid=cAYsp22wsjyCLM&w=800&h=350&q=whatsapp%20dp%20for%20coder%20with%20short%20urls&ved=2ahUKEwivh-yRsMf-AhX1H7cAHauqDmoQMygAegQIARAm"),
          ),
          title: Text("manav"),
          subtitle: Text("chat.message"),
          trailing: Text("10:42 am"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatView()),
            );
          },
        );
      });
}

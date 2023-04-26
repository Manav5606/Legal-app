import 'package:admin/presentation/pages/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constant/colors.dart';
import '../../../../../core/constant/fontstyles.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatViewState();
}

final TextEditingController notesController = TextEditingController();

class _ChatViewState extends ConsumerState<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          // height: 500,
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  final isMyMessage = index % 2 ==
                      0; // alternate between my and other person's messages
                  return Container(
                    alignment: isMyMessage
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isMyMessage
                            ? SizedBox(width: 48.0)
                            : Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://example.com/other_user_image.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        SizedBox(width: 8.0),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: isMyMessage
                                  ? AppColors.lightBlueColor
                                  : Colors.pink[100],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              "This is a ${isMyMessage ? "sent" : "received"} message with a ${isMyMessage ? "light blue" : "light red"} background",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                        isMyMessage
                            ? Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://example.com/my_user_image.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : SizedBox(width: 48.0),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: "type herer",
                    controller: notesController,

                    // onSubmitted: "_addMessage",
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

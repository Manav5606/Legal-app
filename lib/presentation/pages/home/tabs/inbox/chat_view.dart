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
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                // final message = _messages[index];
                return ListTile(title: Text("message"));
              },
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

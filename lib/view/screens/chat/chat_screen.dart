import 'package:flutter/material.dart';
import 'package:jobreels/util/app_strings.dart';
import 'package:jobreels/view/base/custom_app_bar.dart';
import '../../../data/model/response/chat_model.dart';

class ChatScreen extends StatefulWidget {
  final bool showAppBar;
  final String userName;
  final int userId;
  const ChatScreen({Key? key, this.showAppBar = false, required this.userId, required this.userName}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> chatMessages = [
    ChatMessage(
      message: 'Hello',
      dateTime: DateTime(2022, 12, 30),
      isMyMessage: true,
    ),
    ChatMessage(
      message: 'How are you?',
      dateTime: DateTime(2022, 12, 30),
      isMyMessage: false,
    ),
    ChatMessage(
      message: 'I am fine.',
      dateTime: DateTime(2022, 12, 31),
      isMyMessage: true,
    ),
    ChatMessage(
      message: 'What about you?',
      dateTime: DateTime(2022, 12, 31),
      isMyMessage: false,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? CustomAppBar(
        title: widget.userName,
        leading: null,
        showLeading: true,
        titleColor: Theme.of(context).primaryColorLight,
        tileColor: Theme.of(context).primaryColor,
      ): null,
      body: ListView.builder(
        itemCount: chatMessages.length,
        itemBuilder: (context, index) {
          final message = chatMessages[index];
          final previousMessage = index > 0 ? chatMessages[index - 1] : null;

          // Check if the current message has a different date than the previous message
          final showDateSeparation = previousMessage == null ||
              message.dateTime.difference(previousMessage.dateTime).inDays != 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showDateSeparation)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message.dateTime.toString(), // Format the date as needed
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ListTile(
                title: Text(message.message),
              ),
            ],
          );
        },
      ),
    );
  }
}

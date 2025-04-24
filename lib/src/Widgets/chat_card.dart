library;

import 'package:flutter/material.dart';

import '../models/chat_types.dart';

class ChatCard extends StatelessWidget {
  final Widget? chatCardWidget;
  final BoxDecoration? decoration;
  final ChatCardType? chatCardType;
  final String userKey;
  final String messageKey;
  final Map chatMap;
  final String myUserId;
  final BoxDecoration? chatCardDecoration;

  const ChatCard({
    super.key,
    this.chatCardWidget,
    this.decoration,
    this.chatCardType,
    this.chatCardDecoration,
    required this.chatMap,
    required this.myUserId,
    required this.userKey,
    required this.messageKey,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (chatCardType == ChatCardType.simpleChatCard) {
      return Align(
        alignment: myUserId == chatMap[userKey]
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: decoration ??
              BoxDecoration(
                color: myUserId == chatMap[userKey]
                    ? Colors.green.shade200
                    : Colors.white,
                borderRadius: BorderRadius.circular(
                  7.5,
                ),
              ),
          constraints: BoxConstraints(
            maxWidth: size.width * 0.6,
          ),
          child: Text(
            chatMap[messageKey],
            style: TextStyle(),
          ),
        ),
      );
    } else if (chatCardType == ChatCardType.gradientChatCard) {
      return Align(
        alignment: myUserId == chatMap[userKey]
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: decoration ??
              BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.red,
                    Colors.red,
                    Colors.black,
                    Colors.black,
                  ],
                ),
                borderRadius: BorderRadius.circular(
                  7.5,
                ),
              ),
          constraints: BoxConstraints(
            maxWidth: size.width * 0.6,
          ),
          child: Text(
            chatMap[messageKey],
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    return Container();
  }
}

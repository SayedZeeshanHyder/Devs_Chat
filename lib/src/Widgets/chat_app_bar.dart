import 'package:flutter/material.dart';

import '../models/chat_types.dart';

class ChatAppBar extends StatelessWidget {
  final ChatAppBarType? chatAppBarType;
  const ChatAppBar({super.key, this.chatAppBarType});

  @override
  Widget build(BuildContext context) {
    if (chatAppBarType == ChatAppBarType.defaultAppBar) {
      return Row(
        children: [
          Icon(
            Icons.arrow_back_ios_new,
          ),
          SizedBox(
            width: 10,
          ),
          CircleAvatar(),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thelegend101z",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Online",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              )
            ],
          )
        ],
      );
    } else if (chatAppBarType == ChatAppBarType.gradientAppBar) {
      return Row();
    }
    return Container();
  }
}

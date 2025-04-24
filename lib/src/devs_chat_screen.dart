import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devs_chat/devs_chat.dart';
import 'package:flutter/material.dart';
import 'models/chat_types.dart';

class DevsChatScreen extends StatefulWidget {
  final ChatCardType? chatCardType;
  final Widget? chatCardWidget;
  final ChatAppBarType? appBar;
  final PreferredSizeWidget? appBarWidget;
  final void Function(Map message)? onSendMessageButtonPressed;
  String? documentId;
  final String userIdKey;
  final String myUserId;
  final String oppUserId;
  final String messageKey;
  final String? timestampKey;
  final ImageProvider<Object>? chatBackgroundImage;
  final Color? chatBackgroundColor;
  final String collectionName;
  final String chatListKey;
  final Widget? sendMessageButtonWidget;

  DevsChatScreen(
      {super.key,
      this.chatCardType,
      this.chatCardWidget,
      this.appBar,
      required this.chatListKey,
      this.onSendMessageButtonPressed,
      this.documentId,
      required this.userIdKey,
      required this.messageKey,
      this.timestampKey,
      this.chatBackgroundImage,
      this.chatBackgroundColor,
      required this.myUserId,
      required this.collectionName,
      required this.oppUserId,
      this.sendMessageButtonWidget,
      this.appBarWidget})
      : assert(chatCardType == null || chatCardWidget == null,
            'Both chatCardType and chatCardWidget cannot be non-null at the same time.'),
        assert(chatCardType != null || chatCardWidget != null,
            'Either chatCardType or chatCardWidget must be provided.'),
        assert(appBar != null || appBarWidget != null,
            'Both appBar and appBarWidget cannot be null at the same time.'),
        assert(appBar == null || appBarWidget == null,
            'Both appBar and appBarWidget cannot be non-null at the same time.'),
        assert(chatBackgroundImage == null || chatBackgroundColor == null,
            'Both chatBackgroundImage and chatBackgroundColors cannot be non-null at the same time.');

  @override
  State<DevsChatScreen> createState() => _DevsChatScreenState();
}

class _DevsChatScreenState extends State<DevsChatScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.documentId == null) {
      if (widget.myUserId.hashCode > widget.oppUserId.hashCode) {
        widget.documentId = "${widget.myUserId}${widget.oppUserId}";
      } else {
        widget.documentId = "${widget.oppUserId}${widget.myUserId}";
      }
    }
  }

  final TextEditingController messageController = TextEditingController();

  final FocusNode textFieldFocusNode = FocusNode();

  Future<void> sendMessage(Map<String, dynamic> newChat) async {
    try {
      var get = await FirebaseFirestore.instance
          .collection(widget.collectionName)
          .doc(widget.documentId)
          .get();
      if (get.exists) {
        List chats = get.data()?[widget.chatListKey] ?? [];
        chats.insert(0, newChat);

        await FirebaseFirestore.instance
            .collection(widget.collectionName)
            .doc(widget.documentId)
            .update({widget.chatListKey: chats});
      }
    } catch (e) {
      print("Message Sending Failed ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An Error as Occured ${e.toString()}"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: widget.appBarWidget ??
            AppBar(
              automaticallyImplyLeading: false,
              title: ChatAppBar(
                chatAppBarType: widget.appBar,
              ),
            ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          height: 60,
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      25,
                    ),
                  ),
                  child: TextField(
                    focusNode: textFieldFocusNode,
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () async {
                  final newChat = {
                    widget.userIdKey: widget.myUserId,
                    widget.messageKey: messageController.text,
                    widget.timestampKey ?? 'timestamp': DateTime.now(),
                  };
                  await sendMessage(newChat);
                  widget.onSendMessageButtonPressed!(newChat);
                  messageController.clear();
                  textFieldFocusNode.unfocus();
                },
                child: widget.sendMessageButtonWidget ??
                    CircleAvatar(
                      child: Icon(
                        Icons.send,
                      ),
                    ),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: widget.chatBackgroundImage != null
                ? DecorationImage(
                    image: widget.chatBackgroundImage!,
                    fit: BoxFit.fill,
                  )
                : null,
            color: widget.chatBackgroundColor,
          ),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(widget.collectionName)
                        .doc(widget.documentId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      List chats =
                          snapshot.data?.data()?[widget.chatListKey] ?? [];
                      return ListView.builder(
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          return ChatCard(
                            chatMap: chats[index],
                            myUserId: widget.myUserId,
                            chatCardType: widget.chatCardType,
                            userKey: widget.userIdKey,
                            messageKey: widget.messageKey,
                          );
                        },
                      );
                    }),
              ),
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

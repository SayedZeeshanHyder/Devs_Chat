import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devs_chat/devs_chat.dart';
import 'package:flutter/material.dart';
import 'Widgets/chat_input_field.dart';
import 'models/chat_types.dart';

class DevsChatScreen extends StatefulWidget {
  // Chat card customization
  final ChatCardType? chatCardType;
  final Widget? chatCardWidget;
  final BoxDecoration? myMessageDecoration;
  final BoxDecoration? otherMessageDecoration;
  final TextStyle? myMessageTextStyle;
  final TextStyle? otherMessageTextStyle;
  final EdgeInsetsGeometry? chatCardPadding;
  final EdgeInsetsGeometry? chatCardMargin;
  final double? chatCardMaxWidth;
  final Widget Function(DateTime)? timestampBuilder;

  // AppBar customization
  final ChatAppBarType? appBarType;
  final PreferredSizeWidget? appBarWidget;
  final String? appBarTitle;
  final String? appBarSubtitle;
  final ImageProvider? appBarAvatar;
  final Color? appBarBackgroundColor;
  final Color? appBarTextColor;
  final List<Widget>? appBarActions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  // Input field customization
  final InputFieldType? inputFieldType;
  final Widget? customInputField;
  final String? inputHintText;
  final Widget? sendButtonWidget;
  final Widget? attachmentButtonWidget;
  final Widget? voiceButtonWidget;
  final Function()? onAttachmentPressed;
  final Function()? onVoicePressed;
  final BoxDecoration? inputDecoration;
  final Color? inputBackgroundColor;
  final EdgeInsetsGeometry? inputPadding;
  final EdgeInsetsGeometry? inputMargin;
  final bool showAttachmentButton;
  final bool showVoiceButton;

  // Chat background customization
  final ImageProvider<Object>? chatBackgroundImage;
  final Color? chatBackgroundColor;

  // Firestore configuration
  final String? documentId;
  final String userIdKey;
  final String myUserId;
  final String oppUserId;
  final String messageKey;
  final String? timestampKey;
  final String collectionName;
  final String chatListKey;

  // Callback functions
  final void Function(Map<String, dynamic> message)? onSendMessageButtonPressed;
  final void Function(Map<String, dynamic> message)? onMessageReceived;
  final ScrollController? scrollController;

  // List layout customization
  final bool reverseList;
  final EdgeInsetsGeometry? listPadding;
  final bool showScrollToBottomButton;
  final Widget? scrollToBottomButtonWidget;

  DevsChatScreen({
    Key? key,
    // Chat card options
    this.chatCardType,
    this.chatCardWidget,
    this.myMessageDecoration,
    this.otherMessageDecoration,
    this.myMessageTextStyle,
    this.otherMessageTextStyle,
    this.chatCardPadding,
    this.chatCardMargin,
    this.chatCardMaxWidth,
    this.timestampBuilder,

    // AppBar options
    this.appBarType,
    this.appBarWidget,
    this.appBarTitle,
    this.appBarSubtitle,
    this.appBarAvatar,
    this.appBarBackgroundColor,
    this.appBarTextColor,
    this.appBarActions,
    this.showBackButton = true,
    this.onBackPressed,

    // Input field options
    this.inputFieldType,
    this.customInputField,
    this.inputHintText,
    this.sendButtonWidget,
    this.attachmentButtonWidget,
    this.voiceButtonWidget,
    this.onAttachmentPressed,
    this.onVoicePressed,
    this.inputDecoration,
    this.inputBackgroundColor,
    this.inputPadding,
    this.inputMargin,
    this.showAttachmentButton = false,
    this.showVoiceButton = false,

    // Background options
    this.chatBackgroundImage,
    this.chatBackgroundColor,

    // Firestore options
    this.documentId,
    required this.userIdKey,
    required this.myUserId,
    required this.oppUserId,
    required this.messageKey,
    this.timestampKey,
    required this.collectionName,
    required this.chatListKey,

    // Callback functions
    this.onSendMessageButtonPressed,
    this.onMessageReceived,
    this.scrollController,

    // List layout options
    this.reverseList = true,
    this.listPadding,
    this.showScrollToBottomButton = false,
    this.scrollToBottomButtonWidget,
  }) : super(key: key);

  @override
  State<DevsChatScreen> createState() => _DevsChatScreenState();
}

class _DevsChatScreenState extends State<DevsChatScreen> {
  String? documentId;
  late TextEditingController messageController;
  late FocusNode textFieldFocusNode;
  late ScrollController _scrollController;
  bool showScrollToBottom = true;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    messageController = TextEditingController();
    textFieldFocusNode = FocusNode();
    _scrollController = widget.scrollController ?? ScrollController();

    // Add scroll listener if needed
    if (widget.showScrollToBottomButton) {
      _scrollController.addListener(_scrollListener);
    }

    // Generate documentId if not provided
    if (widget.documentId == null) {
      if (widget.myUserId.hashCode > widget.oppUserId.hashCode) {
        documentId = "${widget.myUserId}${widget.oppUserId}";
      } else {
        documentId = "${widget.oppUserId}${widget.myUserId}";
      }
    } else {
      documentId = widget.documentId;
    }
  }

  @override
  void dispose() {
    if (widget.showScrollToBottomButton && widget.scrollController == null) {
      _scrollController.removeListener(_scrollListener);
      _scrollController.dispose();
    }
    if (widget.scrollController == null) {
      messageController.dispose();
      textFieldFocusNode.dispose();
    }
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final showButton = _scrollController.position.pixels > 300;
      if (showScrollToBottom != showButton) {
        setState(() {
          showScrollToBottom = showButton;
        });
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> sendMessage(Map<String, dynamic> newChat) async {
    try {
      // Add timestamp if not provided
      if (widget.timestampKey != null &&
          !newChat.containsKey(widget.timestampKey)) {
        newChat[widget.timestampKey!] = DateTime.now();
      }

      // Get document reference
      var docRef = FirebaseFirestore.instance
          .collection(widget.collectionName)
          .doc(documentId);

      // Fetch current document
      var docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Update existing chat document
        List chats = docSnapshot.data()?[widget.chatListKey] ?? [];
        chats.insert(0, newChat);

        await docRef.update({widget.chatListKey: chats});
      } else {
        // Create new chat document
        await docRef.set({
          widget.chatListKey: [newChat],
        });
      }

      // Notify parent about sent message
      if (widget.onSendMessageButtonPressed != null) {
        widget.onSendMessageButtonPressed!(newChat);
      }
    } catch (e) {
      print("Message Sending Failed: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: ${e.toString()}"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(showScrollToBottom);
    return SafeArea(
      child: Scaffold(
        appBar: widget.appBarWidget ??
            AppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 0, // Remove the default spacing
              title: ChatAppBar(
                chatAppBarType:
                    widget.appBarType ?? ChatAppBarType.defaultAppBar,
                title: widget.appBarTitle ?? 'Chat',
                subtitle: widget.appBarSubtitle,
                avatarImage: widget.appBarAvatar,
                backgroundColor: widget.appBarBackgroundColor,
                textColor: widget.appBarTextColor,
                actions: widget.appBarActions,
                showBackButton: widget.showBackButton,
                onBackPressed: widget.onBackPressed,
              ),
              backgroundColor: widget.appBarBackgroundColor,
            ),
        body: Container(
          decoration: BoxDecoration(
            image: widget.chatBackgroundImage != null
                ? DecorationImage(
                    image: widget.chatBackgroundImage!,
                    fit: BoxFit.cover,
                  )
                : null,
            color: widget.chatBackgroundColor ?? Colors.white,
          ),
          child: Column(
            children: [
              // Messages list
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(widget.collectionName)
                      .doc(documentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Error loading messages: ${snapshot.error}",
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    // Process chat data
                    List chats =
                        snapshot.data?.data()?[widget.chatListKey] ?? [];

                    // Notify parent of received messages if needed
                    if (widget.onMessageReceived != null && chats.isNotEmpty) {
                      // Find messages from the other user
                      for (var chat in chats) {
                        if (chat[widget.userIdKey] == widget.oppUserId) {
                          widget.onMessageReceived!(chat);
                        }
                      }
                    }

                    return Stack(
                      children: [
                        // Messages ListView
                        ListView.builder(
                          controller: _scrollController,
                          reverse: widget.reverseList,
                          padding: widget.listPadding ??
                              EdgeInsets.only(bottom: 16, top: 8),
                          physics: BouncingScrollPhysics(),
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            return ChatCard(
                              chatMap: chats[index],
                              myUserId: widget.myUserId,
                              chatCardType: widget.chatCardType,
                              chatCardWidget: widget.chatCardWidget,
                              userKey: widget.userIdKey,
                              messageKey: widget.messageKey,
                              timestampKey: widget.timestampKey,
                              timestampBuilder: widget.timestampBuilder,
                              myMessageDecoration: widget.myMessageDecoration,
                              otherMessageDecoration:
                                  widget.otherMessageDecoration,
                              myMessageTextStyle: widget.myMessageTextStyle,
                              otherMessageTextStyle:
                                  widget.otherMessageTextStyle,
                              padding: widget.chatCardPadding,
                              margin: widget.chatCardMargin,
                              maxWidth: widget.chatCardMaxWidth,
                            );
                          },
                        ),

                        // Scroll to bottom button
                        if (widget.showScrollToBottomButton &&
                            showScrollToBottom)
                          Positioned(
                            right: 16,
                            bottom: 16,
                            child: GestureDetector(
                              onTap: _scrollToBottom,
                              child: widget.scrollToBottomButtonWidget ??
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.blue,
                                    child: Icon(
                                      Icons.arrow_downward,
                                      color: Colors.white,
                                    ),
                                  ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),

              // Input field
              widget.customInputField ??
                  ChatInputField(
                    controller: messageController,
                    focusNode: textFieldFocusNode,
                    inputType:
                        widget.inputFieldType ?? InputFieldType.defaultInput,
                    hintText: widget.inputHintText ?? "Type a message",
                    onSend: (message) async {
                      if (message.trim().isNotEmpty) {
                        final newChat = {
                          widget.userIdKey: widget.myUserId,
                          widget.messageKey: message,
                        };
                        await sendMessage(newChat);
                      }
                    },
                    sendButtonWidget: widget.sendButtonWidget,
                    attachmentButtonWidget: widget.attachmentButtonWidget,
                    voiceButtonWidget: widget.voiceButtonWidget,
                    onAttachmentPressed: widget.onAttachmentPressed,
                    onVoicePressed: widget.onVoicePressed,
                    decoration: widget.inputDecoration,
                    backgroundColor: widget.inputBackgroundColor,
                    padding: widget.inputPadding,
                    margin: widget.inputMargin,
                    showAttachmentButton: widget.showAttachmentButton,
                    showVoiceButton: widget.showVoiceButton,
                  ),
              SizedBox(height: 8), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devs_chat/devs_chat.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Widgets/chat_input_field.dart';

/// A complete chat screen widget with Firebase Firestore integration.
///
/// This widget provides a fully-featured chat interface including message display,
/// input field, and app bar. It connects to Firebase Firestore to send and receive
/// messages in real time.
///
/// Key features:
/// - Real-time message synchronization with Firestore
/// - Customizable chat bubbles and message appearance
/// - Flexible app bar with various styles
/// - Customizable input field with options for attachments and voice recording
/// - Support for background images or colors
/// - Automatic message display and sorting
///
/// Example usage:
/// ```dart
/// DevsChatScreen(
///   collectionName: 'chats',
///   myUserId: 'user_123',
///   oppUserId: 'user_456',
///   userIdKey: 'senderId',
///   messageKey: 'text',
///   timestampKey: 'timestamp',
///   chatListKey: 'messages',
///   appBarTitle: 'Chat',
/// )
/// ```
class DevsChatScreen extends StatefulWidget {
  /// Type of chat card to use for message display
  final ChatCardType? chatCardType;

  /// Custom widget to use instead of the default chat card
  final Widget? chatCardWidget;

  /// Decoration for messages sent by the current user
  final BoxDecoration? myMessageDecoration;

  /// Decoration for messages sent by other users
  final BoxDecoration? otherMessageDecoration;

  /// Text style for messages sent by the current user
  final TextStyle? myMessageTextStyle;

  /// Text style for messages sent by other users
  final TextStyle? otherMessageTextStyle;

  /// Padding applied to chat message cards
  final EdgeInsetsGeometry? chatCardPadding;

  /// Margin applied to chat message cards
  final EdgeInsetsGeometry? chatCardMargin;

  /// Maximum width of chat message cards
  final double? chatCardMaxWidth;

  /// Custom builder function for rendering message timestamps
  final Widget Function(DateTime)? timestampBuilder;

  /// Type of app bar to use
  final ChatAppBarType? appBarType;

  /// Custom widget to use instead of the default app bar
  final PreferredSizeWidget? appBarWidget;

  /// Title text displayed in the app bar
  final String? appBarTitle;

  /// Subtitle text displayed in the app bar
  final String? appBarSubtitle;

  /// Avatar image displayed in the app bar
  final ImageProvider? appBarAvatar;

  /// Background color of the app bar
  final Color? appBarBackgroundColor;

  /// Text color used in the app bar
  final Color? appBarTextColor;

  /// Additional widgets to display in the app bar actions area
  final List<Widget>? appBarActions;

  /// Whether to show a back button in the app bar
  final bool showBackButton;

  /// Callback function triggered when the back button is pressed
  final VoidCallback? onBackPressed;

  /// Type of input field to use
  final InputFieldType? inputFieldType;

  /// Custom widget to use instead of the default input field
  final Widget? customInputField;

  /// Hint text displayed in the input field
  final String? inputHintText;

  /// Custom widget for the send button
  final Widget? sendButtonWidget;

  /// Custom widget for the attachment button
  final Widget? attachmentButtonWidget;

  /// Custom widget for the voice recording button
  final Widget? voiceButtonWidget;

  /// Callback function triggered when the attachment button is pressed
  final Function()? onAttachmentPressed;

  /// Callback function triggered when the voice recording button is pressed
  final Function()? onVoicePressed;

  /// Decoration applied to the input field container
  final BoxDecoration? inputDecoration;

  /// Background color of the input field
  final Color? inputBackgroundColor;

  /// Padding applied to the input field
  final EdgeInsetsGeometry? inputPadding;

  /// Margin applied to the input field container
  final EdgeInsetsGeometry? inputMargin;

  /// Whether to show the attachment button
  final bool showAttachmentButton;

  /// Whether to show the voice recording button
  final bool showVoiceButton;

  /// Background image for the chat screen
  final ImageProvider<Object>? chatBackgroundImage;

  /// Background color for the chat screen
  final Color? chatBackgroundColor;

  /// ID of the Firestore document to use for storing chat messages
  final String? documentId;

  /// Key name for the user ID field in message documents
  final String userIdKey;

  /// ID of the current user
  final String myUserId;

  /// ID of the other user in the conversation
  final String oppUserId;

  /// Key name for the message text field in message documents
  final String messageKey;

  /// Key name for the timestamp field in message documents
  final String? timestampKey;

  /// Name of the Firestore collection to use for storing chat messages
  final String collectionName;

  /// Key name for the list of chat messages in the Firestore document
  final String chatListKey;

  /// Callback function triggered when a message is sent
  final void Function(Map<String, dynamic> message)? onSendMessageButtonPressed;

  /// Callback function triggered when a new message is received
  final void Function(Map<String, dynamic> message)? onMessageReceived;

  /// Custom scroll controller for the message list
  final ScrollController? scrollController;

  /// Whether to display the message list in reverse order (newest at bottom)
  final bool reverseList;

  /// Padding applied to the message list
  final EdgeInsetsGeometry? listPadding;

  /// Whether to show a button to quickly scroll to the bottom of the chat
  final bool showScrollToBottomButton;

  /// Custom widget for the scroll-to-bottom button
  final Widget? scrollToBottomButtonWidget;

  /// Creates a complete chat screen with Firebase Firestore integration.
  ///
  /// At minimum, you must provide the following parameters:
  /// - [userIdKey]: Field name for user ID in the message document
  /// - [myUserId]: ID of the current user
  /// - [oppUserId]: ID of the other user in the conversation
  /// - [messageKey]: Field name for message text in the message document
  /// - [collectionName]: Name of the Firestore collection to use
  /// - [chatListKey]: Field name for the list of messages in the document
  const DevsChatScreen({
    super.key,
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
  });

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

  /// Handles scroll events to show/hide the scroll-to-bottom button
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

  /// Scrolls to the bottom of the chat
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Sends a message to Firestore
  ///
  /// Takes a [newChat] map containing the message data and saves it to the
  /// Firestore collection. Adds a timestamp if one is not already present.
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

      // Show snack bar after async operation
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Message sent successfully"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Message Sending Failed: ${e.toString()}");
      }

      // Show snack bar after async operation
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("An error occurred: ${e.toString()}"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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

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
  final BoxDecoration? myMessageDecoration;
  final BoxDecoration? otherMessageDecoration;
  final TextStyle? myMessageTextStyle;
  final TextStyle? otherMessageTextStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? maxWidth;
  final String? timestampKey;
  final Widget Function(DateTime)? timestampBuilder;
  final bool showAvatar;
  final ImageProvider? senderAvatar;
  final ImageProvider? receiverAvatar;
  final String? senderName;
  final String? receiverName;

  const ChatCard({
    Key? key,
    this.chatCardWidget,
    this.decoration,
    this.chatCardType = ChatCardType.simpleChatCard,
    this.myMessageDecoration,
    this.otherMessageDecoration,
    this.myMessageTextStyle,
    this.otherMessageTextStyle,
    this.padding,
    this.margin,
    this.maxWidth,
    required this.chatMap,
    required this.myUserId,
    required this.userKey,
    required this.messageKey,
    this.timestampKey,
    this.timestampBuilder,
    this.showAvatar = false,
    this.senderAvatar,
    this.receiverAvatar,
    this.senderName,
    this.receiverName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Determine if the message was sent by the current user
    final isMyMessage = myUserId == chatMap[userKey];
    final alignment =
        isMyMessage ? Alignment.centerRight : Alignment.centerLeft;

    // If a custom widget is provided, wrap it with the correct alignment
    if (chatCardWidget != null) {
      return Align(alignment: alignment, child: chatCardWidget!);
    }

    // Get timestamp if available
    Widget? timestampWidget;
    if (timestampKey != null && chatMap[timestampKey] != null) {
      final timestamp = chatMap[timestampKey] is DateTime
          ? chatMap[timestampKey]
          : DateTime.fromMillisecondsSinceEpoch(
              (chatMap[timestampKey] is int)
                  ? chatMap[timestampKey]
                  : chatMap[timestampKey].seconds * 1000,
              isUtc: false,
            );

      if (timestampBuilder != null) {
        timestampWidget = timestampBuilder!(timestamp);
      } else {
        final hour = timestamp.hour.toString().padLeft(2, '0');
        final minute = timestamp.minute.toString().padLeft(2, '0');
        timestampWidget = Text(
          "$hour:$minute",
          style: TextStyle(fontSize: 10, color: Colors.grey),
        );
      }
    }

    // Apply the appropriate chat card style based on the selected type
    switch (chatCardType) {
      case ChatCardType.simpleChatCard:
        return _buildSimpleCard(context, isMyMessage, size, timestampWidget);
      case ChatCardType.gradientChatCard:
        return _buildGradientCard(context, isMyMessage, size, timestampWidget);
      case ChatCardType.bubbleChatCard:
        return _buildBubbleCard(context, isMyMessage, size, timestampWidget);
      case ChatCardType.cardChatCard:
        return _buildCardStyle(context, isMyMessage, size, timestampWidget);
      case ChatCardType.modernChatCard:
        return _buildModernCard(context, isMyMessage, size, timestampWidget);
      case ChatCardType.iosStyleChatCard:
        return _buildIOSStyleCard(context, isMyMessage, size, timestampWidget);
      case ChatCardType.materialChatCard:
        return _buildMaterialCard(context, isMyMessage, size, timestampWidget);
      default:
        return _buildSimpleCard(context, isMyMessage, size, timestampWidget);
    }
  }

  Widget _buildSimpleCard(BuildContext context, bool isMyMessage, Size size,
      Widget? timestampWidget) {
    final defaultPadding =
        padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    final defaultMargin =
        margin ?? EdgeInsets.symmetric(horizontal: 12, vertical: 4);
    final defaultMaxWidth = maxWidth ?? size.width * 0.75;

    final decoration = isMyMessage
        ? myMessageDecoration ??
            BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            )
        : otherMessageDecoration ??
            BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            );

    final textStyle = isMyMessage
        ? myMessageTextStyle ?? TextStyle(color: Colors.black87, fontSize: 15)
        : otherMessageTextStyle ??
            TextStyle(color: Colors.black87, fontSize: 15);

    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: defaultPadding,
        margin: defaultMargin,
        decoration: decoration,
        constraints: BoxConstraints(maxWidth: defaultMaxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatMap[messageKey],
              style: textStyle,
            ),
            if (timestampWidget != null) ...[
              SizedBox(height: 4),
              Align(
                alignment: Alignment.bottomRight,
                child: timestampWidget,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGradientCard(BuildContext context, bool isMyMessage, Size size,
      Widget? timestampWidget) {
    final defaultPadding =
        padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    final defaultMargin =
        margin ?? EdgeInsets.symmetric(horizontal: 12, vertical: 6);
    final defaultMaxWidth = maxWidth ?? size.width * 0.75;

    final gradientColors = isMyMessage
        ? [Color(0xFF4776E6), Color(0xFF8E54E9)] // Blue-Purple gradient
        : [Color(0xFFf2f2f2), Color(0xFFe6e6e6)]; // Light grey gradient

    final textColor = isMyMessage ? Colors.white : Colors.black87;

    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: defaultPadding,
        margin: defaultMargin,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: isMyMessage
                  ? gradientColors[0].withOpacity(0.15)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        constraints: BoxConstraints(maxWidth: defaultMaxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatMap[messageKey],
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                height: 1.3,
              ),
            ),
            if (timestampWidget != null) ...[
              SizedBox(height: 4),
              Align(
                alignment: Alignment.bottomRight,
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 10,
                    color: isMyMessage
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black54,
                  ),
                  child: timestampWidget,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBubbleCard(BuildContext context, bool isMyMessage, Size size,
      Widget? timestampWidget) {
    final defaultPadding =
        padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    final defaultMargin = margin ??
        EdgeInsets.only(
          left: isMyMessage ? 40 : 8,
          right: isMyMessage ? 8 : 40,
          top: 4,
          bottom: 4,
        );
    final defaultMaxWidth = maxWidth ?? size.width * 0.7;

    final myBubbleColor = Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2B5876)
        : Color(0xFF3498db);

    final otherBubbleColor = Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF323232)
        : Color(0xFFF5F5F5);

    final backgroundColor = isMyMessage ? myBubbleColor : otherBubbleColor;
    final textColor = isMyMessage ? Colors.white : Colors.black87;

    return Row(
      mainAxisAlignment:
          isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMyMessage && showAvatar) ...[
          Container(
            margin: EdgeInsets.only(right: 8, bottom: 6),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
              image: receiverAvatar != null
                  ? DecorationImage(
                      image: receiverAvatar!,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: receiverAvatar == null
                ? Icon(Icons.person, size: 16, color: Colors.grey.shade600)
                : null,
          ),
        ],
        Flexible(
          child: Container(
            padding: defaultPadding,
            margin: defaultMargin,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isMyMessage ? 18 : 4),
                topRight: Radius.circular(isMyMessage ? 4 : 18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.2),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            constraints: BoxConstraints(maxWidth: defaultMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatMap[messageKey],
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    height: 1.3,
                  ),
                ),
                if (timestampWidget != null) ...[
                  SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 10,
                        color: isMyMessage ? Colors.white70 : Colors.black54,
                      ),
                      child: timestampWidget,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (isMyMessage && showAvatar) ...[
          Container(
            margin: EdgeInsets.only(left: 8, bottom: 6),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
              image: senderAvatar != null
                  ? DecorationImage(
                      image: senderAvatar!,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: senderAvatar == null
                ? Icon(Icons.person, size: 16, color: Colors.grey.shade600)
                : null,
          ),
        ],
      ],
    );
  }

  Widget _buildCardStyle(BuildContext context, bool isMyMessage, Size size,
      Widget? timestampWidget) {
    final defaultPadding =
        padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    final defaultMargin =
        margin ?? EdgeInsets.symmetric(horizontal: 16, vertical: 6);
    final defaultMaxWidth = maxWidth ?? size.width * 0.75;

    final nameStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      color: isMyMessage ? Colors.blue.shade700 : Colors.grey.shade700,
    );

    final borderColor =
        isMyMessage ? Colors.blue.shade200 : Colors.grey.shade300;

    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Card(
        color: isMyMessage ? Colors.blue.shade50 : Colors.white,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.1),
        margin: defaultMargin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: 1),
        ),
        child: Container(
          padding: defaultPadding,
          constraints: BoxConstraints(maxWidth: defaultMaxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMyMessage && senderName != null ||
                  !isMyMessage && receiverName != null) ...[
                Text(
                  isMyMessage
                      ? (senderName ?? 'You')
                      : (receiverName ?? 'User'),
                  style: nameStyle,
                ),
                SizedBox(height: 6),
              ],
              Text(
                chatMap[messageKey],
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  height: 1.3,
                ),
              ),
              if (timestampWidget != null) ...[
                SizedBox(height: 6),
                Align(
                  alignment: Alignment.bottomRight,
                  child: DefaultTextStyle(
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    child: timestampWidget,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Modern style with softer colors and subtle design
  Widget _buildModernCard(BuildContext context, bool isMyMessage, Size size,
      Widget? timestampWidget) {
    final defaultPadding =
        padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    final defaultMargin =
        margin ?? EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    final defaultMaxWidth = maxWidth ?? size.width * 0.75;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Soft, modern colors
    final myColor = isDark ? Color(0xFF2C3E50) : Color(0xFF0A84FF);
    final otherColor = isDark ? Color(0xFF1E1E1E) : Color(0xFFF2F2F7);

    final myTextColor = Colors.white;
    final otherTextColor = isDark ? Colors.white : Colors.black87;

    final statusColor = isMyMessage ? Colors.green : Colors.grey;

    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: defaultPadding,
        margin: defaultMargin,
        decoration: BoxDecoration(
          color: isMyMessage ? myColor : otherColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (isMyMessage ? myColor : otherColor).withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        constraints: BoxConstraints(maxWidth: defaultMaxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatMap[messageKey],
              style: TextStyle(
                color: isMyMessage ? myTextColor : otherTextColor,
                fontSize: 15,
                height: 1.4,
              ),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (timestampWidget != null)
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 10,
                      color: isMyMessage
                          ? Colors.white.withOpacity(0.7)
                          : (isDark ? Colors.white70 : Colors.black54),
                    ),
                    child: timestampWidget,
                  ),
                if (isMyMessage && timestampWidget != null) ...[
                  SizedBox(width: 4),
                  Icon(
                    Icons.check_circle,
                    size: 10,
                    color: statusColor,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // iOS style message bubbles
  Widget _buildIOSStyleCard(BuildContext context, bool isMyMessage, Size size,
      Widget? timestampWidget) {
    final defaultPadding =
        padding ?? EdgeInsets.symmetric(horizontal: 14, vertical: 10);
    final defaultMargin = margin ??
        EdgeInsets.only(
          left: isMyMessage ? 60 : 10,
          right: isMyMessage ? 10 : 60,
          top: 4,
          bottom: 4,
        );
    final defaultMaxWidth = maxWidth ?? size.width * 0.75;

    final myBubbleColor = Color(0xFF3B8AFF);
    final otherBubbleColor = Color(0xFFE9E9EB);

    final backgroundColor = isMyMessage ? myBubbleColor : otherBubbleColor;
    final textColor = isMyMessage ? Colors.white : Colors.black;

    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: defaultPadding,
        margin: defaultMargin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(isMyMessage ? 18 : 5),
            bottomRight: Radius.circular(isMyMessage ? 5 : 18),
          ),
        ),
        constraints: BoxConstraints(maxWidth: defaultMaxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                chatMap[messageKey],
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
              ),
            ),
            if (timestampWidget != null) ...[
              SizedBox(height: 4),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 10,
                  color: isMyMessage ? Colors.white70 : Colors.black54,
                ),
                child: timestampWidget,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Material design inspired chat card
  Widget _buildMaterialCard(BuildContext context, bool isMyMessage, Size size,
      Widget? timestampWidget) {
    final defaultPadding =
        padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    final defaultMargin =
        margin ?? EdgeInsets.symmetric(horizontal: 12, vertical: 6);
    final defaultMaxWidth = maxWidth ?? size.width * 0.75;

    final theme = Theme.of(context);
    final myCardColor = theme.colorScheme.primary;
    final otherCardColor =
        theme.brightness == Brightness.dark ? Color(0xFF2A2A2A) : Colors.white;

    final myTextColor = Colors.white;
    final otherTextColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black87;

    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: defaultMargin,
        child: Material(
          color: isMyMessage ? myCardColor : otherCardColor,
          elevation: 1,
          shadowColor: Colors.black26,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(isMyMessage ? 20 : 5),
            bottomRight: Radius.circular(isMyMessage ? 5 : 20),
          ),
          child: Container(
            padding: defaultPadding,
            constraints: BoxConstraints(maxWidth: defaultMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatMap[messageKey],
                  style: TextStyle(
                    color: isMyMessage ? myTextColor : otherTextColor,
                    fontSize: 15,
                  ),
                ),
                if (timestampWidget != null) ...[
                  SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 10,
                          color: isMyMessage
                              ? Colors.white70
                              : (theme.brightness == Brightness.dark
                                  ? Colors.white60
                                  : Colors.black45),
                        ),
                        child: timestampWidget,
                      ),
                      if (isMyMessage) ...[
                        SizedBox(width: 4),
                        Icon(
                          Icons.done_all,
                          size: 12,
                          color: Colors.white70,
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

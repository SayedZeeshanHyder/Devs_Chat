import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/chat_types.dart';

class ChatCard extends StatefulWidget {
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
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Determine if the message was sent by the current user
    final isMyMessage = widget.myUserId == widget.chatMap[widget.userKey];
    final alignment =
        isMyMessage ? Alignment.centerRight : Alignment.centerLeft;

    // If a custom widget is provided, wrap it with the correct alignment and long press handler
    if (widget.chatCardWidget != null) {
      return GestureDetector(
        onLongPress: _onLongPress,
        onTap: _onLongPress,
        child: Container(
          color:
              _isSelected ? Colors.grey.withOpacity(0.3) : Colors.transparent,
          child: Align(alignment: alignment, child: widget.chatCardWidget!),
        ),
      );
    }

    // Get timestamp if available
    Widget? timestampWidget;
    if (widget.timestampKey != null &&
        widget.chatMap[widget.timestampKey] != null) {
      final timestamp = widget.chatMap[widget.timestampKey] is DateTime
          ? widget.chatMap[widget.timestampKey]
          : DateTime.fromMillisecondsSinceEpoch(
              (widget.chatMap[widget.timestampKey] is int)
                  ? widget.chatMap[widget.timestampKey]
                  : widget.chatMap[widget.timestampKey].seconds * 1000,
              isUtc: false,
            );

      if (widget.timestampBuilder != null) {
        timestampWidget = widget.timestampBuilder!(timestamp);
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
    switch (widget.chatCardType) {
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

  void _onLongPress() {
    setState(() {
      _isSelected = !_isSelected;
    });
    // Add haptic feedback
    HapticFeedback.mediumImpact();
  }

  // Parse and render text with URL highlighting and copy on long press
  Widget _buildRichText(
      BuildContext context, String message, TextStyle baseStyle) {
    final urlPattern = RegExp(
      r'(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})',
      caseSensitive: false,
    );
    final matches = urlPattern.allMatches(message);
    if (matches.isEmpty) {
      return Text(message, style: baseStyle);
    }

    final List<InlineSpan> spans = [];
    int currentIndex = 0;

    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(
            text: message.substring(currentIndex, match.start),
            style: baseStyle,
          ),
        );
      }

      final url = message.substring(match.start, match.end);

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: () {
              print('URL tapped: $url');
              launchUrl(Uri.parse(url.trim()));
            },
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Successfully Copied to clipboard',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  duration: Duration(milliseconds: 1500),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(
                    bottom: 16.0,
                    right: 16.0,
                    left: MediaQuery.of(context).size.width * 0.6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Colors.grey.shade200,
                  elevation: 2,
                ),
              );
              HapticFeedback.lightImpact();
            },
            child: Text(
              url,
              style: baseStyle.copyWith(
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );

      currentIndex = match.end;
    }

    if (currentIndex < message.length) {
      spans.add(
        TextSpan(
          text: message.substring(currentIndex),
          style: baseStyle,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: baseStyle,
      ),
    );
  }

  Widget _buildSimpleCard(BuildContext context, bool isMyMessage, Size size,
      Widget? timestampWidget) {
    final defaultPadding =
        widget.padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    final defaultMargin =
        widget.margin ?? EdgeInsets.symmetric(horizontal: 12, vertical: 4);
    final defaultMaxWidth = widget.maxWidth ?? size.width * 0.75;

    final decoration = isMyMessage
        ? widget.myMessageDecoration ??
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
        : widget.otherMessageDecoration ??
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
        ? widget.myMessageTextStyle ??
            TextStyle(color: Colors.black87, fontSize: 15)
        : widget.otherMessageTextStyle ??
            TextStyle(color: Colors.black87, fontSize: 15);

    return GestureDetector(
      onLongPress: _onLongPress,
      onTap: _onLongPress,
      child: Container(
        color: _isSelected ? Colors.grey.withOpacity(0.3) : Colors.transparent,
        child: Align(
          alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: defaultPadding,
            margin: defaultMargin,
            decoration: decoration,
            constraints: BoxConstraints(maxWidth: defaultMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRichText(
                    context, widget.chatMap[widget.messageKey], textStyle),
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
        ),
      ),
    );
  }

  Widget _buildGradientCard(BuildContext context, bool isMyMessage, Size size,
      Widget? timestampWidget) {
    final defaultPadding =
        widget.padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    final defaultMargin =
        widget.margin ?? EdgeInsets.symmetric(horizontal: 12, vertical: 6);
    final defaultMaxWidth = widget.maxWidth ?? size.width * 0.75;

    final gradientColors = isMyMessage
        ? [Color(0xFF4776E6), Color(0xFF8E54E9)] // Blue-Purple gradient
        : [Color(0xFFf2f2f2), Color(0xFFe6e6e6)]; // Light grey gradient

    final textColor = isMyMessage ? Colors.white : Colors.black87;
    final textStyle = TextStyle(
      color: textColor,
      fontSize: 15,
      height: 1.3,
    );

    return GestureDetector(
      onLongPress: _onLongPress,
      onTap: _onLongPress,
      child: Container(
        color: _isSelected ? Colors.grey.withOpacity(0.3) : Colors.transparent,
        child: Align(
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
                _buildRichText(
                    context, widget.chatMap[widget.messageKey], textStyle),
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
        ),
      ),
    );
  }

  Widget _buildBubbleCard(BuildContext context, bool isMyMessage, Size size,
      Widget? timestampWidget) {
    final defaultPadding =
        widget.padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    final defaultMargin = widget.margin ??
        EdgeInsets.only(
          left: isMyMessage ? 40 : 8,
          right: isMyMessage ? 8 : 40,
          top: 4,
          bottom: 4,
        );
    final defaultMaxWidth = widget.maxWidth ?? size.width * 0.7;

    final myBubbleColor = Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2B5876)
        : Color(0xFF3498db);

    final otherBubbleColor = Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF323232)
        : Color(0xFFF5F5F5);

    final backgroundColor = isMyMessage ? myBubbleColor : otherBubbleColor;
    final textColor = isMyMessage ? Colors.white : Colors.black87;
    final textStyle = TextStyle(
      color: textColor,
      fontSize: 15,
      height: 1.3,
    );

    return GestureDetector(
      onTap: _onLongPress,
      onLongPress: _onLongPress,
      child: Container(
        color: _isSelected ? Colors.grey.withOpacity(0.3) : Colors.transparent,
        child: Row(
          mainAxisAlignment:
              isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMyMessage && widget.showAvatar) ...[
              Container(
                margin: EdgeInsets.only(right: 8, bottom: 6),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                  image: widget.receiverAvatar != null
                      ? DecorationImage(
                          image: widget.receiverAvatar!,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: widget.receiverAvatar == null
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
                    _buildRichText(
                        context, widget.chatMap[widget.messageKey], textStyle),
                    if (timestampWidget != null) ...[
                      SizedBox(height: 4),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                isMyMessage ? Colors.white70 : Colors.black54,
                          ),
                          child: timestampWidget,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (isMyMessage && widget.showAvatar) ...[
              Container(
                margin: EdgeInsets.only(left: 8, bottom: 6),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                  image: widget.senderAvatar != null
                      ? DecorationImage(
                          image: widget.senderAvatar!,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: widget.senderAvatar == null
                    ? Icon(Icons.person, size: 16, color: Colors.grey.shade600)
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCardStyle(BuildContext context, bool isMyMessage, Size size,
      Widget? timestampWidget) {
    final defaultPadding =
        widget.padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    final defaultMargin =
        widget.margin ?? EdgeInsets.symmetric(horizontal: 16, vertical: 6);
    final defaultMaxWidth = widget.maxWidth ?? size.width * 0.75;

    final nameStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      color: isMyMessage ? Colors.blue.shade700 : Colors.grey.shade700,
    );

    final borderColor =
        isMyMessage ? Colors.blue.shade200 : Colors.grey.shade300;

    final textStyle = TextStyle(
      color: Colors.black87,
      fontSize: 15,
      height: 1.3,
    );

    return GestureDetector(
      onTap: _onLongPress,
      onLongPress: _onLongPress,
      child: Container(
        color: _isSelected ? Colors.grey.withOpacity(0.3) : Colors.transparent,
        child: Align(
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
                  if (isMyMessage && widget.senderName != null ||
                      !isMyMessage && widget.receiverName != null) ...[
                    Text(
                      isMyMessage
                          ? (widget.senderName ?? 'You')
                          : (widget.receiverName ?? 'User'),
                      style: nameStyle,
                    ),
                    SizedBox(height: 6),
                  ],
                  _buildRichText(
                      context, widget.chatMap[widget.messageKey], textStyle),
                  if (timestampWidget != null) ...[
                    SizedBox(height: 6),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: DefaultTextStyle(
                        style: TextStyle(
                            fontSize: 10, color: Colors.grey.shade600),
                        child: timestampWidget,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Modern style with softer colors and subtle design
  Widget _buildModernCard(BuildContext context, bool isMyMessage, Size size,
      Widget? timestampWidget) {
    final defaultPadding =
        widget.padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    final defaultMargin =
        widget.margin ?? EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    final defaultMaxWidth = widget.maxWidth ?? size.width * 0.75;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Soft, modern colors
    final myColor = isDark ? Color(0xFF2C3E50) : Color(0xFF0A84FF);
    final otherColor = isDark ? Color(0xFF1E1E1E) : Color(0xFFF2F2F7);

    final myTextColor = Colors.white;
    final otherTextColor = isDark ? Colors.white : Colors.black87;

    final statusColor = isMyMessage ? Colors.green : Colors.grey;

    final textStyle = TextStyle(
      color: isMyMessage ? myTextColor : otherTextColor,
      fontSize: 15,
      height: 1.4,
    );

    return GestureDetector(
      onLongPress: _onLongPress,
      onTap: _onLongPress,
      child: Container(
        color: _isSelected ? Colors.grey.withOpacity(0.3) : Colors.transparent,
        child: Align(
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
                _buildRichText(
                    context, widget.chatMap[widget.messageKey], textStyle),
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
        ),
      ),
    );
  }

  // iOS style message bubbles
  Widget _buildIOSStyleCard(BuildContext context, bool isMyMessage, Size size,
      Widget? timestampWidget) {
    final defaultPadding =
        widget.padding ?? EdgeInsets.symmetric(horizontal: 14, vertical: 10);
    final defaultMargin = widget.margin ??
        EdgeInsets.only(
          left: isMyMessage ? 60 : 10,
          right: isMyMessage ? 10 : 60,
          top: 4,
          bottom: 4,
        );
    final defaultMaxWidth = widget.maxWidth ?? size.width * 0.75;

    final myBubbleColor = Color(0xFF3B8AFF);
    final otherBubbleColor = Color(0xFFE9E9EB);

    final backgroundColor = isMyMessage ? myBubbleColor : otherBubbleColor;
    final textColor = isMyMessage ? Colors.white : Colors.black;

    final textStyle = TextStyle(
      color: textColor,
      fontSize: 16,
    );

    return GestureDetector(
      onTap: _onLongPress,
      onLongPress: _onLongPress,
      child: Container(
        color: _isSelected ? Colors.grey.withOpacity(0.3) : Colors.transparent,
        child: Align(
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
                  child: _buildRichText(
                      context, widget.chatMap[widget.messageKey], textStyle),
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
        ),
      ),
    );
  }

  // Material design inspired chat card
  Widget _buildMaterialCard(BuildContext context, bool isMyMessage, Size size,
      Widget? timestampWidget) {
    final defaultPadding =
        widget.padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    final defaultMargin =
        widget.margin ?? EdgeInsets.symmetric(horizontal: 12, vertical: 6);
    final defaultMaxWidth = widget.maxWidth ?? size.width * 0.75;

    final theme = Theme.of(context);
    final myCardColor = theme.colorScheme.primary;
    final otherCardColor =
        theme.brightness == Brightness.dark ? Color(0xFF2A2A2A) : Colors.white;

    final myTextColor = Colors.white;
    final otherTextColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black87;

    final textStyle = TextStyle(
      color: isMyMessage ? myTextColor : otherTextColor,
      fontSize: 15,
    );

    return GestureDetector(
      onTap: _onLongPress,
      onLongPress: _onLongPress,
      child: Container(
        color: _isSelected ? Colors.grey.withOpacity(0.3) : Colors.transparent,
        child: Align(
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
                    _buildRichText(
                        context, widget.chatMap[widget.messageKey], textStyle),
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
        ),
      ),
    );
  }
}

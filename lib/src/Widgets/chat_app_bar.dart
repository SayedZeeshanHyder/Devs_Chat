import 'dart:math';

import 'package:flutter/material.dart';
import '../../devs_chat.dart';

/// A customizable chat app bar widget for use in messaging screens.
class ChatAppBar extends StatelessWidget {
  /// Defines the layout style or variant of the chat app bar.
  final ChatAppBarType? chatAppBarType;

  /// The main title displayed in the app bar, typically the user’s name.
  final String? title;

  /// An optional subtitle shown below the title (e.g., status or last seen).
  final String? subtitle;

  /// An avatar image to show in the app bar (usually profile picture).
  final ImageProvider? avatarImage;

  /// The background color of the app bar.
  final Color? backgroundColor;

  /// The color of text elements in the app bar.
  final Color? textColor;

  /// Action widgets (e.g., icons or buttons) to display on the right side.
  final List<Widget>? actions;

  /// Whether to show a back button on the left side.
  final bool showBackButton;

  /// Callback function triggered when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// Whether the app bar should appear elevated (with shadow).
  final bool elevated;

  /// Elevation value if [elevated] is true.
  final double elevation;

  /// Optional border radius to round corners of the app bar.
  final BorderRadius? borderRadius;

  /// Optional leading widget (e.g., custom back button or avatar).
  final Widget? leading;

  /// Whether the user is currently online.
  final bool? online;

  /// A string representing the user's last seen timestamp.
  final String? lastSeen;

  /// Whether to show a typing indicator under the title.
  final bool typingIndicator;

  /// Whether to display a shadow below the app bar.
  final bool showShadow;

  /// Optional custom height for the app bar.
  final double? height;

  /// Text style for the title.
  final TextStyle? titleStyle;

  /// Text style for the subtitle.
  final TextStyle? subtitleStyle;

  /// Creates a new [ChatAppBar] widget.
  const ChatAppBar({
    super.key,
    this.chatAppBarType = ChatAppBarType.defaultAppBar,
    this.title,
    this.subtitle,
    this.avatarImage,
    this.backgroundColor,
    this.textColor,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.elevated = false,
    this.elevation = 4.0,
    this.borderRadius,
    this.leading,
    this.online,
    this.lastSeen,
    this.typingIndicator = false,
    this.showShadow = true,
    this.height,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget content = switch (chatAppBarType) {
      ChatAppBarType.defaultAppBar => _buildDefaultAppBar(context),
      ChatAppBarType.gradientAppBar => _buildGradientAppBar(context),
      ChatAppBarType.compactAppBar => _buildCompactAppBar(context),
      ChatAppBarType.avatarAppBar => _buildAvatarAppBar(context),
      ChatAppBarType.modernAppBar => _buildModernAppBar(context),
      ChatAppBarType.businessAppBar => _buildBusinessAppBar(context),
      ChatAppBarType.professionaAppBar => _buildProfessionalAppBar(context),
      ChatAppBarType.minimalAppBar => _buildMinimalAppBar(context),
      ChatAppBarType.iosStyleAppBar => _buildIOSStyleAppBar(context),
      _ => _buildDefaultAppBar(context),
    };

    // Container to control height
    content = SizedBox(
      height: height ?? 56,
      child: content,
    );

    // Apply elevation if specified
    if (elevated && showShadow) {
      return Material(
        elevation: elevation,
        shadowColor: Colors.black26,
        borderRadius: borderRadius,
        color:
            backgroundColor ?? (isDark ? Colors.grey.shade900 : Colors.white),
        child: content,
      );
    }

    // Return without elevation
    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ?? (isDark ? Colors.grey.shade900 : Colors.white),
        borderRadius: borderRadius,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withAlpha(
                      13), // Replaced .withOpacity(0.05) with .withAlpha(13)
                  blurRadius: 1.0,
                  offset: Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: content,
    );
  }

  Widget _buildDefaultAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          children: [
            if (leading != null)
              leading!
            else if (showBackButton)
              _buildBackButton(context, isDark),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? 'Chat',
                      style: titleStyle ??
                          TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: textColor ??
                                (isDark ? Colors.white : Colors.black87),
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null || typingIndicator)
                      _buildSubtitle(context, isDark),
                  ],
                ),
              ),
            ),
            ...?actions,
          ],
        ),
      ),
    );
  }

  Widget _buildGradientAppBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4568DC),
            Color(0xFF0083B0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(0),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              if (leading != null)
                leading!
              else if (showBackButton)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? 'Chat',
                        style: titleStyle ??
                            const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null || typingIndicator)
                        typingIndicator
                            ? _buildTypingIndicator(Colors.white70)
                            : Text(
                                subtitle!,
                                style: subtitleStyle ??
                                    const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                    ],
                  ),
                ),
              ),
              ...?actions,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final defaultTextColor =
        textColor ?? (isDark ? Colors.white : Colors.black87);

    return SafeArea(
      child: Row(
        children: [
          if (leading != null)
            leading!
          else if (showBackButton)
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: defaultTextColor,
                size: 18,
              ),
              visualDensity: VisualDensity.compact,
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            ),
          Expanded(
            child: Center(
              child: Text(
                title ?? 'Chat',
                style: titleStyle ??
                    TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: defaultTextColor,
                      letterSpacing: 0.3,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(width: (actions?.isNotEmpty ?? false) ? 0 : 48),
          ...?actions,
        ],
      ),
    );
  }

  Widget _buildAvatarAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final defaultTextColor =
        textColor ?? (isDark ? Colors.white : Colors.black87);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          children: [
            if (leading != null)
              leading!
            else if (showBackButton)
              _buildBackButton(context, isDark),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(
                        20), // Replaced .withOpacity(0.08) with .withAlpha(20)
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: avatarImage,
                    radius: 20,
                    backgroundColor:
                        isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    child: avatarImage == null
                        ? Icon(Icons.person,
                            color: isDark
                                ? Colors.grey.shade300
                                : Colors.grey.shade600)
                        : null,
                  ),
                  if (online == true)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? Colors.grey.shade900 : Colors.white,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? 'Chat',
                    style: titleStyle ??
                        TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: defaultTextColor,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null || typingIndicator || online != null)
                    _buildConnectionStatus(context, isDark),
                ],
              ),
            ),
            ...?actions,
          ],
        ),
      ),
    );
  }

  // New modern design with a cleaner look
  Widget _buildModernAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            if (leading != null)
              leading!
            else if (showBackButton)
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: (textColor ?? theme.colorScheme.primary).withAlpha(
                      25), // Replaced .withOpacity(0.1) with .withAlpha(25)
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: textColor ?? theme.colorScheme.primary,
                    size: 20,
                  ),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            if (avatarImage != null) ...[
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(
                              25), // Replaced .withOpacity(0.1) with .withAlpha(25)
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundImage: avatarImage,
                      radius: 18,
                      backgroundColor:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      child: avatarImage == null
                          ? Icon(Icons.person,
                              size: 18,
                              color: isDark
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade600)
                          : null,
                    ),
                  ),
                  if (online == true)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? Colors.grey.shade900 : Colors.white,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? 'Chat',
                    style: titleStyle ??
                        TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: 0.2,
                          color: textColor ??
                              (isDark ? Colors.white : Colors.black87),
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null ||
                      typingIndicator ||
                      online != null ||
                      lastSeen != null)
                    _buildConnectionStatus(context, isDark),
                ],
              ),
            ),
            ...?actions,
          ],
        ),
      ),
    );
  }

// Professional business-style app bar
  Widget _buildBusinessAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final businessColor =
        textColor ?? (isDark ? Colors.white : Colors.grey.shade800);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            if (leading != null)
              leading!
            else if (showBackButton)
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: businessColor,
                  size: 20,
                ),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              ),
            if (avatarImage != null) ...[
              CircleAvatar(
                backgroundImage: avatarImage,
                radius: 18,
                backgroundColor:
                    isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                child: avatarImage == null
                    ? Icon(Icons.person,
                        size: 16,
                        color: isDark
                            ? Colors.grey.shade300
                            : Colors.grey.shade600)
                    : null,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? 'Chat',
                    style: titleStyle ??
                        TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: businessColor,
                          letterSpacing: 0.2,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null || typingIndicator)
                    typingIndicator
                        ? _buildTypingIndicator(businessColor.withAlpha(
                            153)) // Replaced .withOpacity(0.6) with .withAlpha(153)
                        : Text(
                            subtitle!,
                            style: subtitleStyle ??
                                TextStyle(
                                  fontSize: 12,
                                  color: businessColor.withAlpha(
                                      153), // Replaced .withOpacity(0.6) with .withAlpha(153)
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                ],
              ),
            ),
            ...?actions,
          ],
        ),
      ),
    );
  }

  // Professional sleek design with premium feel
  Widget _buildProfessionalAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultBackgroundColor =
        isDark ? Color(0xFF1F1F1F) : Color(0xFFFAFAFA);
    final bgColor = backgroundColor ?? defaultBackgroundColor;

    final defaultTextColor = isDark ? Colors.white : Color(0xFF2D3748);
    final txtColor = textColor ?? defaultTextColor;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            bottom: BorderSide(
              color: isDark
                  ? Colors.grey.shade800.withAlpha(
                      153) // Replaced .withOpacity(0.6) with .withAlpha(153)
                  : Colors.grey.shade200,
              width: 1.0,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            if (leading != null)
              leading!
            else if (showBackButton)
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: txtColor,
                    size: 28,
                  ),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                ),
              ),
            if (avatarImage != null) ...[
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(
                              15), // Replaced .withOpacity(0.06) with .withAlpha(15)
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundImage: avatarImage,
                      radius: 20,
                      backgroundColor:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    ),
                  ),
                  if (online == true)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green.shade500,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: bgColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title ?? 'Chat',
                          style: titleStyle ??
                              TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: 0.1,
                                color: txtColor,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (subtitle != null ||
                      typingIndicator ||
                      online != null ||
                      lastSeen != null)
                    _buildConnectionStatus(
                        context,
                        isDark,
                        txtColor.withAlpha(
                            153)), // Replaced .withOpacity(0.6) with .withAlpha(153)
                ],
              ),
            ),
            ...?actions,
          ],
        ),
      ),
    );
  }

  // Minimal design with clean lines
  Widget _buildMinimalAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final minimalColor = textColor ?? (isDark ? Colors.white : Colors.black87);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (leading != null)
                  leading!
                else if (showBackButton)
                  GestureDetector(
                    onTap: onBackPressed ?? () => Navigator.pop(context),
                    child: Container(
                      margin: const EdgeInsets.only(right: 14),
                      child: Icon(
                        Icons.arrow_back,
                        color: minimalColor,
                        size: 20,
                      ),
                    ),
                  ),
                if (avatarImage != null) ...[
                  CircleAvatar(
                    backgroundImage: avatarImage,
                    radius: 16,
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 10),
                ],
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? 'Chat',
                      style: titleStyle ??
                          TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: minimalColor,
                          ),
                    ),
                    if (subtitle != null || typingIndicator || online != null)
                      typingIndicator
                          ? _buildTypingIndicator(minimalColor.withAlpha(
                              153)) // Replaced .withOpacity(0.6) with .withAlpha(153)
                          : Text(
                              online == true ? 'Online' : subtitle ?? '',
                              style: subtitleStyle ??
                                  TextStyle(
                                    fontSize: 12,
                                    color: minimalColor.withAlpha(
                                        153), // Replaced .withOpacity(0.6) with .withAlpha(153)
                                  ),
                            ),
                  ],
                ),
              ],
            ),
            Row(
              children: actions ?? [],
            ),
          ],
        ),
      ),
    );
  }

  // iOS style app bar with clean look
  Widget _buildIOSStyleAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = backgroundColor ?? (isDark ? Colors.black : Colors.white);
    final iosTextColor = textColor ?? (isDark ? Colors.white : Colors.black);
    final subtitleCol = isDark ? Colors.blue : Colors.blue;

    return SafeArea(
      child: Container(
        color: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (leading != null)
                  leading!
                else if (showBackButton)
                  TextButton.icon(
                    onPressed: onBackPressed ?? () => Navigator.pop(context),
                    icon: Icon(
                      Icons.chevron_left,
                      color: subtitleCol,
                      size: 24,
                    ),
                    label: Text(
                      'Back',
                      style: TextStyle(
                        color: subtitleCol,
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
              ],
            ),
            if (avatarImage != null || title != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (avatarImage != null) ...[
                        CircleAvatar(
                          backgroundImage: avatarImage,
                          radius: 16,
                        ),
                        const SizedBox(height: 2),
                      ],
                      Text(
                        title ?? 'Chat',
                        style: titleStyle ??
                            TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: iosTextColor,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null || typingIndicator || online != null)
                        typingIndicator
                            ? _buildTypingIndicator(subtitleCol)
                            : Text(
                                online == true ? 'Online' : subtitle ?? '',
                                style: subtitleStyle ??
                                    TextStyle(
                                      fontSize: 12,
                                      color: subtitleCol,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                    ],
                  ),
                ),
              ),
            Row(
              children: actions ?? [],
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Widget _buildBackButton(BuildContext context, bool isDark) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: textColor ?? (isDark ? Colors.white : Colors.black87),
      ),
      onPressed: onBackPressed ?? () => Navigator.pop(context),
    );
  }

  Widget _buildSubtitle(BuildContext context, bool isDark) {
    if (typingIndicator) {
      return _buildTypingIndicator((textColor ??
              (isDark ? Colors.white : Colors.black87))
          .withAlpha(178)); // Replaced .withOpacity(0.7) with .withAlpha(178)
    }

    return Text(
      subtitle!,
      style: subtitleStyle ??
          TextStyle(
            fontSize: 12,
            color: (textColor ?? (isDark ? Colors.white : Colors.black87))
                .withAlpha(
                    178), // Replaced .withOpacity(0.7) with .withAlpha(178)
          ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildConnectionStatus(BuildContext context, bool isDark,
      [Color? customColor]) {
    final color = customColor ??
        (textColor ?? (isDark ? Colors.white : Colors.black87))
            .withAlpha(178); // Replaced .withOpacity(0.7) with .withAlpha(178)

    if (typingIndicator) {
      return _buildTypingIndicator(color);
    }

    if (online == true) {
      return Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4),
          Text(
            'Online',
            style: subtitleStyle ??
                TextStyle(
                  fontSize: 12,
                  color: color,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }

    if (online == false && lastSeen != null) {
      return Text(
        'Last seen $lastSeen',
        style: subtitleStyle ??
            TextStyle(
              fontSize: 12,
              color: color,
            ),
        overflow: TextOverflow.ellipsis,
      );
    }

    if (subtitle != null) {
      return Text(
        subtitle!,
        style: subtitleStyle ??
            TextStyle(
              fontSize: 12,
              color: color,
            ),
        overflow: TextOverflow.ellipsis,
      );
    }

    return SizedBox.shrink();
  }

  Widget _buildTypingIndicator(Color color) {
    return Row(
      children: [
        Text(
          'typing',
          style: TextStyle(
            fontSize: 12,
            color: color,
          ),
        ),
        SizedBox(width: 4),
        _DotLoadingIndicator(color: color),
      ],
    );
  }
}

// Animated typing indicator with dots
class _DotLoadingIndicator extends StatefulWidget {
  final Color color;

  const _DotLoadingIndicator({required this.color});

  @override
  _DotLoadingIndicatorState createState() => _DotLoadingIndicatorState();
}

class _DotLoadingIndicatorState extends State<_DotLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.3;
            final sinValue =
                sin((_controller.value * 2 * 3.14159) - (delay * 3.14159));
            final opacity = (sinValue + 1) / 2;

            return Padding(
              padding: EdgeInsets.only(right: index < 2 ? 3 : 0),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

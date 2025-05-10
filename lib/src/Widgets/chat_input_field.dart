import 'package:flutter/material.dart';
import '../models/chat_types.dart';

/// A widget that provides an input field for chatting with multiple button options.
///
/// This widget allows the user to input text, send messages, and optionally include buttons
/// for attachment and voice input, with various customization options.
class ChatInputField extends StatefulWidget {
  /// Controller for managing the text input.
  final TextEditingController controller;

  /// A node that controls the focus of this input field.
  final FocusNode? focusNode;

  /// Defines the input type behavior of the field.
  final InputFieldType inputType;

  /// Hint text to display when the input field is empty.
  final String? hintText;

  /// Callback function to handle sending a message.
  final Function(String) onSend;

  /// Optional custom widget for the send button.
  final Widget? sendButtonWidget;

  /// Optional custom widget for the attachment button.
  final Widget? attachmentButtonWidget;

  /// Optional custom widget for the voice button.
  final Widget? voiceButtonWidget;

  /// Function to be called when the attachment button is pressed.
  final Function()? onAttachmentPressed;

  /// Function to be called when the voice button is pressed.
  final Function()? onVoicePressed;

  /// Decoration for the input field container.
  final BoxDecoration? decoration;

  /// Background color of the input field.
  final Color? backgroundColor;

  /// Padding for the input field.
  final EdgeInsetsGeometry? padding;

  /// Margin around the input field.
  final EdgeInsetsGeometry? margin;

  /// Whether the attachment button should be shown.
  final bool showAttachmentButton;

  /// Whether the voice button should be shown.
  final bool showVoiceButton;

  /// Accent color used in the input field.
  final Color? accentColor;

  /// Duration for animation effects.
  final Duration animationDuration;

  /// Curve used for animation.
  final Curve animationCurve;

  /// Creates a [ChatInputField] with the given properties.
  const ChatInputField({
    super.key,
    required this.controller,
    this.focusNode,
    this.inputType = InputFieldType.defaultInput,
    this.hintText = "Type a message",
    required this.onSend,
    this.sendButtonWidget,
    this.attachmentButtonWidget,
    this.voiceButtonWidget,
    this.onAttachmentPressed,
    this.onVoicePressed,
    this.decoration,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.showAttachmentButton = false,
    this.showVoiceButton = false,
    this.accentColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
  }); // Correctly passing the key to the super class

  @override
  ChatInputFieldState createState() => ChatInputFieldState();
}

/// The state class for the [ChatInputField] widget.
///
/// This class holds the state for the [ChatInputField] widget. It manages the state
/// of the input field, including text input, attachment, and voice input actions.
class ChatInputFieldState extends State<ChatInputField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    widget.controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final bool isComposing = widget.controller.text.isNotEmpty;
    if (isComposing != _isComposing) {
      setState(() {
        _isComposing = isComposing;
      });
      if (isComposing) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor =
        widget.accentColor ?? Theme.of(context).primaryColor;

    switch (widget.inputType) {
      case InputFieldType.defaultInput:
        return _buildDefaultInput(primaryColor);
      case InputFieldType.roundedInput:
        return _buildRoundedInput(primaryColor);
      case InputFieldType.attachmentInput:
        return _buildAttachmentInput(primaryColor);
      case InputFieldType.voiceInput:
        return _buildVoiceInput(primaryColor);
    }
  }

  Widget _buildDefaultInput(Color primaryColor) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 8),
      margin: widget.margin ??
          const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: widget.decoration ??
          BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 4,
                color: Color.fromARGB(
                    (0.05 * 255).toInt(), 0, 0, 0), // Replacing .withOpacity()
              ),
            ],
          ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return ScaleTransition(
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve: widget.animationCurve,
                ),
                child: child,
              );
            },
            child: InkWell(
              onTap: () {
                if (widget.controller.text.trim().isNotEmpty) {
                  widget.onSend(widget.controller.text.trim());
                  widget.controller.clear();
                }
              },
              customBorder: const CircleBorder(),
              child: widget.sendButtonWidget ??
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.send_rounded,
                      color: primaryColor,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedInput(Color primaryColor) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      margin: widget.margin ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: widget.decoration ??
          BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 3),
                blurRadius: 8,
                color: Color.fromARGB(
                    (0.08 * 255).toInt(), 0, 0, 0), // Replaced with RGBA
              ),
            ],
          ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return ScaleTransition(
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve: widget.animationCurve,
                ),
                child: child,
              );
            },
            child: GestureDetector(
              onTap: () {
                if (widget.controller.text.trim().isNotEmpty) {
                  widget.onSend(widget.controller.text.trim());
                  widget.controller.clear();
                }
              },
              child: widget.sendButtonWidget ??
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          primaryColor,
                          Color.fromARGB(
                            (0.8 * 255).toInt(), // Replaced with RGBA
                            primaryColor.r.toInt(),
                            primaryColor.g.toInt(),
                            primaryColor.b.toInt(),
                          ),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentInput(Color primaryColor) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12),
      margin: widget.margin ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: widget.decoration ??
          BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 6,
                color: Color.fromARGB(
                    (0.06 * 255).toInt(), 0, 0, 0), // Replaced with RGBA
              ),
            ],
          ),
      child: Row(
        children: [
          if (widget.showAttachmentButton)
            GestureDetector(
              onTap: widget.onAttachmentPressed,
              child: widget.attachmentButtonWidget ??
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade100,
                    ),
                    child: Icon(
                      Icons.add_circle_outline_rounded,
                      color: primaryColor,
                      size: 22,
                    ),
                  ),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return ScaleTransition(
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve: widget.animationCurve,
                ),
                child: child,
              );
            },
            child: GestureDetector(
              onTap: () {
                if (widget.controller.text.trim().isNotEmpty) {
                  widget.onSend(widget.controller.text.trim());
                  widget.controller.clear();
                }
              },
              child: widget.sendButtonWidget ??
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceInput(Color primaryColor) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12),
      margin: widget.margin ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: widget.decoration ??
          BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.grey.shade50,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 8,
                color: Color.fromARGB(
                    (0.07 * 255).toInt(), 0, 0, 0), // Replaced with RGBA
              ),
            ],
          ),
      child: Row(
        children: [
          if (widget.showAttachmentButton)
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: widget.onAttachmentPressed,
                child: widget.attachmentButtonWidget ??
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.attach_file_rounded,
                        color: Colors.grey.shade600,
                        size: 22,
                      ),
                    ),
              ),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: widget.controller.text.isEmpty && widget.showVoiceButton
                ? Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: widget.onVoicePressed,
                      child: widget.voiceButtonWidget ??
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(
                                (0.1 * 255).toInt(), // Replaced with RGBA
                                primaryColor.r.toInt(),
                                primaryColor.g.toInt(),
                                primaryColor.b.toInt(),
                              ),
                            ),
                            child: Icon(
                              Icons.mic_rounded,
                              color: primaryColor,
                              size: 24,
                            ),
                          ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      if (widget.controller.text.trim().isNotEmpty) {
                        widget.onSend(widget.controller.text.trim());
                        widget.controller.clear();
                      }
                    },
                    child: widget.sendButtonWidget ??
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorTween(
                                  begin: Colors.grey.shade300,
                                  end: primaryColor,
                                ).evaluate(_animationController),
                              ),
                              child: Icon(
                                Icons.send_rounded,
                                color: ColorTween(
                                  begin: Colors.grey.shade600,
                                  end: Colors.white,
                                ).evaluate(_animationController),
                                size: 20,
                              ),
                            );
                          },
                        ),
                  ),
          ),
        ],
      ),
    );
  }
}

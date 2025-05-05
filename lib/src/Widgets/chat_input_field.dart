import 'package:flutter/material.dart';
import '../models/chat_types.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final InputFieldType inputType;
  final String? hintText;
  final Function(String) onSend;
  final Widget? sendButtonWidget;
  final Widget? attachmentButtonWidget;
  final Widget? voiceButtonWidget;
  final Function()? onAttachmentPressed;
  final Function()? onVoicePressed;
  final BoxDecoration? decoration;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showAttachmentButton;
  final bool showVoiceButton;
  final Color? accentColor;
  final Duration animationDuration;
  final Curve animationCurve;

  const ChatInputField({
    Key? key,
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
  }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField>
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
                color: Colors.black.withOpacity(0.05),
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
      padding: widget.padding ??
          const EdgeInsets.symmetric(
            horizontal: 16,
          ),
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
                color: Colors.black.withOpacity(0.08),
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
                          primaryColor.withOpacity(0.8),
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
      padding: widget.padding ??
          const EdgeInsets.symmetric(
            horizontal: 12,
          ),
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
                color: Colors.black.withOpacity(0.06),
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
      padding: widget.padding ??
          const EdgeInsets.symmetric(
            horizontal: 12,
          ),
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
                color: Colors.black.withOpacity(0.07),
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
                              color: primaryColor.withOpacity(0.1),
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

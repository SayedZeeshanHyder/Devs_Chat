import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TapAndLongPressGestureRecognizer extends OneSequenceGestureRecognizer {
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  static const Duration _longPressTimeout = Duration(milliseconds: 500);

  PointerDownEvent? _down;
  Timer? _longPressTimer;

  TapAndLongPressGestureRecognizer({
    this.onTap,
    this.onLongPress,
    Object? debugOwner,
  }) : super(debugOwner: debugOwner);

  @override
  void addPointer(PointerDownEvent event) {
    if (onTap != null || onLongPress != null) {
      startTrackingPointer(event.pointer, event.transform);
      _down = event;
      if (onLongPress != null) {
        _longPressTimer?.cancel();
        _longPressTimer = Timer(_longPressTimeout, () => _handleLongPress());
      }
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerUpEvent) {
      _longPressTimer?.cancel();
      if (onTap != null && _down != null) {
        final Offset upOffset = event.position;
        final Offset downOffset = _down!.position;

        final double deltaX = upOffset.dx - downOffset.dx;
        final double deltaY = upOffset.dy - downOffset.dy;
        final double distance = sqrt(deltaX * deltaX + deltaY * deltaY);

        if (distance < kTouchSlop) {
          onTap!();
        }
      }
      _reset();
    } else if (event is PointerMoveEvent) {
      final Offset moveOffset = event.position;
      final Offset downOffset = _down!.position;

      final double deltaX = moveOffset.dx - downOffset.dx;
      final double deltaY = moveOffset.dy - downOffset.dy;
      final double distance = sqrt(deltaX * deltaX + deltaY * deltaY);

      if (distance > kTouchSlop) {
        _longPressTimer?.cancel();
      }
    } else if (event is PointerCancelEvent) {
      _reset();
    }
  }

  void _handleLongPress() {
    if (onLongPress != null && _down != null) {
      onLongPress!();
    }
    _reset();
  }

  void _reset() {
    _longPressTimer?.cancel();
    _longPressTimer = null;
    _down = null;
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    _reset();
  }

  @override
  void dispose() {
    _reset();
    super.dispose();
  }

  @override
  String get debugDescription => 'tap and long press';
}

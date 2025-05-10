import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';

/// A custom gesture recognizer that detects both tap and long press gestures.
///
/// This gesture recognizer allows you to handle both a simple tap and a long press gesture on a pointer.
/// You can specify custom callbacks for both gestures through the [onTap] and [onLongPress] properties.
class TapAndLongPressGestureRecognizer extends OneSequenceGestureRecognizer {
  /// A callback that is triggered when a tap gesture is recognized.
  ///
  /// This is called when the user taps the screen (a simple touch without holding).
  final GestureTapCallback? onTap;

  /// A callback that is triggered when a long press gesture is recognized.
  ///
  /// This is called when the user holds their touch on the screen for a certain duration.
  final GestureLongPressCallback? onLongPress;

  /// The duration after which the long press gesture is triggered.
  ///
  /// If the user holds their touch for at least this duration, a long press will be detected.
  static const Duration _longPressTimeout = Duration(milliseconds: 500);

  PointerDownEvent? _down;
  Timer? _longPressTimer;

  /// Creates a [TapAndLongPressGestureRecognizer].
  ///
  /// You can optionally specify callbacks for the tap and long press gestures.
  ///
  /// The [onTap] callback is called when a tap is detected, and [onLongPress] is called when a long press is detected.
  ///
  /// The [debugOwner] parameter can be used for debugging purposes and is passed to the superclass.
  TapAndLongPressGestureRecognizer({
    this.onTap,
    this.onLongPress,
    super.debugOwner,
  });

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

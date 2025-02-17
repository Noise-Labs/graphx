import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../graphx.dart';

class InputConverter {
  final PointerManager pointer;
  final KeyboardManager keyboard;
  InputConverter(this.pointer, this.keyboard);

  /// mouse stuffs.
  void pointerEnter(PointerEnterEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.enter,
      rawEvent: event,
    ));
  }

  void pointerExit(PointerExitEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.exit,
      rawEvent: event,
    ));
  }

  void pointerHover(PointerHoverEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.hover,
      rawEvent: event,
    ));
  }

  /// touchable stuffs.
  void pointerSignal(PointerSignalEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.scroll,
      rawEvent: event as PointerScrollEvent,
    ));
  }

  void pointerPanZoomStart(PointerPanZoomStartEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.zoomPan,
      rawEvent: event,
    ));
  }

  void pointerPanZoomUpdate(PointerPanZoomUpdateEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.zoomPan,
      rawEvent: event,
    ));
  }

  void pointerPanZoomEnd(PointerPanZoomEndEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.zoomPan,
      rawEvent: event,
    ));
  }

  void pointerMove(PointerMoveEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.move,
      rawEvent: event,
    ));
  }

  void pointerCancel(PointerCancelEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.cancel,
      rawEvent: event,
    ));
  }

  void pointerUp(PointerUpEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.up,
      rawEvent: event,
    ));
  }

  void pointerDown(PointerDownEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.down,
      rawEvent: event,
    ));
  }

  void handleKey(RawKeyEvent event) {
    final isDown = event is RawKeyDownEvent;
    keyboard.$process(KeyboardEventData(
      type: isDown ? KeyEventType.down : KeyEventType.up,
      rawEvent: event,
    ));
  }
}

import 'package:flutter/gestures.dart';
import '../../graphx.dart';

/// over, out are mouse
enum PointerEventType {
  zoomPan,
  scroll,
  cancel,
  move,
  up,
  down,
  enter,
  exit,
  hover,
}

enum PointerZoomPanType { start, update, end, none }

class PointerEventData {
  final double stageX;
  final double stageY;
  final PointerEventType type;
  final PointerEvent rawEvent;

  /// local position in DisplayObject
  late GPoint localPosition;

  double get localX => localPosition.x;

  double get localY => localPosition.y;

  /// 300 milliseconds for double click
  static int doubleClickTime = 300;

  PointerEventData({required this.type, required this.rawEvent})
      : stageX = rawEvent.localPosition.dx,
        stageY = rawEvent.localPosition.dy {
    localPosition = GPoint(stageX, stageY);
  }

  int get time => rawEvent.timeStamp.inMilliseconds;

  Offset? get scrollDelta {
    if (rawEvent is PointerScrollEvent) {
      return (rawEvent as PointerScrollEvent).scrollDelta;
    } else if (rawEvent is PointerPanZoomUpdateEvent) {
      // TODO: temporal workaround for mouse wheel compatibility.
      // will be removed in next version and change "onScroll" for "onSignal"
      // to keep Flutter's compatibility.
      return (rawEvent as PointerPanZoomUpdateEvent).localPanDelta;
    }
    return null;
  }

  PointerZoomPanType get zoomPanEventType {
    if (rawEvent is PointerPanZoomStartEvent) {
      return PointerZoomPanType.start;
    } else if (rawEvent is PointerPanZoomUpdateEvent) {
      return PointerZoomPanType.update;
    } else if (rawEvent is PointerPanZoomEndEvent) {
      return PointerZoomPanType.end;
    }
    return PointerZoomPanType.none;
  }

  GPoint get windowPosition => GPoint.fromNative(rawEvent.original!.position);

  GPoint get stagePosition => GPoint.fromNative(rawEvent.localPosition);

//  Offset get position => rawEvent.localPosition;

  @override
  String toString() {
    return 'PointerEventData{'
        'type: $type, '
        'stageX: $stageX, '
        'stageY: $stageY, '
        'localX: $localX, '
        'localY: $localY'
        '}';
  }

  /// new properties.
  /// TODO: decide how to name mouse/pointer events.
  GDisplayObject? target;
  GDisplayObject? dispatcher;

  bool captured = false;
  bool mouseOut = false;

  PointerEventData clone(
    GDisplayObject target,
    GDisplayObject dispatcher,
    PointerEventType type,
  ) {
    var i = PointerEventData(type: type, rawEvent: rawEvent);
    i.target = target;
    i.dispatcher = dispatcher;
    i.captured = captured;
    return i;
  }
}

//// MOUSE INPUT DATA.
enum MouseInputType {
  over,
  out,
  move,
  down,
  exit,
  enter,
  up,
  click,
  still,
  wheel,
  zoomPan,

  /// check button directly with: isPrimaryDown, isSecondaryDown...
//  rightDown,
//  rightUp,
//  rightClick,
  unknown
}

class MouseInputData {
  static int doubleClickTime = 250;

  bool captured = false;

  @override
  String toString() {
    return 'MouseInputData{'
        'captured: $captured, '
        'target: $target, '
        'dispatcher: $dispatcher, '
        'type: $type, '
        'buttonDown: $buttonDown, '
        'mouseOut: $mouseOut, '
        'time: $time, '
        'buttonsFlags: $buttonsFlags, '
        'localPosition: $localPosition, '
        'stagePosition: $_stagePosition, '
        'scrollDelta: $scrollDelta}';
  }

  /// display objects
  GDisplayObject? target;
  GDisplayObject dispatcher;
  MouseInputType type;
  bool buttonDown = false;
  bool mouseOut = false;
  double time = 0;
  PointerEventData? rawEvent;

  /// defines which button is pressed...
  int? buttonsFlags;

  bool get isSecondaryDown =>
      buttonsFlags! & kSecondaryButton == kSecondaryButton;

  bool get isPrimaryDown => buttonsFlags! & kPrimaryButton == kPrimaryButton;

  bool get isTertiaryDown => buttonsFlags! & 0x04 == 0x04;

  GPoint get stagePosition => _stagePosition;
  final GPoint _stagePosition = GPoint();
  GPoint localPosition = GPoint();
  GPoint scrollDelta = GPoint();
  static final GPoint _localDelta = GPoint();

  double get localX => localPosition.x;

  double get localY => localPosition.y;

  double get windowX => rawEvent?.rawEvent.original?.position.dx ?? 0;

  double get windowY => rawEvent?.rawEvent.original?.position.dy ?? 0;

  double get stageX => _stagePosition.x;

  double get stageY => _stagePosition.y;

  GPoint get localDelta {
    final d = rawEvent?.rawEvent.localDelta;
    if (d == null) {
      return _localDelta.setEmpty();
    }
    return _localDelta.setTo(d.dx, d.dy);
  }

  static int uniqueId = 0;
  late int uid;
  MouseInputData({this.target, required this.dispatcher, required this.type});

  MouseInputData clone(
      GDisplayObject target, GDisplayObject dispatcher, MouseInputType type) {
    var input = MouseInputData(
      target: target,
      dispatcher: dispatcher,
      type: type,
    );
    input.uid = uid;
    input.buttonDown = buttonDown;
    input.rawEvent = rawEvent;
    input.captured = captured;
    input.buttonsFlags = buttonsFlags;
    input.time = time;
    input._stagePosition.setTo(_stagePosition.x, _stagePosition.y);
    input.scrollDelta.setTo(scrollDelta.x, scrollDelta.y);
    input.localPosition.setTo(localPosition.x, localPosition.y);
    input.mouseOut = mouseOut;
    return input;
  }

  static MouseInputType fromNativeType(PointerEventType? nativeType) {
    if (nativeType == PointerEventType.down) {
      return MouseInputType.down;
    } else if (nativeType == PointerEventType.up) {
      return MouseInputType.up;
    } else if (nativeType == PointerEventType.hover ||
        nativeType == PointerEventType.move) {
      return MouseInputType.move;
    } else if (nativeType == PointerEventType.exit) {
      return MouseInputType.exit;
    } else if (nativeType == PointerEventType.scroll) {
      return MouseInputType.wheel;
    } else if (nativeType == PointerEventType.zoomPan) {
      return MouseInputType.zoomPan;
    }
    return MouseInputType.unknown;
  }
}

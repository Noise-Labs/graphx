/// --- EVENT SIGNAL

typedef EventSignalCallback<T> = void Function(T event);

class Signal {
  final _listenersOnce = <Function>[];
  final _listeners = <Function>[];
  int _iterDispatchers = 0;

  Signal();

  bool has(Function callback) {
    return _listeners.contains(callback) || _listenersOnce.contains(callback);
  }

  bool hasListeners() => _listeners.isNotEmpty || _listenersOnce.isNotEmpty;

  void add(Function callback) {
    if (callback == null || has(callback)) return;
    _listeners.add(callback);
  }

  void addOnce(Function callback) {
    if (callback == null || has(callback)) return;
    _listenersOnce.add(callback);
  }

  void remove(Function callback) {
    final idx = _listeners.indexOf(callback);
    if (idx > -1) {
      if (idx <= _iterDispatchers) _iterDispatchers--;
      _listeners.removeAt(idx);
    } else {
      _listenersOnce.remove(callback);
    }
  }

  void removeAll() {
    _listeners.clear();
    _listenersOnce.clear();
  }

  void dispatch() {
    final len = _listeners.length;
    for (_iterDispatchers = 0; _iterDispatchers < len; ++_iterDispatchers) {
      _listeners[_iterDispatchers]?.call();
    }
    final lenCount = _listenersOnce.length;
    for (var i = 0; i < lenCount; i++) {
      _listenersOnce.removeAt(0)?.call();
    }
  }

  void dispatchWithData(dynamic data) {
    final len = _listeners.length;
    for (_iterDispatchers = 0; _iterDispatchers < len; ++_iterDispatchers) {
      _listeners[_iterDispatchers]?.call(data);
    }
    final lenCount = _listenersOnce.length;
    for (var i = 0; i < lenCount; i++) {
      _listenersOnce.removeAt(i)?.call(data);
    }
  }
}

enum EventSignalConfKey {
  LongPressDuration,
  LongPressShakingDistance,
}

class EventSignal<T> {
  Map<EventSignalConfKey,Object> configure = {};
  EventSignal();
 factory   EventSignal.longPress(Duration duration,double distance) {
    var signal = EventSignal<T>();
    signal.configure[EventSignalConfKey.LongPressDuration] = duration;
    signal.configure[EventSignalConfKey.LongPressShakingDistance] = distance;
    return signal;
  }
  void call(EventSignalCallback<T> callback) {
    add(callback);
  }

  final _listenersOnce = <EventSignalCallback<T>>[];
  final _listeners = <EventSignalCallback<T>>[];
  int _iterDispatchers = 0;
  int _iterLen = 0;
  int id = -1;

  bool has(EventSignalCallback<T> callback) {
    return _listeners.contains(callback) || _listenersOnce.contains(callback);
  }

  bool hasListeners() => _listeners.isNotEmpty || _listenersOnce.isNotEmpty;

  void add(EventSignalCallback<T> callback) {
    if (callback == null || has(callback)) return;
    _listeners.add(callback);
  }

  void addOnce(EventSignalCallback<T> callback) {
    if (callback == null || _listeners.contains(callback)) return;
    _listenersOnce.add(callback);
  }

  void remove(EventSignalCallback<T> callback) {
    final idx = _listeners.indexOf(callback);
    if (idx > -1) {
      if (idx <= _iterDispatchers) _iterDispatchers--;
      --_iterLen;
      _listeners.removeAt(idx);
    } else {
      _listenersOnce.remove(callback);
    }
  }

  void removeAll() {
    _listeners.clear();
    _listenersOnce.clear();
  }

  void dispatch(T data) {
    _iterLen = _listeners.length;
    for (_iterDispatchers = 0;
        _iterDispatchers < _iterLen;
        ++_iterDispatchers) {
      _listeners[_iterDispatchers]?.call(data);
    }
    _iterLen = _listenersOnce.length;
    while (_iterLen > 0) {
      _listenersOnce.removeAt(0).call(data);
      _iterLen--;
    }
  }
}

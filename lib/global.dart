import 'dart:async';

enum GlobalEvent {
  SwitchPageClass,
  SwitchPageFruit,
}

StreamController<GlobalEvent> streamController = new StreamController();

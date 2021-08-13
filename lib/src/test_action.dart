import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

// ignore_for_file: public_member_api_docs

typedef FutureOrWidgetTesterCallback = FutureOr<void> Function(WidgetTester);

@immutable
class TestAction {
  TestAction(this.action, {this.name, this.settle = false, this.debugFunction});

  final FutureOrWidgetTesterCallback action;
  final String? name;
  final bool settle;

  final FutureOrWidgetTesterCallback? debugFunction;
}

class TesterActions {
  static TestAction pumpAndSettle() =>
      TestAction((tester) => tester.pumpAndSettle(), name: 'pumpAndSettle');

  static TestAction idle(int millis) => TestAction(
        (_) => Future.delayed(Duration(milliseconds: millis)),
        name: 'idle $millis millis',
      );

  static TestAction screenshot(String filename, Type app) => TestAction(
        (tester) => expectLater(find.byType(app), matchesGoldenFile(filename)),
        name: 'screenshot test on $filename',
      );
}


// ignore_for_file: lines_longer_than_80_chars
/*
WidgetTester.idle() - app goes idle

  Future<void> pump([Duration duration, EnginePhase phase = EnginePhase.sendSemanticsUpdate])
  Future<int> pumpAndSettle([Duration duration = const Duration(milliseconds: 100), EnginePhase phase = EnginePhase.sendSemanticsUpdate, Duration timeout = const Duration(minutes: 10)])
  Future<void> pumpBenchmark(Duration duration)
  Future<void> pumpFrames(Widget target, Duration maxDuration, [Duration interval = const Duration(milliseconds: 16, microseconds: 683)])
  Future<void> pumpWidget(Widget widget, [Duration duration, EnginePhase phase = EnginePhase.sendSemanticsUpdate])

Could put as extension to finder ?
T element<T extends Element>(Finder finder)
Iterable<T> elementList<T extends Element>(Finder finder)
T firstElement<T extends Element>(Finder finder)
T firstRenderObject<T extends RenderObject>(Finder finder)
T firstState<T extends State<StatefulWidget>>(Finder finder)
T firstWidget<T extends Widget>(Finder finder)
T renderObject<T extends RenderObject>(Finder finder)
Iterable<T> renderObjectList<T extends RenderObject>(Finder finder)
T state<T extends State<StatefulWidget>>(Finder finder)
Iterable<T> stateList<T extends State<StatefulWidget>>(Finder finder)
T widget<T extends Widget>(Finder finder)
Iterable<T> widgetList<T extends Widget>(Finder finder)

Offset getBottomLeft(Finder finder)
Offset getBottomRight(Finder finder)
Offset getCenter(Finder finder)
Rect getRect(Finder finder)
Size getSize(Finder finder)
Offset getTopLeft(Finder finder)
Offset getTopRight(Finder finder)

SemanticsNode getSemantics(Finder finder)
 */


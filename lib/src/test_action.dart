import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';


typedef MainFunction = void Function();

@immutable
class TestAction {
  final FutureOr<void> Function(WidgetTester) action;
  final String? name;
  final bool settle;

  TestAction(this.action, {this.name, this.settle = false});

  /// Run list of [actions] sequentially,
  /// awaiting for each action to compete before starting next action.
  static Future<void> runSequential(WidgetTester tester, MainFunction main,
      Iterable<TestAction> actions) async {

    print('Start app');
    main();
    await tester.pumpAndSettle();

    for (final testAction in actions) {
      if (testAction.name != null) {
        print("Running ${testAction.name}");
      }
      try {
        await testAction.action(tester);
      } catch (tf) {
        await idle(5000).action(tester);
        rethrow;
      }
      if(testAction.settle) {
        await tester.pumpAndSettle();
      }
    }
  }
}

class TestActions {
  final Iterable<TestAction> actions;

  TestActions(this.actions);


}

TestAction pumpAndSettle() => TestAction((tester) => tester.pumpAndSettle(), name: 'pumpAndSettle');

TestAction idle(int millis) => TestAction(
      (_) => Future.delayed(Duration(milliseconds: millis)),
      name: "idle $millis millis",
    );

TestAction screenshot(String filename, Type app) => TestAction(
    (tester) => expectLater(find.byType(app), matchesGoldenFile(filename)),
  name: 'screenshot test on $filename',
);

TestAction screenshoterScreenshot(String filename, Type app) => screenshot(filename, app);

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

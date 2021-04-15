import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import '../flutter_driver_helper.dart';

/// [TestWidget] represents single UI-element in Screen.
/// It has methods for interacting with given UI-element during testing.
/// These methods return [TestAction] for using in [runTestActions].
@immutable
class TestWidget {
  final String _name;
  final Finder _finder;
  final Finder _offstageFinder;

  static const DEFAULT_TIMEOUT = const Duration(milliseconds: 100);

  Finder get finder => _finder;

  Finder get finderSingle => _finder.last;

  TestWidget(dynamic valueKey)
      : _name = valueKey.toString(),
        _finder = find.byKey(_makeKey(valueKey)),
        _offstageFinder = find.byKey(_makeKey(valueKey), skipOffstage: false);

  static Key _makeKey(dynamic key) {
    if(key is Key) {
      return key;
    }

    if(key is String) {
      return ValueKey(key);
    }

    return ValueKey(key.toString());
  }

  //TODO: Move this into BaseScreen
  TestWidget.pageBack() :
        _name = 'pageBack',
        _finder = find.byTooltip('Back'),
        _offstageFinder = find.byTooltip('Back', skipOffstage: false);

  TestAction any() => throw UnimplementedError();
  TestAction hasText(String text, {Duration? timeout}) => TestAction(
      (tester) {
        expect(finderSingle, findsWidgets, reason: 'Finder exists');
        expect(find.descendant(of: finderSingle, matching: find.text(text), matchRoot: true), findsWidgets);
        },
    name: 'hasText ($text)',
  );

  TestAction textEndsWith(String s, {Duration? timeout}) => TestAction(
        (tester) => expect(find.descendant(of: finderSingle, matching: find.textContaining(RegExp(RegExp.escape(s) + '\$')), matchRoot: true), findsWidgets),
    name: 'textEndsWith ($s)',
  );

  TestAction textStartsWith(String s, {Duration? timeout}) =>  TestAction(
        (tester) => expect(find.descendant(of: finderSingle, matching: find.textContaining(RegExp('^' + RegExp.escape(s))), matchRoot: true), findsWidgets),
    name: 'textStartsWith ($s)',
  );

  TestAction textContains(String s, {Duration? timeout}) =>  TestAction(
        (tester) => expect(find.descendant(of: finderSingle, matching: find.textContaining(s), matchRoot: true), findsWidgets),
    name: 'textContains ($s)',
  );

  String getText() => throw UnimplementedError();

  @deprecated
  TestAction setText(String text) => enterText(text);

  TestAction scroll({
    double dx = 0,
    double dy = 0,
    Duration duration = const Duration(milliseconds: 300),
    int frequency = 60,
  }) => timedDrag(Offset(dx, dy), duration, frequency: frequency);

  TestAction waitFor({Duration? timeout}) => TestAction(
      (tester) async {
        await tester.pumpAndSettle(timeout ?? DEFAULT_TIMEOUT);
        //TODO: Make sure visible
        //Alternatively, manually split up pumpAndSettle with visible checks
        return;
      }
  );
  TestAction waitForAbsent({Duration? timeout}) => TestAction(
          (tester) async {
        await tester.pumpAndSettle(timeout ?? DEFAULT_TIMEOUT);
        //TODO: Make sure not visible
        //Alternatively, manually split up pumpAndSettle with visible checks
        return;
      }
  );

  @deprecated
  TestAction appendText(String text, {Duration? timeout}) => enterText(text);
  @deprecated
  TestAction scrollIntoView({double alignment = 0.0, Duration? timeout}) =>
    ensureVisible(settle: true);


  TestAction drag(Offset offset) => TestAction(
    (tester) => tester.drag(finderSingle, offset),
    name: 'drag $_name by $offset',
  );

  TestAction dragUntilVisible(Finder view, Offset moveStep, {
    int maxIteration = 50,
    Duration duration = const Duration(milliseconds: 50)
  }) => TestAction(
          (tester) {
  print('Finder evals under $_name');
  print(view);
  expect(view, findsOneWidget);
  expect(finder, findsNothing);
            return tester.dragUntilVisible(
                finder, view, moveStep, maxIteration: maxIteration,
                duration: duration);

          },
      name: 'drag $_name until visible',
    );

  TestAction ensureVisible({settle = true}) => TestAction(
      (tester) => tester.ensureVisible(_offstageFinder),
      name: 'make sure $_name visible in scroll',
      settle: settle,
  );

  TestAction enterText(String text) => TestAction(
      (tester) => tester.enterText(finderSingle, text),
      name: 'enter "$text" into $_name',
      settle: true,
  );

  TestAction fling(Offset offset, double speed) => TestAction(
      (tester) => tester.fling(finderSingle, offset, speed),
      name: 'fling $_name by $offset at $speed',
      settle: true,
  );

  TestAction longPress({settle = true}) => TestAction(
      (tester) => tester.longPress(finderSingle),
      name: 'long press on $_name',
      settle: settle,
  );

  TestAction press({settle = true}) => TestAction(
      (tester) => tester.press(finderSingle),
      name: 'press $_name',
      settle: settle,
  );

  TestAction scrollUntilVisible(double delta, {Finder? scrollable, int maxScrolls = 50, Duration duration = const Duration(milliseconds: 50)}) => TestAction(
        (tester) => tester.scrollUntilVisible(finder, delta, scrollable: scrollable, maxScrolls: maxScrolls, duration: duration),
    name: 'scroll $_name until visible',
  );

  TestAction showKeyboard({settle = true}) => TestAction(
      (tester) => tester.showKeyboard(finderSingle),
      name: 'show keyboard for $_name',
      settle: settle,
  );

  TestAction tap({settle = true}) => TestAction(
      (tester) => tester.tap(finderSingle),
      name: 'tap on $_name',
      settle: settle,
  );

  TestAction timedDrag(Offset offset, Duration duration, {frequency = 60}) => TestAction(
      (tester) => tester.timedDrag(finderSingle, offset, duration, frequency: frequency),
      name: 'timed drag on $_name delta $offset for $duration',
      settle: true,
  );
}

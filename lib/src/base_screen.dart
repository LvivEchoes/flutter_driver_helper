import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'test_action.dart';
import 'test_widget.dart';

// ignore_for_file: deprecated_member_use_from_same_package

/// Base page-object for accessing UI-elements.
/// (https://martinfowler.com/bliki/PageObject.html).
///
/// [pageBack] is AppBar's back button in Scaffold.
///
/// See README.md for example.
@deprecated
@immutable
abstract class BaseScreen {
  @protected
  DWidget dWidget(dynamic key) => DWidget(key);

  @protected
  DWidget dScrollItem(dynamic key, DWidget scrollable) =>
      DScrollItem(key, scrollable);

  DWidget get pageBack => DWidget.pageBack();
}

/// [DWidget] represents single UI-element in Screen.
/// It has methods for interacting with given UI-element during testing.
/// These methods return [TestAction] for using in [runTestActions].
@immutable
@deprecated
class DWidget {
  final TestWidget tw;

  DWidget(dynamic valueKey): tw = TestWidget(valueKey);

  DWidget.pageBack(): tw = TestWidget.pageBack();

  TestAction tap({Duration? timeout}) => tw.tap();

  TestAction waitFor({Duration? timeout}) => tw.waitFor(timeout: timeout);

  TestAction waitForAbsent({Duration? timeout}) => tw.waitForAbsent(timeout: timeout);

  TestAction hasText(String text, {Duration? timeout}) => tw.hasText(text);

  TestAction textEndsWith(String s, {Duration? timeout}) => tw.textEndsWith(s);

  TestAction textStartsWith(String s, {Duration? timeout}) => tw.textStartsWith(s);

  TestAction textContains(String s, {Duration? timeout}) => tw.textContains(s);

  TestAction setText(String text, {Duration? timeout}) => tw.setText(text);

  TestAction appendText(String text, {Duration? timeout}) => tw.appendText(text);

  TestAction scrollIntoView({double alignment = 0.0, Duration? timeout}) =>
      tw.scrollIntoView();

  TestAction scroll({
    double dx = 0,
    double dy = 0,
    Duration duration = const Duration(milliseconds: 300),
    int frequency = 60,
    Duration? timeout,
  }) => tw.scroll(dx: dx, dy: dy, duration: duration, frequency: frequency);

  Future<String> getText({Duration? timeout}) => Future.value("DEPRECATED");
}

/// [DScrollItem] represents item in scrollable widget.
/// It allows to scroll to given item in list.
///
/// See README.md for example.
class DScrollItem extends DWidget {
  final DWidget _scrollable;

  DScrollItem(
    dynamic valueKey,
    this._scrollable,
  ) : super(valueKey);

  TestAction scrollUntilVisible({
    double alignment = 0.0,
    double dxScroll = 0.0,
    double dyScroll = 0.0,
    Duration? timeout,
  }) => tw.dragUntilVisible(_scrollable.tw.finder, Offset(dxScroll, dyScroll));
}

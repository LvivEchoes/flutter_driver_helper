import 'package:meta/meta.dart';

@immutable
class TestAction {
  final Future<void> Function() action;
  final String name;

  TestAction(this.action, {this.name});
}

/// Run list of [actions] sequentially,
/// awaiting for each action to compete before starting next action.
Future<void> runTestActions(Iterable<TestAction> actions) async {
  for (final testAction in actions) {
    if (testAction.name != null) {
      print("Running ${testAction.name}");
    }
    await testAction.action();
  }
}

/// Just wait for some time.
TestAction idle(int millis) => TestAction(
      () => Future.delayed(Duration(milliseconds: millis)),
      name: "idle $millis millis",
    );

/// Create named group of steps.
TestAction step(
  String name,
  List<TestAction> actions,
) =>
    TestAction(
      () => runTestActions(actions),
      name: 'step "$name"',
    );

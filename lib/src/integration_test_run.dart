
import 'package:flutter_test/flutter_test.dart';
import 'test_action.dart';

typedef MainFunction = void Function();

class IntegrationTestRun {
  String description;
  //Future<void> Function(WidgetTester) callback;
  bool skip = false;
  Timeout? timeout;
  Duration? initialTimeout;
  bool semanticsEnabled;
  TestVariant<Object?> variant;
  dynamic tags;

  MainFunction mainApp;

  Iterable<TestAction> actions;

  IntegrationTestRun(this.description, this.mainApp,
      {this.timeout, this.initialTimeout,
        this.semanticsEnabled = true,
        this.variant = const DefaultTestVariant(),
        this.tags,
        required this.actions
      });

  void run([String? skip]) {
    if(skip != null) {
      print('Skipping test ($description) for ($skip)');
      testWidgets(description, (_) => Future.value(0), skip: true);
    } else {
      testWidgets(description, (tester) async {
        print('Start app');
        mainApp();
        await tester.pumpAndSettle();

        for (final testAction in actions) {
          if (testAction.name != null) {
            print("Running ${testAction.name}");
          }
          try {
            await testAction.action(tester);
          } catch (tf) {
            if(testAction.debugFunction != null) {
              await testAction.debugFunction!(tester);
            }
            rethrow;
          }
          if(testAction.settle) {
            await tester.pumpAndSettle();
          }
        }
      },
        timeout: timeout,
        initialTimeout: initialTimeout,
        semanticsEnabled: semanticsEnabled,
        tags: tags,
        variant: variant,
      );
    }
  }
}

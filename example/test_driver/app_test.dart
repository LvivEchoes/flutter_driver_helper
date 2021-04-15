import 'package:flutter_driver_helper/flutter_driver_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../lib/main.dart' as app;

import 'screens.dart';

void main() {
  final itwfb = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Counter App', () {
    final timeout = Timeout(Duration(minutes: 5));
    final screenshotsEnabled = false;

    final mainScreen = MainScreen();
    final secondScreen = SecondScreen();

    final screenshoter = Screenshoter(
      itwfb,
      "screenshots",
      enabled: screenshotsEnabled,
    );

    IntegrationTestRun('test one', app.main, timeout: timeout, actions: [
      mainScreen.result.hasText("summa = 0"),
      mainScreen.field_1.setText("12"),
      mainScreen.result.hasText("summa = 12"),
      mainScreen.result.textStartsWith("summ"),
      mainScreen.result.textEndsWith("= 12"),
      mainScreen.result.textContains("ma = 1"),
      mainScreen.field_2.tap(),
      screenshoter.screenshot("field_2_variants"),
      mainScreen.field2Variant(4).tap(),
      mainScreen.result.hasText("summa = 16"),
      TesterActions.idle(1000),
      mainScreen.buttonSnackbar.tap(),
      mainScreen.snackbarText.waitFor(),
      mainScreen.actionMake7.tap(),
      mainScreen.snackbarText.waitForAbsent(),
      mainScreen.result.hasText("summa = 19"),
      mainScreen.someText.waitForAbsent(),
      mainScreen.chSwitch.tap(),
      mainScreen.someText.waitFor(),
      mainScreen.chSwitch.tap(),
      mainScreen.someText.waitForAbsent(),
      mainScreen.result.hasText("summa = 19"),
      screenshoter.screenshot("summa_19"),
    ]).run();

    IntegrationTestRun('test two', app.main, timeout: timeout, actions: [
      mainScreen.result.hasText("summa = 0"),
      mainScreen.field_1.setText("3"),
      mainScreen.field_2.tap(),
      mainScreen.field2Variant(2).tap(),
      mainScreen.result.hasText("summa = 5"),
    ]).run();

    IntegrationTestRun('test three', app.main, timeout: timeout, actions: [
      mainScreen.time.waitForAbsent(),
      //TestAction(() => driver.requestData("select_time")),
      mainScreen.selectTime.tap(),
      mainScreen.time.waitFor(),
      mainScreen.time.hasText("TimeOfDay(12:28)"),
    ]).run('request data handler not translated');

    IntegrationTestRun('test four', app.main, timeout: timeout, actions: [
      mainScreen.secondScreen.tap(),
      secondScreen.item(42).waitForAbsent(),
      secondScreen.item(42).scrollUntilVisible(dyScroll: -300),
      secondScreen.item(42).waitFor(),
      secondScreen.pageBack.tap(),
    ]).run();
  });
}

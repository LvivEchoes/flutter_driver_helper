import 'dart:io';

// import 'package:integration_test/integration_test.dart';

import 'test_action.dart';

// ignore_for_file: public_member_api_docs

/// Utility class for making screenshots during integrations tests.
///
/// Screenshots are saved to dir "baseScreensDir/${current date-time}/".
/// Each screenshot's name is prefixed with it's index (may be disabled).
/// Directory is created automatically.
///
/// May be disabled with corresponding constructor param.
class Screenshoter {
  Screenshoter(
    this._driver,
    String baseScreensDir, {
    this.enabled = true,
    this.withIndices = true,
  }) : _screensDir = '$baseScreensDir/${DateTime.now()}' {
    if (!enabled) return;
    Directory(_screensDir).createSync(recursive: true);
  }

  // ignore: unused_field
  final dynamic _driver;
  final String _screensDir;
  final bool enabled;
  final bool withIndices;
  int _nextScreenId = 1;

  Future<void> saveScreen(String name) async {
    if (!enabled) return;
    final namePrefix = withIndices ? '${_nextScreenId++}_' : '';
    // ignore: unused_local_variable
    final path = '$_screensDir/$namePrefix$name.png';
    // _driver.takeScreenshot(path);
  }

  TestAction screenshot(String name) =>
      TestAction((_) => saveScreen(name), name: 'take screenshot $name');
}

import 'package:meta/meta.dart';

import 'test_widget.dart';

/// Base page-object for accessing UI-elements.
/// (https://martinfowler.com/bliki/PageObject.html).
///
/// [pageBack] is AppBar's back button in Scaffold.
///
/// See README.md for example.
@immutable
abstract class TestScreen {
  /// Helper function to create a [TestWidget] for a key
  @protected
  TestWidget tWidget(dynamic key) => TestWidget(key);

  // Could add for different widget types and split up TestWidget

  /// In a Scaffold, access the AppBar's back button
  TestWidget get pageBack => TestWidget.pageBack();
}

import 'package:flutter/foundation.dart';

// while debugging use this extension to pre populate the fields.
extension IfDebugging on String {
  String? get ifDebugging => kDebugMode ? this : null;
}

// useStream

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Stream<String> getDateTime() => Stream.periodic(
      const Duration(seconds: 1),
      (_) => DateTime.now().toIso8601String(),
    );

class Hooks1 extends HookWidget {
  const Hooks1({super.key});

  @override
  Widget build(BuildContext context) {
    // subscribe to the event
    final dateTime = useStream(getDateTime());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      // Use the stream
      body: Center(
        child: Text(dateTime.data ?? 'No Data'),
      ),
    );
  }
}

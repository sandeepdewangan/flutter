// useListenable
/*
 - ChangeNotifier: if something is a ChangeNotifier , you can subscribe to its changes.
 - ValueNotifier is a special type of class that extends Changenotifier, 
    which can hold a single value and notifies the widgets which are listening to it whenever its holding value gets change.
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CountDown extends ValueNotifier<int> {
  late StreamSubscription sub;

  CountDown({required int from}) : super(from) {
    sub = Stream.periodic(const Duration(seconds: 1), (value) => from - value)
        .takeWhile((value) => value >= 0)
        .listen((value) {
      this.value = value;
    });
  }
  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }
}

class Hooks4 extends HookWidget {
  const Hooks4({super.key});

  @override
  Widget build(BuildContext context) {
    final countDown = useMemoized(() => CountDown(from: 20));
    final notifier = useListenable(countDown);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      // Use the stream
      body: Center(
        child: Text(notifier.value.toString()),
      ),
    );
  }
}

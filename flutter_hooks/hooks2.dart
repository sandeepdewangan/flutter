// As we type in the text field the typed text is displayed.
// useTextEditingController, useState, useEffect
// useEffect: Useful for side-effects and optionally canceling them.
// useEffect is called synchronously on every build, unless keys is specified.
// In which case useEffect is called again only if any value inside keys as changed.

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Hooks2 extends HookWidget {
  const Hooks2({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    // whenever there is changes in controller grab that changes.
    final text = useState('');
    // grab the changes using useEffects
    // use effect should not rebuild. Thats why key (controller) is given as input.
    useEffect(
      () {
        controller.addListener(() {
          text.value = controller.text;
        });
        return null;
      },
      [controller],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      // Use the stream
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: controller,
            ),
            Text('You typed ${text.value}'),
          ],
        ),
      ),
    );
  }
}

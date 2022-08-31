import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const url = 'https://upload.wikimedia.org/wikipedia/commons/d/da/Taj-Mahal.jpg';
const imageHeight = 300.0;

class Hooks5 extends HookWidget {
  const Hooks5({super.key});

  @override
  Widget build(BuildContext context) {
    final opacity = useAnimationController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      // Use the stream
      body: const Center(
        child: Text('No Data'),
      ),
    );
  }
}

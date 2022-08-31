// useMemoized, useFuture
// useFuture returns future for us.
// It calls build function again and again.
// useMemoized -> create a caching mechanism.
// If there exists a cache of that object then it will give or get from the Future.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const url = 'https://upload.wikimedia.org/wikipedia/commons/d/da/Taj-Mahal.jpg';

class Hooks3 extends HookWidget {
  const Hooks3({super.key});

  @override
  Widget build(BuildContext context) {
    final future = useMemoized(() => NetworkAssetBundle(Uri.parse(url))
        .load(url)
        .then((data) => data.buffer.asUint8List())
        .then((data) => Image.memory(data)));
    // consumer
    final snapshot = useFuture(future);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      // Use the stream
      body: Center(
        child: Container(
          child: snapshot.data,
        ),
      ),
    );
  }
}

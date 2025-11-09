## Stream Notifier Provider

### State and Providers
`timer/ticker.dart`
```dart
class Ticker {
  const Ticker();

  //  Stream.periodic creates a stream that emits an event every given duration — here, every 1 second.
  // (x) is the event index, starting from 0 for the first emission, then 1, 2, 3, and so on.
  // The second argument (x) => ticks - x computes the value to emit each time.
  // The stream will naturally go on forever,
  // but .take(ticks) limits it to only emit ticks number of values.

  Stream<int> tick({required int ticks}) {
    return Stream.periodic(
      const Duration(seconds: 1),
      (x) => ticks - x - 1,
    ).take(ticks);
  }
}
```
`timer/timer_state.dart`
```dart
sealed class TimerState {
  final int duration;
  const TimerState(this.duration);
}

final class TimerInitial extends TimerState {
  const TimerInitial(super.duration);

  @override
  String toString() => 'TimerInitial(duration: $duration)';
}

final class TimerRunning extends TimerState {
  const TimerRunning(super.duration);

  @override
  String toString() => 'TimerRunning(duration: $duration)';
}

final class TimerPaused extends TimerState {
  const TimerPaused(super.duration);

  @override
  String toString() => 'TimerPaused(duration: $duration)';
}

final class TimerFinished extends TimerState {
  const TimerFinished() : super(0);

  @override
  String toString() => 'TimerFinished()';
}
```
`timer/timer_provider.dart`
```dart
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_notifier_riverpod/timer/ticker.dart';
import 'package:stream_notifier_riverpod/timer/timer_state.dart';

part 'timer_provider.g.dart';

@riverpod
class Timer extends _$Timer {
  final int _duration = 10;
  final Ticker _ticker = const Ticker();
  StreamSubscription<int>? _tickerSubscription;

  @override
  Stream<TimerState> build() {
    @override
    void dispose() {
      _tickerSubscription?.cancel();
    }

    return Stream.value(TimerInitial(_duration));
  }

  void startTimer() {
    state = AsyncData(TimerRunning(_duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick(ticks: _duration).listen((duration) {
      state = duration > 0
          ? AsyncData(TimerRunning(duration))
          : const AsyncData(TimerFinished());
    });
  }

  // The syntax (:int duration) means: match any TimerRunning
  // where there is an int duration field, and bind it to the local variable duration.

  void pauseTimer() {
    switch (state.value!) {
      case TimerRunning(:int duration):
        _tickerSubscription?.pause();
        state = AsyncData(TimerPaused(duration));
      case _:
    }
  }

  void resumeTimer() {
    switch (state.value!) {
      case TimerPaused(:int duration):
        _tickerSubscription?.resume();
        state = AsyncData(TimerRunning(duration));
      case _:
    }
  }

  void resetTimer() {
    _tickerSubscription?.cancel();
    state = AsyncData(TimerInitial(_duration));
  }
}
```
### Pages
`timer_page.dart`
```dart
class TimerPage extends ConsumerWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Stream")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
		            TimerValue(), 
			          SizedBox(height: 20), 
			          TimerActions()
			        ],
          ),
        ),
      ),
    );
  }
}
```
`timer_value.dart`
```dart
class TimerValue extends ConsumerWidget {
  const TimerValue({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    print(timerState);
    return timerState.maybeWhen(
      data: (value) => Text("${value.duration}"),
      orElse: () => const SizedBox.shrink(),
    );
  }
}
```
`timer_actions.dart`
```dart
class TimerActions extends ConsumerWidget {
  const TimerActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);

    if (timerState is! AsyncData) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        ...switch (timerState.value!) {
          TimerInitial() => [
            FloatingActionButton(
              onPressed: () {
                ref.read(timerProvider.notifier).startTimer();
              },
              child: const Icon(Icons.start),
            ),
          ],
          TimerRunning() => [
            FloatingActionButton(
              onPressed: () {
                ref.read(timerProvider.notifier).pauseTimer();
              },
              child: const Icon(Icons.pause),
            ),
            FloatingActionButton(
              onPressed: () {
                ref.read(timerProvider.notifier).resetTimer();
              },
              child: const Icon(Icons.replay),
            ),
          ],
          TimerPaused() => [
            FloatingActionButton(
              onPressed: () {
                ref.read(timerProvider.notifier).resumeTimer();
              },
              child: const Icon(Icons.play_arrow),
            ),
            FloatingActionButton(
              onPressed: () {
                ref.read(timerProvider.notifier).resetTimer();
              },
              child: const Icon(Icons.replay),
            ),
          ],
          TimerFinished() => [
            FloatingActionButton(
              onPressed: () {
                ref.read(timerProvider.notifier).resetTimer();
              },
              child: const Icon(Icons.replay),
            ),
          ],
        },
      ],
    );
  }
}
```

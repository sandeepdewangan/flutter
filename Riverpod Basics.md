# Riverpod Basics

### read()

Use `read` to the get the value of/in provider just once (one-time read)

### watch()

Use `watch` to the get the value of/in provider the first time and every time the value changes (see it like you're subscribing to the provider, so you get notified any time there's a change)

## listen()

`listen` is similar to `watch`. The main difference is the return type. `watch` returns the new value directly, `listen` returns a `void` but gives access to the new value and the old value with a callback (See examples below)

Global provider declaration which keep tracks of all the providers.

```dart
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

## 1. Provider

* Provider provides data to the widgets.

* It is a read only, cannot update the value inside of it.

    

**Declare**

```dart
final nameProvider = Provider<String>((ref) => "Sandeep Dewangan");
```

**Read - Option-01**

Entire widget will rebuilt.

In Stateless Widget

```dart
class MyView extends ConsumerWidget {  // <--- THIS

  @override
  Widget build(BuildContext context, WidgetRef ref) {     // <--- THIS
    final name = ref.watch(nameProvider);    // <--- THIS
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text(name),
          ],
        ),
      ),
    );
  }
}
```

**Read - Option-02**

Only wraped widget will rebuilt.

In Stateless/Statefull Widget

```dart
class MyView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer(builder: (context, ref, child) {     // <--- THIS
          final name = ref.watch(nameProvider);    // <--- THIS
          return Column(
            children: [
              Text(name),    
            ],
          );
        }),
      ),
    );
  }
}
```

**Read - Option-03**

In Statefull Widget

```dart
class MySignupView extends ConsumerStatefulWidget {     // <--- THIS
    @override
  ConsumerState<MySignupView> createState() => _MySignupViewState();
    // <--- THIS ConsumerState
}

class _MySignupViewState extends ConsumerState<MySignupView> {} 
// <--- THIS ConsumerState
```

## 2. State Provider

*StateProvider* is a provider that exposes a way to modify its state.

Declare

```dart
final nameProvider = StateProvider<String>((ref) => "Sandeep Dewangan");
```

Read / Update the state

```dart
ref.read(nameProvider.notifier).update((prvState) => newValue);
```

## 3. State Notifier and State Notifier Provider

For complex classes.

User model and StateNotifier Class

```dart
class User {
  final String name;
  final int age;

  const User({required this.name, required this.age});

  User copyWith({
    String? name,
    int? age,
  }) {
    return User(
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }
}

// We create class to update the above model using provider
class UserNotifier extends StateNotifier<User> {
  UserNotifier(super.state);

  void updateName(String n) {
    state = state.copyWith(name: n);
  }
}
```

Declare

```dart
final userProvider =
    StateNotifierProvider<UserNotifier, User>((ref) => UserNotifier());
```

Read / Update same as StateNotifier.

Widget tree should rebuit only when the value of name changes.

```dart
final username = ref.watch(userProvider.select((value) => value.name));
```

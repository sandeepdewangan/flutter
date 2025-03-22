# Riverpod
## Types of Providers (6)
1. Provider (Read Only)
2. StateProvider (Can update simple values)
3. ChangeNotifierProvider (Not used much)
4. StateNotifier and StateNotifierProvider (For updating complex values)
5. FutureProvider
6. StreamProvider

### I. Provider
Read only provider, we cant change its value.

Declaring and initializing the provider. 
```dart
final nameProvider = Provider<String>((ref) => 'Sandeep');	// STEP 02
void main() {
  runApp(
    const ProviderScope(	// STEP 01
      child: MyApp(),
    ),
  );
}
```
**There are two ways to access the provider.**
1. Using Consumer Widget
2. Using Consumer

**There are three ways to read.**
1. watch(): continuous reading. Use watch inside of build function.
2. read(): for one time call and can be used for calling functions.
3. select(): rebuild the entire tree only when specified property of a class changes.

***1. ConsumerWidget***
```dart
class HomePage extends ConsumerWidget { // Inherit consumer widget
  @override
  Widget build(BuildContext context, WidgetRef ref) {	// add ref
    final name = ref.watch(nameProvider);	// watch the data
    return Scaffold(
      appBar: AppBar(
        title: Text(name),	// display the data
      ),
```
***2. Consumer***
```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, child) { // Consumer
        final name = ref.watch(nameProvider);	// watch
        return Column(
          children: [
            Text(name),	
          ],
          ...
```
### II. StateProvider
* We can update the value.
* Used with very simple values like int, string etc.
```dart
// Initilize the provider
final  nameProvider  =  StateProvider<String?>((ref) =>  null);

.....
class HomePage extends ConsumerWidget {

  void onSubmit(WidgetRef ref, String value) {
  // notifier allows to manupulate with the state.
    ref.read(nameProvider.notifier).update(
        (state) => value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        final name = ref.watch(nameProvider) ?? '';
        return Column(
          children: [
            TextField(
              onSubmitted: (value) => onSubmit(ref, value),
            ),
            Text(name),
          ],
...
```
### III. StateNotifier and StateNotifierProvider
* Used with very complex values.

`main.dart`
```dart
// Initializing the provider
final userProvider = StateNotifierProvider<UserNotifier, User>(
  (ref) => UserNotifier(),
);
...
...
class HomePage extends ConsumerWidget {

  void onSubmit(WidgetRef ref, String value) {
    ref.read(userProvider.notifier).updateName(value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        final user = ref.watch(userProvider);
        return Column(
          children: [
            TextField(
              onSubmitted: (value) => onSubmit(ref, value),
            ),
            Text(user.name),
            Text(user.age.toString()),
          ],
   ....
```
`user.dart`
```dart
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class User {
  final String name;
  final int age;
  const User({
    required this.name,
    required this.age,
  });

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

class UserNotifier extends StateNotifier<User> {
  UserNotifier() :  super(const  User(name:  '', age:  0));

  void updateName(String n) {
    // updating the value
    // bez the class is immutable, we can create an instance of it 
    // and return to provider.
    //-----> state = User(name: n, age: state.age);
    // Problem
    // if the class is big contains alot of varibles this 
    // method will become more tedius.
    // Solution
    // User dart class generator, copywith method.
    state = state.copyWith(name: n);
  }
}
```
***select()***
The `select` function allows filtering unwanted rebuilds of a Widget by reading only the properties that we care about.
```dart
final username = ref.watch(userProvider.select((value) => value.name));
```
### IV. ChangeNotifierProvider
Using  `ChangeNotifierProvider`  is discouraged by Riverpod and exists primarily for an easy transition from  `package:provider`.

### V. FutureProvider
Used for async data.
FutureBuilder, `when()` provides with three main properties, data, error and loading.

`main.dart`
```dart
final fetchUserDataProvider = FutureProvider((ref) {
  const url = "https://jsonplaceholder.typicode.com/users/1";
  return http.get(Uri.parse(url)).then((res) => User.fromJson(res.body));
});
```
`home_page.dart`
```dart
@override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(fetchUserDataProvider).when(
        data: (data) {
          return Scaffold(
            body: Column(
              children: [Text(data.name)],
            ),
          );
        },
        error: (error, stackTrace) => Center(
              child: Text(
                error.toString(),
              ),
            ),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }
```
***Correctly calling the User Repository using provider***

`main.dart`
```dart
final fetchUserDataProvider = FutureProvider((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.fetchUserData();
});
```
`user.dart`
```dart

@immutable
class User {
  final String name;
  final String email;
  const User({
    required this.name,
    required this.email,
  });
}

// Used for providing the repo to the FutureProvider.
final userRepositoryProvider = Provider((ref) => UserRepository());

class UserRepository {
  Future<User> fetchUserData() {
    const url = "https://jsonplaceholder.typicode.com/users/1";
    return http.get(Uri.parse(url)).then((res) => User.fromJson(res.body));
  }
}
```

### VI. StreamProvider
Timer app
```dart
final streamProvider = StreamProvider((ref) async* {
  for (var i = 0; i < 20; i++) {
    yield (i);
    await Future.delayed(const Duration(seconds: 1));
  }
});
```
Rest logic is same as FutureProvider.

## Some Important Functions
### Family
Used to get a unique provider based on external parameters.
Using this we can transfer data back from UI to the provider where the API call took place.
```
ref.watch(fetchUserDataProvider(userId)) // UI
----- TO ---> 
final  fetchUserDataProvider  =  FutureProvider.family()....
```
Example
`main.dart`
```dart
final fetchUserDataProvider = FutureProvider.family((ref, String input) {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.fetchUserData(input);
});
```
`user.dart`
```dart
// Used for providing the repo to the FutureProvider.
final userRepositoryProvider = Provider((ref) => UserRepository());

class UserRepository {
  Future<User> fetchUserData(String userId) {
    var url = "https://jsonplaceholder.typicode.com/users/$userId";
    return http.get(Uri.parse(url)).then((res) => User.fromJson(res.body));
  }
}
```
`home_page.dart`
```dart
ref.watch(fetchUserDataProvider(userId)).when(......)
```
From here UI data passed to the API call via Provider.

### Ref
***Different Types of Ref***
1. WidgetRef -> allows to talk from provider to UI.
2. ProviderRef -> allows to talk from provider to another provider.
3. Ref

### ProviderObserver
ProviderObserver listens to the changes of a ProviderContainer.
ProviderObserver has three methods:
* `didAddProvider` is called every time a provider was initialized, and the value exposed is value.
* `didDisposeProvider` is called every time a provider was disposed.
* `didUpdateProvider` is called every time by providers when they emit a notification.

Example
`main.dart`
```dart
void main() {
  runApp(
    ProviderScope(
      observers: [
        Logger(),
      ],
    ),
    ...
```
`logger.dart`
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print("$provider $previousValue $newValue $container");
  }
}
```

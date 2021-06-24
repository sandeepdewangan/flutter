# Provider
## ChangeNotifierProvider 
Simple form in which user click button to add to the list.
**Step 01**
```dart
class Users extends ChangeNotifier {
  List<User> _users = [];

  UnmodifiableListView<User> get users => UnmodifiableListView(_users);

  void addUser(User u) {
    _users.add(u);
    notifyListeners();
  }
}
```
**Step 02**
```dart
void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => Users(),
      ),
    ],
    child: MyApp(),
  ));
}
```
**Step 03**
```dart
onPressed: () {
	Users  users = Provider.of<Users>(context);
    User sample = User(name: "Sandeep", city: "Raipur");
    users.addUser(sample);
},
```
**Step 04**
```dart
ListView.builder(
        itemCount: users.users.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            title: Consumer<Users>(
              builder: (ctx, users, child) => Text(users.users[index].name),
            ),
            subtitle: Consumer<Users>(
              builder: (ctx, users, child) => Text(users.users[index].city),
            ),
          );
        },
      ),
```


## FutureProvider
**Step 01**
```dart
Future<String> getCurrentTime() async {
  await Future.delayed(Duration(seconds: 5));
  return DateTime.now().toString();
}

Future<String> getUserName() async {
  await Future.delayed(Duration(seconds: 3));
  return "Sandeep Dewangan";
}
```
**Step 02**
```dart
FutureProvider(
        create: (_) => getUserName(),
        initialData: "Fetching name...",
      ),
```
**Step 03**
```dart
Consumer<String>(
  builder: (ctx, data, _) => Text(data),
 ),
```

## FutureProvider - II
When we have multiple providers of same type. Use as a complete where we want changes.
```dart
FutureProvider(
            create: (_) => getCurrentTime(),
            initialData: "Fetching Time...",
            child: Consumer<String>(
              builder: (ctx, data, child) => Text(data),
            ),
          ),
```

## StreamProvider

**Step 01**
```dart
Stream<int> getSessionTime() {
  return Stream.periodic(Duration(seconds: 1), (sessTime) => sessTime++);
}
```
**Step 02**
```dart
StreamProvider(
        create: (_) => getSessionTime(),
        initialData: 0,
      ),
```
**Step 03**
```dart
Consumer<int>(
          builder: (ctx, data, child) => Text(data.toString()),
        ),
```


## Reading a value

The easiest way to read a value is by using the extension methods on  `BuildContext`:

-   `context.watch<T>()`, which makes the widget listen to changes on  `T`
-   `context.read<T>()`, which returns  `T`  without listening to it
-   `context.select<T, R>(R cb(T value))`, which allows a widget to listen to only a small part of  `T`.

> `watch` can be used in place of `Consumer` - but it will continuously rebuild the widget (unnecessary) - <mark>use with precaution. </mark>


## Selector
**Step 01**
```dart
class Users extends ChangeNotifier {
  int _weight = 35;
  int get weight => _weight;
}
```
**Step 02**
```dart
Selector<Users, int>(
  selector: (ctx, users) => users.weight,
  builder: (_, weight, __) => Text(weight.toString()),
   ),
```
**Step 03**
```dart
void incWeight() {
    _weight++;
    notifyListeners();
  }
  // Calling
  onPressed: () {
            context.read<Users>().incWeight();
          },
```

# Routing
## Named Routing

**Step 02**
```dart
static const routeName = "/home"; // on first screen
static  const  routeName = "/second_screen"; // on second screen
```

**Step 01**
```dart
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (ctx) => HomePage(),
        SecondScreen.routeName: (ctx) => SecondScreen(),
      },
    );
  }
  ```
**Step 03**
```dart
Navigator.pushNamed(context, SecondScreen.routeName);
Navigator.pop(context);
```

## Passing arguments to a named routes
**Step 01**
```dart
Navigator.pushNamed(
	context, SecondScreen.routeName,
    arguments:
	    ScreenArgumentModel(name: "Sandeep", city: "Raipur")
);
```
**Step 02**
```dart
final args =
        ModalRoute.of(context)!.settings.arguments as ScreenArgumentModel;
```
## Return data from a screen

**Step 01: Screen I**
```dart
ElevatedButton(
            onPressed: () {
              callToSelectCity(context);
            },
            child: Text("Select City"),
          ),

...
...

void callToSelectCity(BuildContext context) async {
  final city = await Navigator.pushNamed(context, SelectCityScreen.routeName);
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$city')));
}
```
**Step 02: Screen II**
```dart
ListTile(
            onTap: () {
              Navigator.pop(context, "Raipur");
            },
            title: Text("Raipur"),
          ),
```


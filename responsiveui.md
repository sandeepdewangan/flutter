# Responsive and Adaptive UI Design

## Responsive
The **responsive** design will reconfigure all design elements whether it's viewed on a desktop, laptop, tablet, **or** mobile phone.

## Adaptive
Different fixed layouts are created that adapt to the users screen size.
Working with different operating systems like Android, iOS etc.

### 1. Use Flex
```dart
Column(
	Expanded(
		flex: 3,
		...
	Expanded(
		flex: 1,
        ...
```
### 2. Get height and width
```dart
MediaQuery.of(context).size.height
MediaQuery.of(context).size.width
MediaQuery.of(context).orientation // Orientation.portrait
```
### 3. Get height of any widget
```dart
final appBar = AppBar(
      title: Text("Hellop"),
    );

print(appBar.preferredSize.height);
```
### 4. Text scale factor
We might want to consider using this piece of information when setting font sizes.
```dart
	Text('Always the same size!', style:  TextStyle(fontSize:  20));
```
Instead try this
```dart 
	final curScaleFactor =  MediaQuery.of(context).textScaleFactor;
	...
	Text('This changes!', style:  TextStyle(fontSize:  20  * curScaleFactor));
```
### 5. Layout Builder
Builds a widget tree that can depend on the parent widget's size. Dynamically allocate the sizes.
```dart
LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 600) {
            return _buildWideContainers();
          } else {
            return _buildNormalContainer();
          }
        },
      ),
    );
```
Or resize the layout children's using the maxWidth.
```dart
constraints.maxWidth
```

### 6. Device Orientation
Set device orientation based on the need. 
In `main` function.
```dart
WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]
  );
```

### 7. SingleChildScrollView
A box in which a single widget can be scrolled.
This widget is useful when you have a single box that will normally be entirely visible, for example a clock face in a time picker, but you need to make sure it can be scrolled if the container gets too small in one axis (the scroll direction).

```dart
SingleChildScrollView(
	...
)
```
### 8. Device platform
Building widgets based on the device operating system.
```dart
Switch.adaptive()
// switch is the widget name.
```
Checking on which platform the app is running.
```dart
Platform.isAndroid;
Platform.isIOS;
Platform.isLinux;
Platform.isWindows;
```
Changing the look based on platform
```dart
Platform.isIOS ? CupertinoApp() : MaterialApp()
```

### More info
https://stackoverflow.com/questions/49704497/how-to-make-flutter-app-responsive-according-to-different-screen-size?rq=1

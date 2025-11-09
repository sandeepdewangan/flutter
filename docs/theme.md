## Flutter Theme

### Basic Setup

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // Initial Theme or Default Theme
      themeMode: ThemeMode.light,
      // Theme setup for Light theme
      theme: AppTheme.lightTheme,
      // Theme setup for Dark theme
      darkTheme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hello")),

      body: Center(
        child: Column(
          children: [ElevatedButton(onPressed: () {}, child: Text("Login"))],
        ),
      ),
    );
  }
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.orange,
    primaryColor: Colors.blue,
    textTheme: AppTextTheme.lightTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.elevatedButtonThemeLight,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.pink,
    primaryColor: Colors.green,
    textTheme: AppTextTheme.darkTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.elevatedButtonThemeDark,
  );
}

class AppTextTheme {
  static TextTheme lightTheme = TextTheme(
    headlineLarge: TextStyle().copyWith(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    headlineMedium: TextStyle().copyWith(
      fontSize: 24.0,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
  );
  static TextTheme darkTheme = TextTheme(
    headlineLarge: TextStyle().copyWith(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: TextStyle().copyWith(
      fontSize: 24.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  );
}

class AppElevatedButtonTheme {
  static ElevatedButtonThemeData elevatedButtonThemeLight =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  static ElevatedButtonThemeData elevatedButtonThemeDark =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
}
```

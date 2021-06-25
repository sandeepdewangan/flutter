# Null Safety

**Assigns a value to a variable only if that variable is currently null (??=)**
```dart
	int? a;
	a ??= 5;
	a ??=10;
	// The value remains `a=5`
```
**Return non-null value (??)**
```dart
print(1 ?? 3); // <-- Prints 1.
print(null ?? 12); // <-- Prints 12.
```
**Conditional property access (?.)**
```dart
(myObject != null) ? myObject.someProperty : null
// equivalent
myObject?.someProperty
```

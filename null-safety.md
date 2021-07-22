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

# Tactical Operators

## Spread Operator
```dart
// Spread Operator
// Unpacks the elements of the collection.

void main() {
  final collection1 = [1, 2, 3];
  final collection2 = [5, 6, 7];
  
  print([...collection1, ...collection2]);
}
```
Output
`[1, 2, 3, 5, 6, 7]`

Flutter Example
```dart
ListView(
	children:[
		Text("Some text"),
		Text("Some another text"),
		if(someCondition)
			...[
					Widgets1,
					Widgets2,
				]
		]
);
```

## Cascade Operator
```dart
  // Without cascade
  final mylist1 = [5, 6, 2, 8];
  mylist1.sort();
  mylist1.removeLast();
  print(mylist1);
  
  // With cascade
  final mylist2 = [5, 6, 2, 8];
  print(mylist2..sort()..removeLast());
```


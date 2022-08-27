# Flutter - Bootcamp
## Dart Basics
**NOTE:**
1. If we immediately assign value then no need to add data type.
	`const minLength =  2;`
2. In dart there are no class private fields, there are only package private field. 
	`_member` can be accessed outside the class and within the package.
3. A new file in dart is a package.
4. Abstract class can have fields and methods but can be instantiated only by the subclass which implements the abstract class.
5. If the concrete class `extends` abstract class, then methods which are **undefined** must be overridden.  and If the concrete class `implements` abstract class, then **all the methods** must be overridden. 
6. We can `implement` any regular classes. In dart there is no `interface` keyword.
7. Always use a class with `@immutable` tag for performance gain. Use `meta` package.


### Null Operators
We can declare `varname` as null.
```dart
String? varname;
```
Access null variable with null safety. Returns `null` without error.
```dart
varname?.length
```
Access null variable without null safety. Throws `Unhandled exception`.
```dart
varname!.length
```
### Function Parameters
1. Positional parameter.
2. Named parameter.

Positional and optional positional parameter
```dart
optionalPositionalParams(String name,  int age, [String? dob]) {}
```
Named optional and required parameter
```dart
namedOptionalNRequiredParams({required  String name,  int? age}) {}
```
### typedef
Typedef in Dart is used to create a user-defined identity (**alias**) for a function
```dart
typedef  IntTransformer  =  int  Function(int);

IntTransformer  twice(IntTransformer f) {
	return (int x) {
		return  f(f(x));
		};
}
```
### Collection transformations
1. map
2. where - to filter

`map`
```dart
final names = ['Sandeep', 'Khushbu', 'Darsh'];
final allLength = names.map((name) => name.length).toList();
```
`where`
```dart
final filterByLength = names.where((name) => name.length == 7).toList();
print(filterByLength);
```
### Looping through collections
```dart
// for loop
for (final name in filterByLength) {
    print(name);
  }
// For each
filterByLength.forEach((name) => print(name));
// OR
filterByLength.forEach(print);
```
### Spread operator
Spread Operator (…) and Null-aware Spread Operator (…?) are used for inserting multiple elements in a collection like Lists, Maps, etc.
```dart
final list1 = ['a', 'b'];
final list2 = ['c', 'd'];
final combinedList = <String>[
    ...list1,
    ...list2,
];
print(combinedList); // [a, b, c, d]
  ```

### Const constructor 
Without Const
```dart
void main(List<String> arguments) {
  User user1 = User(name: 'Sandeep');
  User user2 = User(name: 'Sandeep');
  print(user1 == user2); // false
}
class User {
  final String name;
  const User({required this.name});
}
```
With Const
```dart
void main(List<String> arguments) {
  User user1 = const User(name: 'Sandeep');
  User user2 = const User(name: 'Sandeep');
  print(user1 == user2); // true
}
```
Hence we got slight performance benifit by using const keyword.

### Private class
Cannot instantiate outside the package.
A member, method and class all can be private.
```dart
	class NonInstantiableClass {
	  NonInstantiableClass._();
	}
```
### Class properties
Class properties can be used for performing light work.
```dart
void main(List<String> arguments) {
  User user = User(firstName: 'Sandeep', lastName: 'Dewangan');
  user.getFullName(); // Not a good practice
  user.fullName; //Good practice, by using class property.
}

class User {
  final String firstName;
  final String lastName;
  const User({required this.firstName, required this.lastName});
  String getFullName() => '$firstName $lastName'; // bad way
  String  get  fullName => '$firstName $lastName'; // good way
}
```
Setter
```dart
set email(String email) {
    // logic...
}
// usage
user.email = 'sandeep@gmail.com'; // calls the setter
```
### Extending class
If user, forgets to call `signOut()` in Admin class then there will be problem and code will be incomplete. To avoid this mistake of the programmer we can use `@mustCallSuper` which is provided by the package `meta`.
```dart
import  'package:meta/meta.dart';

class User {
  final String firstName;
  final String lastName;
  const User({required this.firstName, required this.lastName});
  @mustCallSuper
  void signOut() {
    print("user is signed out");
  }
}
class Admin extends User {
  Admin(String fName, String lName) : super(firstName: fName, lastName: lName);
  @override
  void signOut() {
    print("admin is signed out");
    // This method overrides a method annotated as '@mustCallSuper' in 'User',
    super.signOut();
  }
}
```

### Factory constructors
1. A factory constructor is a constructor that can be used when you don't necessarily want a constructor to create a new instance of your class.
2. With factory we can return the instance of subclasses.
```dart
class User{
factory User.admin() {
    return Admin('Sandeep', 'Dewangan');
  } // Admin is subclass of User.
}
```

### Generics
Generics means parameterized types. The idea is to allow type (Integer, String, … etc., and user-defined types) to be a parameter to methods, classes, and interfaces. Using Generics, it is possible to create classes that work with different data types.
Generic Classes
```dart
abstract class DataReader<T> {
  T readData();
}
class IntDataReader implements DataReader<int> {
  @override
  int readData() {
    return 123;
  }
}
class StringDataReader implements DataReader<String> {
  @override
  String readData() {
    return 'Hello World!';
  }
}
```
Generic Method
```dart
myMethod<T>(T arg) {
  print(arg);
}
```
### Mixin
Multiple inheritance is prohibited. The reason behind this is to prevent ambiguity.
Consider a case where class B extends class A and Class C and both class A and C have the same method display(). Now compiler cannot decide, which display method it should inherit. To prevent such situation, multiple inheritances is not allowed.
Instead we can use mixin.
- Mixin do not perform any type of inheritance.
- Think like that the mixin just do copy and paste the methods into inherited classes.
```dart
mixin X {}
class A {}
class B extends A with X {}
```
### Extensions
Extension methods, introduced in Dart 2.7, are a way to add functionality to existing libraries.
Example using Methods
```dart
extension StringDuplication on String {
  String duplicate() {
    return this + this;
  }
}

final x = 'Hello'.duplicate();
print(x); //HelloHello
```
Example using Properties
```dart
extension StringDuplication on String {
  String get duplicated {
    return this + this;
  }
}

final x = 'Hello'.duplicated;
print(x); //HelloHello
```

### Files and packages
In dart the private members can be accessed within a package (means with in a file). If we have two files and we want to share private members outside the package (means outside a file) then we have to declare it as part file. 
`part of` and `part`
```dart
filename: one.dart.
part "two.dart";
Class One {
}
------
filename: two.dart.
part of "one.dart";
Class Two {
}
```
### copywith 
`copyWith()` method that we can add to our classes that contains all final fields. This method allows to make a copy of an existing object of the class, allow to supply only some of the named arguments and having the rest default values.
```dart
class Person {
  final String name;
  final int age;

  Person({
    required this.name,
    required this.age,
  });

  Person copyWith({String? name, int? age}){
    return Person(name: name ?? this.name, age: age ?? this.age);
  }
}
```
If we want to modify the age, we can do by calling `copyWith` method.
```dart
final person = Person(name: 'Sandeep', age: 31);
Person updatedPerson = person.copyWith(age: person.age + 1); <-- Update age
```
### Automatic code generation
`freezed` package in flutter is used for code generator for data-classes/unions/pattern-matching/cloning. Add to the dev dependencies. There are several dependencies we must install

- `freezed` (dev dependency)
- `freezed_annotation` (dependency)
- `build_runner` (dev dependency)

**Basic Commands**
`flutter pub run build_runner build --delete-conflicting-outputs`
`dart run build_runner build --delete-conflicting-outputs`
// Updates the class
`dart run build_runner watch --delete-conflicting-outputs`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'dart_basics.freezed.dart'; // STEP 01

void main(List<String> arguments) {}

// STEP 02
@freezed
class Person with _$Person {
  const Person._();
  const factory Person({
    required String name,
    required int age,
  }) = _Person;
}
```

### Union
Need of union.
Suppose we have classes like below.
```dart
class SuperClass {}
class SubClassA extends SuperClass {}
class SubClassB extends SuperClass {}
```
And in some place we have casted the subclass into superclass. To get what type of subclass it is we need if else condition. Now in future we added more classes, then we need to update the `if` `else` condition too. 
```dart
final myObject = SubClassB() as SuperClass;
  if(myObject is SubClassA){
    // check type
  }
  else if(myObject is SubClassB){
        // check type
  }
```
To solve this problem we can use `unions` provided by the `freezed` package.
```dart
@freezed
class Result with _$Result {
  const Result._();
  const factory Result.success(int value) = _Success;
  const factory Result.failure(String errorMessage) = _Failure;
}

void main(List<String> arguments) {
  const resultSuccess = Result.success(700);
  print(resultSuccess.when(
      success: (value) => "Successs...",
      failure: (value) => "Yehhh failed!..."));
}
// to show only one of the factory method use maybeWhen.
print(resultSuccess.maybeWhen(
    orElse: () => 'other than success',
    success: (value) => "Successs...",
  ));
```
### try, catch
```dart
try {
    final myint = int.parse('123a');
  } on FormatException catch (e) {
    // catch format exception and notify user
  }catch(e){
    // all exception other than Format, and crash the app.
  }
  finally{
    // this will always run.
  }
```
Custom Exception class - do not crash the app.
`class CustomException implements Exception{}`
Usage
`throw CustomException();`

Custom Error class - Crashes the app.
`class CustomError extends Error{}`
Usage
`throw CustomError();`

### Asynchronous operation
```dart
 // import 'package:http/http.dart';
  // get user data
  Client()
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'))
      .then((response) => print(response.body))
      .catchError((e) => print(e));
```
**Note: Always use async and await. Use above in some cases.** 
 
### Streams
```dart
 // declare and define the streams.
  final myStream = Stream.periodic(const Duration(seconds: 1));
  // listen to the stream.
  final subscription = myStream.listen((event) {
    print('Sec has passed');
  });
  // we need to cancel the stream subscription after usage.
  subscription.cancel();
```
### Strems generator
 - Create async generators (*)
 - `async*` returns async data. (here async streams of string)

 ```dart
 Future<void> main(List<String> arguments) async {
  generateMessageStreams().listen((event) {
    print(event);
  });
}
Stream<String> generateMessageStreams() async* {
  yield 'Hello!';
  await Future.delayed(Duration(seconds: 1));
  yield 'Have you heard of ';
  await Future.delayed(Duration(seconds: 1));
  yield 'Flutter!!!';
}
 ```
 Piping the message and transforming it using `map`.
 ```dart
 generateMessageStreams().map((msg) => msg.toUpperCase()).listen((event) {
	print(event);
});
 ```
 Again piping with `where`
 ```dart
 generateMessageStreams()
      .map((msg) => msg.toUpperCase())
      .where((msg) => msg.length > 10)
      .listen((event) {
    print(event);
  });
 ```

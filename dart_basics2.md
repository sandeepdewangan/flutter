# Dart
### final, const
1. The `const` keyword allows you to define constants that are known at compile time. To define constants whose values are known at runtime, you use the `final` keyword. eg. `DateTime.now()` is not known at compile time.
2. Unlike the  `const`  keyword, we don’t need to initialize the  `finalVariable`  in the declaration immediately.
3. Once we assign a value to a `final` variable, we cannot reassign a value to it.
4. Both  `const`  and  `final`  keywords define identifiers that can be assigned once and their values will not be changed throughout the program.


### Strings
Dart strings are immutable. It means that you cannot modify a string.

***String Formatting***
```dart
void main() {
  String name = "Sandeep";
  print("My name is: $name");
}
```
```dart
void main() {
  double p = 100;
  double r = 12.5;
  double t = 5;
  
  print("The Simple Interest Calculated is: ${p*r*t / 100}");
}
```
***Multiline Strings***
```dart
String message = '''
    SELECT * FROM STUDENT
    WHERE age >= 18 AND
    age <= 24
  ''';
  
   print(message);
```
### Loops
***For Loop***
```dart
  var hobbies = ["Playing Chess", "Coding", "Dancing"];
  for(var hobby in hobbies){
    print(hobby);
  }
```
***Foreach Loop***
```dart
  var hobbies = ["Playing Chess", "Coding", "Dancing"];
  hobbies.forEach((hobby) => print(hobby));
```
### Functions
Dart functions are first-class citizens means that you can assign a function to a variable, pass a function to another function as an argument, and return a function from another function.

***Optional Parameter***
* Use the square brackets  `[]`  to make one or more parameters optional.
* Specify a default value for the optional parameters.
```dart
String greet(String name, [String title = '']) {
  if (title.isEmpty) {
    return 'Hello $name';
  }
  return 'Hello $title $name!';
}
```
***Named Parameter with required***
* To define named parameters, you surround them with curly braces.
* By default, named parameters are optional. Use the  `required`  keyword to make them required.
```dart
void connect({int port = 3306, required String user, required String password}) {
  print('Connecting to $port using $user/$password...');
}

void main() {
  connect(user: 'root', password: 'secret');
}
```
***Arrow function***
If a body has only one line, you can use an arrow function.
```dart
var add = (int x, int y) => x + y;
```
### Classes
Note that a variable of a class is generally called a  **field**. However, if it can be accessed from outside of a class, it is called a  **property**.

***Cascading notation assignment***
```dart
class Points{
  int x = 0;
  int y = 0;
}

void main() {
  // create object
  var p = Points()
            ..x=5
            ..y=10;
}
```
***Method chaining***
Without method chaining
```dart
class Points{
  int x = 0;
  int y = 0;
  
  void move(int x, int y){
    this.x = x;
    this.y = y;
  }
  void show(){
    print("Point($x, $y)");
  }
  void reset(){
    x = 0;
    y = 0;
  }
}

void main() {
  Points p = Points();
  p.move(5, 10);
  p.show();
  p.reset();
}
```
With method chaining using this keyword
```dart
class Points{
  int x = 0;
  int y = 0;
  
  Points move(int x, int y){
    this.x = x;
    this.y = y;
    return this;
  }
  Points show(){
    print("Point($x, $y)");
    return this;
  }
  Points reset(){
    x = 0;
    y = 0;
    return this;
  }
}

void main() {
  Points p = Points();
  p.move(5, 10).show().reset();
}
```
### Constructor
***Short hand assignment constructor***
```dart
class Point{
  int x = 0;
  int y = 0;
  
  Point(this.x, this.y);
}

void main(){
  Point p = Point(2,3);
}
```
***Named Constructor***
```dart
Point.origin(int x, int y){
    this.x = x;
    this.y = y;
  }
  ...
  Point p = Point.origin(2,3);
  ```
  
  A constructor can call another constructor within the class.
  ```dart
 Point.origin() : this(0, 0);
  ```
 **Private Field**
 * In Dart, privacy is at the library level rather than the class level. Adding an underscore to a variable makes it library private not class private.
 * For now, you can understand that a library is simply a Dart file. Because both the  `Point`  class and the  `main()`   function are on the same file, they’re in the same library. Therefore, the `main()`  function can access the private fields of the  `Point`  class.
 * To prevent other functions from accessing the private fields of the  `Point`  class, you need to create a new library and place the class in it.
 ```dart
 class Point{
  int _x = 0;
  int _y = 0;
}
void main(){
  Point p = Point();
  print(p._x); // output 0, no error
}
 ```
 **Initializer List**
 Use an initializer list in the unnamed constructor to initialize private fields.
```dart
class Point {
  int _x = 0;
  int _y = 0;

  Point({int x = 0, int y = 0})
      : _x = x,
        _y = y;
}
 ```
 ### Setters and Getters 
* Use getter/setter to provide access to a private field.
* A setter starts with the `set` keyword and takes a parameter that you can assign to the private field.
* By using a getter, you can define a computed property. A computed property is not backed by a dedicated field but instead is computed when called.
 ```dart
 class Circle{
  double _radius = 0;
  Circle(double radius){
    print("Constructor called...");
    _radius = radius;
  }
  set radius(double r){
    print("Setter called...");
    _radius = r;
  }
  double get radius => _radius; // computed when called
}
void main(){
  Circle p = Circle(100);
  p.radius = 200; // setter
  print(p.radius); // getter
}
```
### const constructor
* Immutability means being unable to be changed. If a value is immutable, that value cannot be changed.
* To make a field of a immutable, you can use either the  `const`  or  `final`  keyword.
* If you use the  `const`  keyword, you need to initialize the value in the field declaration. Also, the value must be known at compile time.
* However, if you use the  `final`  keyword, you can assign a constant value to the field once at runtime.

### Null Safety
* Data types in the code are non-nullable by default.
* To specify that a variable can be null, you add a question mark (`?`) to the type in variable declaration.
```dart
String? message = 'Hello';
```
### null-aware operators
***if-null operator (??)***
```dart
  // ------Long Code-------
  String? input;
  String message;
  if(input == null){
    message = "Error";
    
  }else{
    message = input;
  }
  // ------Precise Code-------
  String? input;
  String message = input ?? "Error";
 ```
 ***null-aware assignment operator (??=)***
 ```dart
  String? input;
  input ??= "Error";
  ```
  ***null-aware access operator (?.)***
  ```dart
  // ------Long Code-------
  // To access the property we need to check if it’s not null.
  String? input;
  if(input != null){
    print(input.length);
  }

// ------Precise Code-------
// To avoid using the if statement, 
// we can use the null-aware access operator (?.):
  print(input?.length); // null
  ```
  ***null assertion operator (!)***
 If we are sure that the method doesn’t return a null value, we can use the null assertion operator (`!`)
```dart
// ---------Code----------
bool? isTextFile(String? filename) {
  if (filename != null) {
    return filename.endsWith('.txt') ? true : false;
  }
  return null;
}
void main() {
  bool result = isTextFile('readme.txt'); // Error
  // `A value of type 'bool?' can't be assigned to a variable of type 'bool'.`
}
// ---------Modified Code---------
bool result = isTextFile('readme.txt')!;
```
***null-aware index operator (?[])***

The null-aware index operator  `?[]`  allows you to access an element of a list when the list might be  `null`.
```dart
void main() {
  List? scores = [1, 2, 3, 4, 5];
  // somewhere in the code
  scores = null;
  print(scores?[3]); // null
}
```
***null-aware spread operator***

### Inheritance
* Inheritance allows you to define a class that extends the functionality of another class.
* Dart supports single inheritance.
* A child class doesn’t automatically inherit constructors from the parent class.
* Use the  `super`  keyword to reference the parent class.

### Object Identity & Equality
***Object Identity***
* All classes implicitly inherit from the Object class directly or indirectly. Therefore, all classes can access the == operator from the Object class.
* The `==` operator returns true if two objects are equal. By default, the == operator compares two objects by their identities. 
Example
```dart
void main() {
  Point p1 = Point(2, 3);
  Point p2 = Point(2, 3);
  bool isEqual = p1 == p2; // false
  identical(p1,p2) // false
  
  Point p3 = Point(1,2);
  Point p4 = p3;
  identical(p3,p4); //true
}
```
* `p1` and `p2` are referencing separate objects.
* To check if two variables reference the same object, you use the `identical()` function

***Object Equality***
If you want two `Point` objects with the same `x` and `y` to be equal, you need to override the `==` operator.
```dart
@override
operator ==(o) => o is Point && o.x == x && o.y == y;

  Point p1 = Point(2, 3);
  Point p2 = Point(2, 3);
  bool isEqual = p1 == p2; // true
  identical(p1,p2) // false
  ```
All Dart classes have a getter `hashCode`. 
By rules, if two objects are equal, their hash codes (or values) should be equal.
```dart
  @override
  int get hashCode => Object.hash(x,y);
```
### Abstract Classes
* Classes are called **concrete classes**. They’re concrete because you can create new objects out of them.
* Unlike a concrete class, you cannot create new objects from an abstract class. The main purpose of the abstract class is to allow other classes to inherit from it.
* An abstract method only has the signature and doesn’t have the implementation.

```dart
abstract class Shape {
  double area();
}
class Circle extends Shape {
  double radius;
  Circle({this.radius = 0});

  @override
  double area() => 3.14 * radius * radius;
}
```
### Interfaces
* An interface is a contract between classes. 
* Unlike other languages, Dart doesn’t have the interface keyword. Instead, all classes are implicit interfaces.
```dart
abstract class Logger {
  void log(String message);
}
class ConsoleLogger implements Logger {
  @override
  void log(String message) {
    print('Log "$message" to the console.');
  }
}
class FileLogger implements Logger {
  @override
  void log(Pattern message) {
    print('Log "$message" to a file.');
  }
}
class App {
  Logger? logger;
  App({this.logger});

  void run() {
    logger?.log("App is starting...");
  }
}
void main() {
  // can use configuration file to select
  // kind of loggger to use
  var app = App(logger: FileLogger());
  app.run();
}
```
***Interfaces vs Abstract**
* Abstract classes may contain the implemented method but not in interface.
* When implementing an interface, only implement the methods that are necessary for your use case.
* Abstract classes allow you to define a common set of functionality that can be shared by multiple classes
* Interfaces define a set of methods that a class must implement to be used in a particular context.

### Mixins
Suppose there is a abstract Model class which has the sharable content. There is User, Post and Comment class. All these extends Model class, but only Post and Comment class can call share() not User class.
***Not an ideal solution***
```dart
abstract class Model{
  void share(){
    print("This will be shared...");
  }
}
class Post extends Model{
}
class User extends Model{
  void share(){
    throw UnimplementedError();
  }
}
void main(){
  Post p = Post();
  p.share();  // This will be shared...
  // If i want User should not access the share content 
  // then we can throw unimplemented error.
  User u = User();
  u.share(); // throws error.
}
```
* Mixins allow you to share behaviors between one or more classes without using inheritance.
* A mixin is like a class. To define a mixin, you use the mixin keyword instead of the class keyword.
* A mixin doesn’t have a constructor and it cannot be instantiated.
* To use a mixin in other classes, you use the with keyword.
```dart
abstract class Model {
  void share(String content) {
    print('Share the $content');
  }
}
mixin Shareable {
  void share(String content) {
    print('Share the $content');
  }
}
class Post extends Model with Shareable{}
class Comment extends Model with Shareable{}
class User extends Model{}
void main(){
  var post = Post();
  post.share('The first post.');
}
```
***Another Example***
The three animals all have one similar thing is in common that is they all can breathe. Thats why breathe() is shared amoung all via extending. 
```dart
abstract class Animal{
  void breathe(){
    print("Breath...");
  }
}

// to extends these features of bark, crawl and fly to out Snake, 
// Dog and Bat we need to extend the class.
// Dart dont allow multiple inheritnace.
// hence we need mixin.

mixin Bark{
  void bark() => print("Bark");
}
mixin Crawl{
  void crawl() => print("Crawl");
}
mixin Fly{
  void fly() => print("Fly");
}
class Snake extends Animal with Crawl{}
class Dog extends Animal with Bark{}
class Bat extends Animal with Fly{}
void main(){
  Dog d = Dog();
  d.breathe();
  d.bark();
}
```
### Extension method
Extension methods allow you to extend an existing library without using inheritance.
```dart
// define an extension on the String type
extension on String{
  String capitalize() =>
   "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
}
void main(){
  String title = "sandeep";
  print(title.capitalize()); // Sandeep
}
```
***extension name***
```dart
extension <extension name> on <type> {
  (<member definition>)
}
```
* The extension name is optional. It’ll be useful in case of API conflicts.
* When importing a conflicting extension, you can use the show or hide keyword to limit the exposed API.
```dart 
import  'string_lib2.dart'  hide StringCase;
import  'string_lib2.dart'  show StringPadding;
```
### Generics
Generics used to define classes and methods that work with more than one type.
***Example-1***
```dart
class Pair<T>{
  T x;
  T y;
  Pair(this.x, this.y);
}
void main(){
  Pair p1 = Pair<int>(2,3);
  Pair p2 = Pair<String>("One","Two");
}
```
***Parameterized type constraints***
* When you use type  `T`  in a generic class,  `T`  is a subtype of the  `Object`  type. 
* It means that you can access only methods and properties of the  `Object`  type in the generic class.
```dart
class GenericClass<T extends MyClass> {
   // ...
}
```
* `T` is a subtype of the `MyClass` instead of `Object`. Therefore, you can access the methods and properties of the `MyClass`.
```dart
abstract class Shape{
  double get area;
}
class Square extends Shape{
  double length;
  Square(this.length); 
  @override
  double get area => length * length;
}
class Circle extends Shape{
  double radius;
  Circle(this.radius);
  
  @override
  double get area => 3.14 * radius * radius;
}
// Calculate the area of all the regions provided.
class Region<T extends Shape>{
  List<T> shapes;
  Region(this.shapes);
  
  String get area{
    for(var shape in shapes){
      print(shape);
    }
    return "Area of all shapes are: XX";
  }
} 
void main(){
  Region r = Region([
    Circle(2), Circle(3), Square(3)
  ]);
  print(r.area);
}
```
### Enum
Enums or enumerated types are special classes representing a fixed number of constant values.
### Factory Constructors
* A generative constructor always returns a new instance of the class. 
* A  factory constructor uses the factory keyword and uses a return keyword to return an instance of the class.
* The factory constructor may return an existing instance rather than a new instance.
* For example, it may return an instance from the cache. In addition, the factory constructor may return an instance of a subtype of the class.
***Without Factory Constructor***
```dart
class Area{
  double length;
  double breadth;
  double area;
  Area(this.length, this.breadth) : area = length * breadth;
}
void main(){
  Area a1 = Area(5, 10);
  print(a1.area);
  // a2 object has a negative value. 
  // This is because we are not validating the input.
  // Here we are wasted a memory.
  Area a2 = Area(5, -10);
  print(a2.area);
}
```
***With Factory Constructor***
```dart
class Area{
  double length;
  double breadth;
  double area;
  // private named constructor
  Area._initialze(this.length, this.breadth) : area = length * breadth;
  // factory constructor
  factory Area(double len, double br){
    if(len <= 0 || br <= 0){
      throw Exception("Length and Breadth cant be less than 1"); 
    }
    return Area._initialze(len, br);
  }
}
void main(){
  Area a1 = Area(5, 10);
  print(a1.area);
  
  // throws error
  Area a2 = Area(5, -10);
  print(a2.area);
}
```
### Exception
To prevent the program from crashing, we need to handle the exception.
```dart
void fn(String name){
  try{
    String lastChar = name[5];
  }
  catch(e, st){
  // RangeError (index): Index out of range: index should be less than 5: 5
    print(e); 
    print(st); // Strack trace
  }
}
void main(){
  fn("Hello");
  print("Byee"); // this will be outputed.
}
```
***Specific Exception***
```dart
try {
  // code that may cause the exception
} on Exception1 catch(e) {
  // handle Exception1
} on Exception2 catch(e) {
  // handle Exception2
} catch (e) {
  // handle other exceptions
}
```
***Finally***
The `finally` block always executes whether an exception occurs or not.

***Raise an exception***
```dart
throw Exception('Index is out of range');
```
We should not throw an exception that is an instance of the `Exception` class. Instead, you should define a custom exception class that implements the `Exception` interface.
```dart
class NegativeValueException implements Exception{
  String errorMessage;
  NegativeValueException(this.errorMessage); 
  @override
  String toString() => errorMessage;
}
double calculateInterest(double p, double r, int t){
  if(r < 0) throw NegativeValueException("Rate cant be negative");
  return (p*r*t) / 100;
}
void main(){
  double si = calculateInterest(100, -5, 3);
  print(si);
}
```
### Collections
***Lists***
* Contains duplicate and null elements.
* Indexable collection.

***Spread Operator***
Spread operator is used to combine multiple lists into one. (Extractor)
```dart
var scores = [...list1, ...list2];
```
***Collection If***
```dart
// collection if to determine whether an element is included in a list 
// based on a condition
  bool flag = true;
  var mylist = [
    if(flag) 'if flag is true this will execute',
    'else this',
    'this also',
  ];
 ```
 ***Collection for***
 ```dart
  var nums = [1, 2, 3];
  var res = [0, for(var num in nums) num*2];
  print(res); // [0, 2, 4, 6]
  ```
  ### Sets
 * A set is a collection of unique elements. 
 * Unlike a list, a set doesn’t allow duplicates. 
 * A set doesn’t maintain the order of elements. 
 * A set is faster than a list, especially when working with large elements.
```dart
Set<int> ratings = {};
var ratings = <int>{};
var ratings = {1, 2, 3};
```
### Maps
`Map` type allows you to manage a collection of key/value pairs.
```dart
Map<String, int> fruits = {'apple': 1, 'banana': 1, 'orange': 2};
var fruits = <String, int>{};
```
### Iterables
* An iterable is a collection of elements that can be accessed sequentially. 
* Dart uses the Iterable<E> abstract class to represent iterable objects.
<mark>Note:</mark> Iterables are lazy evaluated unlike lists.

### Iterator (Like a pointer)
* Dart uses the  `Iterator<E>`  interface for getting items, one at a time, from an object.
* The  `Iterable<E>`  has the  `moveNext()`  method that moves the iterator to the next element. 
* It returns true if the object still has at least one element. If no element is left, the  `moveNext()`  returns  `false`.
```dart
void main(){
  var data = [1, 2, 3, 4];
  var itr = data.iterator;
  while(itr.moveNext()){
    print(itr.current);
  }
}
```
### Filtering Iterables
Filter the number which is greater than 10 using `where` clause.
```dart
void main(){
  var data = [1, 2, 3, 23, 5, 4, 5, 12, 7, 10];
  // want to 
  var filteredData = data.where((n) => n > 10);
  print(filteredData); // (23, 12)
  print(filteredData.toList()); // [23, 12]
}
```
### Map
The  `map()`  method iterates over elements of an iterable and passes each element to a function. If the function returns true, the  `map()`  method includes the elements in the result iterable object.
```dart
void main() {
  var salaries = [1000000.0, 125000.0, 150000.0];
  var newSalaries = salaries.map((salary) => salary * 1.05);
  print(newSalaries);
}
```
Map with where
```dart
void main() {
  var inputs = ['1.24', '2.35', '4.56', 'abc'];
  var numbers = inputs.map(double.tryParse).where((n) => n != null);
  print(numbers);
}
```
### Reduce
* The  `reduce()`  method reduces a collection of elements to a single value by iteratively combining elements using a  `combine()`  function.
* It passes the first element to the value and the second element to the element parameter.
```dart
void main() {
  var numbers = [1, 2, 3, 4];
  var sum = numbers.reduce((v, e) => v + e);
  print('sum: $sum');
  // v=1 e=2 result=3 
  // v=3 e=3 result=6
  // v=6 e=4 result=10
}
```
### Asynchronous programming
* Asynchronous programming enables efficient handling of time-consuming tasks without blocking execution. 
* It provides constructs like `async` and `await` to initiate operations and continue with other tasks while awaiting results, resulting in responsive and non-blocking code.

***Event Loop***
* To schedule tasks asynchronously, Dart uses an event loop.
* The event loop has two queues:
	* A microtasks queue.
	* An event queue.
* If Dart finds long-running tasks that can be postponed, it puts them in the event queue.
* The event loop is always running. It continuously checks the synchronous tasks, microtask queue, and event queue.
* It executes the tasks in the microtask queue once the synchronous tasks are empty. And it only executes the tasks in the event queue once both synchronous tasks and the microtask queue are empty.

***Future***
A future is an object that represents the result of an asynchronous operation.
There are two ways to get the value after the future completes, using a callback and using  `async`  and  `await`  keywords.

***callback***
```dart
void main() {
  var future = Future.delayed(Duration(seconds: 2), 
					  ()=>"Future funtion called...");
  future.then((value)=> print(value));
  print("called before future.");
}

O/p
called before future.
Future funtion called...
```
***await and async***
```dart
void main() async{
  var future = await Future.delayed(Duration(seconds: 2), 
                              ()=>"Future funtion called...");
  print(future);
  print("called before future.");
}
```
### Stream
* Sequence of async events.
* A future represents a single value that will be returned by an asynchronous operation. 
* A stream is like a list of futures, representing multiple values that will be returned in the future.
* SINK -> data travelled from sink to source.
* SOURCE -> Data exhusted here.
```dart
import 'dart:async';

class MyTimer{
  int counter = 60;
  final _streamController = StreamController<int>(); // STEP 1, create an instance. 
  
  MyTimer(){
    Timer.periodic(Duration(seconds:1), (timer){
    counter--;
    _streamController.sink.add(counter); // STEP 2, add an event to the stream.
    if(counter <= 0){
      timer.cancel(); // stopping timer
      _streamController.close(); // STEP 4, close the stream.
    }
   });
  }
  
  // return stream object
  Stream<int> get stream => _streamController.stream;
}
void main() async{
// -------------------------------------------
  // reading stream from the callback, SINGLE Subscription
  var stream = MyTimer().stream;
  // STEP 3, Reading to an event.
  var subscription = stream.listen((event)=> print(event)); 
// -------------------------------------------
  // reading stream from the callback, MULTIPLE Subscription
  var stream = MyTimer().stream.asBroadcastStream();
  var subscription1 = stream.listen((event)=> print("Listener 1 $event"));
  var subscription2 = stream.listen((event)=> print("Listener 2 $event"));
// -------------------------------------------
// Reading from a stream using an await-for statement
  var stream = MyTimer().stream;
  await for(var value in stream){
    print(value);
  }
}
```
The `listen()` method of the `Stream<T>` object returns an instance of the `StreamSubscription<T>`:
```dart
var subscription = stream.listen(
  (event) => print(event),
);
```
We can -   
- `pause()`  – pauses a subscription.
-   `resume()`  – resumes a subscription after a pause.
-   `cancel()`  – cancels a subscription.

***Transforming a stream***
```dart
  MyTimer().stream
     .take(10) // take first 10 streams
     .where((count) => count % 2 == 0) // filter by even number
     .map((count) => "Count: $count") // transform the output
     .listen((count)=>print(count), onDone: () => print("Done")); // listen
```
***Adding error***
```dart
....
if(counter == 52){
      _streamController.addError("52 found!");
}
....
listen((count)=>print(count), onError:(d)=>print(d)); 
```
### Generators
### Library
```
├── libs 
| 	└── shapes.dart 
├── main.dart
```
`shapes.dart`
```dart
library shape;

import 'dart:math';

abstract class Shape {
  double get area;
}

class Circle extends Shape {
  double _radius;
  Circle({required double radius}) : _radius = radius;
  double get area => pi * pow(_radius, 2);
}

class Square extends Shape {
  double _length;
  Square({required double length}) : _length = length;
  double get area => pi * pow(_length, 2);
}
```
Import
`import  'libs/shapes.dart';`

***Splitting library***
`shapes.dart`
```dart
library shape;

import 'dart:math';

part 'circle.dart';
part 'square.dart';
```
`circle.dart`
```dart
part of shape;

class Circle extends Shape {
  double _radius;
  Circle({required double radius}) : _radius = radius;
  double get area => pi * pow(_radius, 2);
}
```
### Package
A package is a directory that contains a  `pubspec.yaml`  file. The  `pubspec.yaml`  stores the information of the package.

Dart has two types of packages:
-   Application packages: When you create a Dart console program, the program itself is an application package.
-   Library packages: The packages on  `pub.dev`  are library packages.
***Adding library package***
`dart pub add <package_name>`

### Records
Use Dart record to model a lightweight data structure that contains multiple fields.
Records are anonymous, immutable, and aggregate type:
**Anonymous** means that records don’t have a specific name associated with them. In practice, you often use records for one-time data structures or as a lightweight alternative to classes.
**Immutable** means that records can’t be changed once they’re created.
**Aggregate type**: records are aggregate types because they group multiple values into a single value.
**Example**
```dart
void main() {
  // define records
  final cordinates1 = (1233.34, 2334.3);
  
  // access records
  final lat1 = cordinates1.$1;
  final lng1 = cordinates1.$2;
  
  // ------- More Clear Way ------
  // define records
  final cordinates2 = (lat: 211, lng: 433);
  
  // access records
  final lat2 = cordinates2.lat;
  final lng2 = cordinates2.lng;
  print(lat2);
}
```

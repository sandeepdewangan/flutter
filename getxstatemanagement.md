# GetX State Management

## Basic
**Step 01**
Prepare the controller class
```dart
class RestaurantController extends GetxController {
  final name = "Pizza Junction".obs;

  static RestaurantController get to => Get.find<RestaurantController>();

  setName(restroName) {
    // set name
    name(restroName);
  }
}
```
**Step 02**
Register Controller
```dart
void main() {
  Get.put(RestaurantController());
  runApp(MyApp());
}
```
**Step 03**
Listen for changes
```dart
final  restroController = RestaurantController.to;
```
Warp widget, to listen.
```dart
Obx(
	() => Text(restroController.name.value),
),
```

### For other variables
```dart
  final followerCount = 0.obs;
  final isOpen = true.obs;
  final followerList = [].obs;
  final reviews = <String, String>{}.obs;
 ```
 ```dart
 forInt() {
    followerCount(followerCount.value + 1);
  }
  ```
  ```dart
  forList(String name) {
    followerList.add(name);
  }
  ```
  ```dart
  forMaps(String name, String review) {
    reviews.addIf(true, name, review);
  }
  ```
  
  ### Observing the whole object
  Observing student class.
  ```dart
  final  student = Student().obs;
  
// Set entire object
  setStudent(Student st) {
    student(st);
  }

  // Set individual items
  setStudentName(String name) {
    student.update((studentObj) {
      studentObj!.name = name;
    });
  }
  ```
  
  ## GetBuilder
  **Step 01**
  ```dart
  String college = "";

  setCollege(String college) {
    this.college = college;
    // similar to notify listeners.
    update();
  }
  ```
**Step 02**
  Usage in widget	
```dart
GetBuilder<ControllerName>(
	// Wrap widget here.
);
```

**Note**
**We can use any one of the above. `GetBuilder` or `Obx`.**

## Workers
### ever and once
Workers will assist you, triggering specific callbacks when an event occurs.
```dart
@override
  void onInit() {
    super.onInit();

    // 'ever' is called every time the _Rx_ variable emits a new value.
    ever(followerList, (value) => print("Follower List Ever $value"));
    // 'once' is called only the first time the variable has been changed.
    once(followerList, (value) => print("Follower List Once $value"));
  }
```
*Note: The `ever` is called first than `once`*

### debounce and interval
-   **`debounce`**

'debounce' is very useful in search functions, where you only want the API to be called when the user finishes typing. If the user types "Jonny", you will have 5 searches in the APIs, by the letter J, o, n, n, and y. With Get this does not happen, because you will have a "debounce" Worker that will only be triggered at the end of typing.

-   **`interval`**

'interval' is different from the debouce. debouce if the user makes 1000 changes to a variable within 1 second, he will send only the last one after the stipulated timer (the default is 800 milliseconds). Interval will instead ignore all user actions for the stipulated period. If you send events for 1 minute, 1000 per second, debounce will only send you the last one, when the user stops strafing events. interval will deliver events every second, and if set to 3 seconds, it will deliver 20 events that minute. This is recommended to avoid abuse, in functions where the user can quickly click on something and get some advantage (imagine that the user can earn coins by clicking on something, if he clicked 300 times in the same minute, he would have 300 coins, using interval, you you can set a time frame for 3 seconds, and even then clicking 300 or a thousand times, the maximum he would get in 1 minute would be 20 coins, clicking 300 or 1 million times). The debounce is suitable for anti-DDos, for functions like search where each change to onChange would cause a query to your api. Debounce will wait for the user to stop typing the name, to make the request. If it were used in the coin scenario mentioned above, the user would only win 1 coin, because it is only executed, when the user "pauses" for the established time.

```dart
@override
  void onInit() {
    super.onInit();
    // wait for 3 seconds and prints the last updated value
    // simply try to press the inc button continuosly, this will not print any thing, 
    // or simply waits for 3 seconds to print the last updated value.
    debounce(followerCount, (value) => print(followerCount),
        time: Duration(seconds: 3));
	
	// prints the updated data every 1 seconds.
    interval(followerCount, (value) => print(followerCount),
        time: Duration(seconds: 1));
  }
 ```
 
 ** Dispose the workers, when not need to look into variables**
```dart
late  Worker  everWorker;
...
everWorker = ever(followerList, (value) {
      // todo
      // if condition
      everWorker.dispose();
}); 
```

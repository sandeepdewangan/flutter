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

## GetBuilder vs GetX vs Obx vs MixinBuilder
In a decade working with programming I was able to learn some valuable lessons.

My first contact with reactive programming was so "wow, this is incredible" and in fact reactive programming is incredible. However, it is not suitable for all situations. Often all you need is to change the state of 2 or 3 widgets at the same time, or an ephemeral change of state, in which case reactive programming is not bad, but it is not appropriate.

Reactive programming has a higher RAM consumption that can be compensated for by the individual workflow, which will ensure that only one widget is rebuilt and when necessary, but creating a list with 80 objects, each with several streams is not a good one idea. Open the dart inspect and check how much a StreamBuilder consumes, and you'll understand what I'm trying to tell you.

With that in mind, I created the simple state manager. It is simple, and that is exactly what you should demand from it: updating state in blocks in a simple way, and in the most economical way.

GetBuilder is very economical in RAM, and there is hardly a more economical approach than him (at least I can't imagine one, if it exists, please let us know).

However, GetBuilder is still a mechanical state manager, you need to call update() just like you would need to call Provider's notifyListeners().

There are other situations where reactive programming is really interesting, and not working with it is the same as reinventing the wheel. With that in mind, GetX was created to provide everything that is most modern and advanced in a state manager. It updates only what is necessary and when necessary, if you have an error and send 300 state changes simultaneously, GetX will filter and update the screen only if the state actually changes.

GetX is still more economical than any other reactive state manager, but it consumes a little more RAM than GetBuilder. Thinking about it and aiming to maximize the consumption of resources that Obx was created. Unlike GetX and GetBuilder, you will not be able to initialize a controller inside an Obx, it is just a Widget with a StreamSubscription that receives change events from your children, that's all. It is more economical than GetX, but loses to GetBuilder, which was to be expected, since it is reactive, and GetBuilder has the most simplistic approach that exists, of storing a widget's hashcode and its StateSetter. With Obx you don't need to write your controller type, and you can hear the change from multiple different controllers, but it needs to be initialized before, either using the example approach at the beginning of this readme, or using the Bindings class.

Getx
```dart
GetX<Controller>(
  builder: (controller) {
    print("count 1 rebuild");
    return Text('${controller.count1.value}');
  },
```
GetBuilder
```dart
GetBuilder<ControllerName>(
	// Wrap widget here.
);
```
Obx
```dart
Obx(
	() => Text(restroController.name.value),
),
```

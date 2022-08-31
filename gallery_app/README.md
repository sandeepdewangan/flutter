# Gallery App Bloc
Bloc Project [Youtube](https://www.youtube.com/watch?v=Mn254cnduOY&t=22680s)

## Packages
```yaml
firebase_core:  ^1.21.1
firebase_storage:  ^10.3.7
bloc:  ^8.1.0
flutter_bloc:  ^8.1.1
image_picker:  ^0.8.5+3
uuid:  ^3.0.6
firebase_auth:  ^3.7.0
flutter_hooks:  ^0.18.5+1
```
Flutter Firebase CLI
https://firebase.google.com/docs/cli#install-cli-windows
Firebase Docs
https://firebase.flutter.dev/docs/overview/

### Flutter Hooks
We saw that a stateful widget is made up of a widget class and a state class, and in the state class, we defined the mutable properties, and we often mutate them inside the  **_setState_**  to be able to trigger the rebuild of the layout.
There seems to be too much boilerplate code and information to keep track of to effectively make use of stateful widgets.

### Setting up firebase
Setup firebase via CLI
https://firebase.flutter.dev/docs/cli
**Add the below lines in main.dart file**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```
**Firebase storage rules**
We are restricting the user to access the others folders.
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
        function isFolderOwner(userId){
          return request.auth != null && request.auth == userId;
        }
    match /{userId}/{allPaths=**} {
    	allow create, read, update, write: if isFolderOwner(userId);
    }
  }
}
```

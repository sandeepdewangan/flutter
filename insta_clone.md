
# Flutter Instagram Clone
https://github.com/RivaanRanawat/instagram-flutter-clone

## Helpful Packages List

1. SVG image import `flutter pub add flutter_svg` 
2. Image Picker from gallery `flutter pub add image_picker` 

## Helpfull Widgets
**GestureDetector**
GestureDetector class is very broad. you can detect every type of interaction the user has with the screen or widget using it. it includes pinch, swipe, touch, plus custom gestures.
**InkWell**
InkWell has a limited number of gestures to detect but it gives you ways to decorate the widget. you can decorate

<hr/>

## Create Flutter Project

`flutter create instagram_clone`

<hr/>

# Firebase 
**Step 01: Firebase Setup**
`flutter pub add firebase_core` >>> For connection with flutter app.
`flutter pub add cloud_firestore` >>> Allows to store data in firestore.
`flutter pub add firebase_auth`  >>> For authentication.
`flutter pub add firebase_storage` >>> For storing images.

**Step 02:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```
**Step 03:**
`build.gradle`
```dart
defaultConfig {
        minSdkVersion 19
        multiDexEnabled true
    }
```

**Step 04: For setting on Web**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyA6mDvQQI5_uUkR0FW-SRsPdtKMnBBVlNY',
        appId: '1:651844039895:web:4e7d9f529aa7b7d08cac92',
        messagingSenderId: '651844039895',
        projectId: 'insta-clone-dfc15',
        storageBucket: 'insta-clone-dfc15.appspot.com',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}
```

### Firebase Authentication and Storing into DB
```dart
class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Signup User
  signUpUser({
    required String email,
    required String password,
    required String bio,
  }) async {
    String res = "Some error occured";
    try {
      // Create User in authentication storage
      if (email.isNotEmpty || password.isNotEmpty || bio.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // Storing user data in database
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'email': email,
          'password': password,
          'bio': bio,
        });
        res = "Success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
```
<hr/>
## Text Field

```dart
// 1
final TextEditingController _emailController = TextEditingController();

//2
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

//3
 TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Enter Email Id',
              ),
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
            ),
```

# Image Upload

**Step 01:** UI File
```dart
Uint8List? _image;
```
**Step 02:** Pick Image
```dart
onPressed: () async {
  Uint8List im = await pickImage(ImageSource.gallery);
  setState(() {
    _image = im; // updates the UI so that selected image displayed.
  });
```

```dart
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource imgScr) async {
  final ImagePicker _picker = ImagePicker();
  // Pick an image
  final XFile? _image = await _picker.pickImage(source: imgScr);

  if (_image != null) {
    return await _image.readAsBytes();
  }
  print('No Image');
}
```

**Step 03** Set Image
```dart
MemoryImage(_image!) // readAsBytes reads data, and store it in memory buffer. 
```

**Step 04** Uploading Image to Storage
```dart
class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // adding image to storage
  Future<String> uplaodImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref = _storage.ref().child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadURL = await snap.ref.getDownloadURL();
    return downloadURL;
  }
}
```

```dart
// Uploading Profile Picture
  String photoUrl = await StorageMethods()
      .uplaodImageToStorage('profilePictures', file, false);

  // Storing user data in database
  await _firestore.collection('users').doc(cred.user!.uid).set({
    .....
    .....
    'photoUrl': photoUrl,
  });
```


#Login
`AuthMethods` Class
```dart
---AuthMethods Class---
Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Error";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      }
    } catch (e) {
    }
    return res;
  }
```
From the UI
```dart
void loginUser() async {
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
  }
```

# Persisting Auth State with Firebase Methods
```dart
home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          return const LoginScreen();
        },
      ),
```

# Model

**User Model**
```dart
class User {
  final String email;
  final String password;
  final String bio;
  final String photoUrl;
  final List followers;
  final List following;

  const User(
      {required this.email,
      required this.password,
      required this.bio,
      required this.photoUrl,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "bio": bio,
        "photoUrl": photoUrl,
        "followers": followers,
        "following": following,
      };
}
```

# Firebase Getting User Details
```dart
 void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      username = (snap.data() as Map<String, dynamic>)['email'];
      print(snap.data());
    });
  }
```

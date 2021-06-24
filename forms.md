# Forms

**Step 01**
```dart
  String _name = "";

  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  ```
**Step 02**
```dart
Form(
	key: _formState,
	child:  .....
	TextFormField(
              decoration: InputDecoration(labelText: "Enter your name"),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'name is required.';
                }
                return null;
              },
              onSaved: (String? value) {
                _name = value.toString();
              },
            ),
```
**Step 03**
```dart
		ElevatedButton(
              onPressed: () {
                if (!_formState.currentState!.validate()) {
                  return;
                }
                _formState.currentState!.save();
                print(_email);
              },
              child: Text("Submit"),
            ),
```

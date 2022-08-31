import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvent {
  const AppEvent();
}

/*
Event in bloc should not have any type of logic.
They should not be mutated.
*/
@immutable
class AppEventUploadImage implements AppEvent {
  final String filePathToUpload;

  const AppEventUploadImage({
    required this.filePathToUpload,
  });
}

@immutable
class AppEventDeleteAccount implements AppEvent {
  const AppEventDeleteAccount();
}

@immutable
class AppEventLogout implements AppEvent {
  const AppEventLogout();
}

@immutable
class AppEventInitialize implements AppEvent {
  const AppEventInitialize();
}

@immutable
class AppEventLogin implements AppEvent {
  final String email;
  final String password;

  const AppEventLogin({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventGotoRegistration implements AppEvent {
  const AppEventGotoRegistration();
}

@immutable
class AppEventGotoLogin implements AppEvent {
  const AppEventGotoLogin();
}

@immutable
class AppEventRegister implements AppEvent {
  final String email;
  final String password;

  const AppEventRegister({
    required this.email,
    required this.password,
  });
}

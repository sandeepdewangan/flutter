import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'package:gallary_app/auth/auth_error.dart';

/*
  Maintain only app state (data)
  Think of what the UI of your app can do and process the 
  data which receives by the user.
*/

@immutable
abstract class AppState {
  // isLoading and AuthError is implemented by all state.
  // we can also put auth error in login and register state.
  final bool isLoading;
  final AuthError? authError;

  const AppState({
    required this.isLoading,
    this.authError,
  });
}

// think of what is needed when the user is logged in.
// we need two things. 1. The user data. 2. All images of user.
// those two requirements will be ours app state data.
@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;

  const AppStateLoggedIn({
    required this.user,
    required this.images,
    required isLoading,
    authError,
  }) : super(isLoading: isLoading, authError: authError);

  // use equality to make sure the app state is changed.
  @override
  bool operator ==(Object other) {
    if (other is AppStateLoggedIn) {
      return other.user.uid == user.uid &&
          other.images.length == images.length &&
          other.isLoading == isLoading;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(user.uid, images);

  // for debugging
  @override
  String toString() => 'AppStateLoggedIn, images.length = ${images.length}';
}

@immutable
class AppStateLogout extends AppState {
  const AppStateLogout({
    required isLoading,
    authError,
  }) : super(isLoading: isLoading, authError: authError);

  @override
  String toString() =>
      'AppStateLogout- isLoading: $isLoading, authError: $authError';
}

@immutable
class AppStateIsInRegistrationView extends AppState {
  const AppStateIsInRegistrationView({
    required isLoading,
    authError,
  }) : super(isLoading: isLoading, authError: authError);

  @override
  String toString() =>
      'AppStateIsInRegistrationView- isLoading: $isLoading, authError: $authError';
}

// get user
extension GetUser on AppState {
  User? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

// get all the images
extension GetImages on AppState {
  Iterable<Reference>? get images {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.images;
    } else {
      return null;
    }
  }
}

/*
 Call API's from here and do more logical stuff.
*/

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallary_app/auth/auth_error.dart';
import 'package:gallary_app/bloc/app_event.dart';
import 'package:gallary_app/bloc/app_state.dart';
import 'package:gallary_app/utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateLogout(isLoading: false)) {
    on<AppEventUploadImage>(((event, emit) async {
      final user = state.user;

      // if user is not present
      if (user == null) {
        emit(const AppStateLogout(isLoading: false));
        return;
      }

      // user is present, start loading process
      emit(AppStateLoggedIn(
        user: user,
        images: state.images ?? [],
        isLoading: true,
      ));
      // upload image
      final file = File(event.filePathToUpload);
      await uploadImage(file: file, userId: user.uid);

      // after upload, get all the images
      final images = await _getImages(user.uid);
      // emit and turn off loading
      emit(AppStateLoggedIn(
        user: user,
        images: images,
        isLoading: false,
      ));
    }));

    // account deletion
    on<AppEventDeleteAccount>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const AppStateLogout(isLoading: false));
        return;
      }
      emit(AppStateLoggedIn(
        user: user,
        images: state.images ?? [],
        isLoading: true,
      ));
      // delete user
      try {
        // delete user images
        final folderContents =
            await FirebaseStorage.instance.ref(user.uid).listAll();
        for (final item in folderContents.items) {
          await item.delete().catchError((_) => {});
        }
        // delete the folder itself
        await FirebaseStorage.instance
            .ref(user.uid)
            .delete()
            .catchError((_) {});
        // delete the user and signed user out
        await user.delete();
        await FirebaseAuth.instance.signOut();
        emit(const AppStateLogout(isLoading: false));
      } on FirebaseAuthException catch (e) {
        emit(AppStateLoggedIn(
          user: user,
          images: state.images ?? [],
          isLoading: false,
          authError: AuthError.from(e),
        ));
      } on FirebaseException {
        // cannot delete folder, logged user out
        emit(const AppStateLogout(isLoading: false));
      }
    });

    on<AppEventLogout>((event, emit) async {
      emit(const AppStateLogout(isLoading: true));
      await FirebaseAuth.instance.signOut();
      emit(const AppStateLogout(isLoading: false));
    });

    on<AppEventInitialize>((event, emit) async {
      // get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const AppStateLogout(isLoading: false));
      } else {
        // grab user data
        final images = await _getImages(user.uid);
        emit(AppStateLoggedIn(
          user: user,
          images: images,
          isLoading: false,
        ));
      }
    });

    on<AppEventRegister>((event, emit) async {
      emit(const AppStateIsInRegistrationView(isLoading: true));
      final email = event.email;
      final password = event.password;
      try {
        final credentials =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        emit(AppStateLoggedIn(
          user: credentials.user!,
          images: [],
          isLoading: false,
        ));
      } on FirebaseAuthException catch (e) {
        emit(AppStateIsInRegistrationView(
          isLoading: false,
          authError: AuthError.from(e),
        ));
      }
    });

    on<AppEventGotoLogin>((event, emit) {
      emit(const AppStateLogout(isLoading: false));
    });

    on<AppEventLogin>((event, emit) async {
      emit(const AppStateLogout(isLoading: true));
      try {
        final email = event.email;
        final password = event.password;
        final userCredentials =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = userCredentials.user!;
        // get all the images
        final images = await _getImages(user.uid);
        emit(AppStateLoggedIn(
          user: user,
          images: images,
          isLoading: false,
        ));
      } on FirebaseAuthException catch (e) {
        emit(AppStateLogout(
          isLoading: false,
          authError: AuthError.from(e),
        ));
      }
    });

    on<AppEventGotoRegistration>((event, emit) {
      emit(const AppStateIsInRegistrationView(isLoading: false));
    });
  }

  // API calls
  // getting all the images from storage
  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}

import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallary_app/bloc/app_bloc.dart';
import 'package:gallary_app/bloc/app_event.dart';
import 'package:gallary_app/bloc/app_state.dart';
import 'package:gallary_app/dialogs/auth_error_dialog.dart';
import 'package:gallary_app/firebase_options.dart';
import 'package:gallary_app/views/login_view.dart';
import 'package:gallary_app/views/photo_gallery_view.dart';
import 'package:gallary_app/views/register_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (context) => AppBloc()..add(const AppEventInitialize()),
      child: MaterialApp(
        title: 'Gallery App',
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            if (appState.isLoading) {
              // Loading Screen
              log('Loading...');
            } else {
              // hide the loading screen
              log('Cancel Loading...');
            }
            final authError = appState.authError;
            if (authError != null) {
              showAuthError(authError: authError, context: context);
            }
          },
          builder: (context, appState) {
            if (appState is AppStateLogout) {
              return const LoginView();
            } else if (appState is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (appState is AppStateIsInRegistrationView) {
              return const RegisterView();
            } else {
              // this will never happen
              return Container();
            }
          },
        ),
      ),
    );
  }
}

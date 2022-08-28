import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/apis/login_api.dart';
import 'package:notes_app/apis/notes_api.dart';
import 'package:notes_app/bloc/actions.dart';
import 'package:notes_app/bloc/bloc.dart';
import 'package:notes_app/bloc/state.dart';
import 'package:notes_app/models.dart';
import 'package:notes_app/views/login_page.dart';
import 'package:notes_app/views/widgets/list_view.dart';

void main() => runApp(const MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login Page"),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            if (appState.isLoading) {
              // loading
              log('Loading...');
            } else {
              // cancel loading
              log('Cancel Loading...');
            }
            // display errors
            final loginError = appState.loginErrors;
            if (loginError != null) {
              // error dialog
              log('Login Error Dialog');
            }
            // if we are logged in and there is no fetched notes.
            if (appState.isLoading == false &&
                appState.loginErrors == null &&
                appState.loginHandle == const LoginHandle.fooBar() &&
                appState.fetchedNotes == null) {
              // add event
              log('Load Note Action Called...');

              context.read<AppBloc>().add(const LoadNotesAction());
            }
          },
          builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              log('Login Page....');
              return const LoginPage();
            } else {
              log('Display all the notes...');
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}

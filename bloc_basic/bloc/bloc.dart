import 'package:bloc/bloc.dart';

import 'package:notes_app/apis/login_api.dart';
import 'package:notes_app/apis/notes_api.dart';
import 'package:notes_app/bloc/actions.dart';
import 'package:notes_app/bloc/state.dart';
import 'package:notes_app/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.empty()) {
    on<LoginAction>((event, emit) async {
      // start loading
      emit(
        const AppState(
            isLoading: true,
            fetchedNotes: null,
            loginErrors: null,
            loginHandle: null),
      );
      // login user
      final loginHandle = await loginApi.login(
        email: event.email,
        password: event.password,
      );
      emit(
        AppState(
            isLoading: false,
            fetchedNotes: null,
            loginErrors: loginHandle == null ? LoginErrors.invalidHandle : null,
            loginHandle: loginHandle),
      );
    });

    on<LoadNotesAction>(
      (event, emit) async {
        // loading
        emit(
          AppState(
              isLoading: true,
              fetchedNotes: null,
              loginErrors: null,
              loginHandle: state.loginHandle),
        );
        // get login handle
        final loginHandle = state.loginHandle;
        // invalid login handle
        if (loginHandle != const LoginHandle.fooBar()) {
          emit(
            AppState(
              isLoading: false,
              fetchedNotes: null,
              loginErrors: LoginErrors.invalidHandle,
              loginHandle: loginHandle,
            ),
          );
          return;
        }
        // valid login handle
        final notes = await notesApi.getNotes(loginHandle: loginHandle!);
        emit(
          AppState(
            isLoading: false,
            fetchedNotes: notes,
            loginErrors: null,
            loginHandle: loginHandle,
          ),
        );
      },
    );
  }
}

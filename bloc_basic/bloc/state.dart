import 'package:notes_app/models.dart';

class AppState {
  final bool isLoading;
  final LoginErrors? loginErrors;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchedNotes;

  // we will start our state with empty state
  const AppState.empty()
      : isLoading = false,
        loginErrors = null,
        loginHandle = null,
        fetchedNotes = null;

  const AppState({
    required this.isLoading,
    required this.loginErrors,
    required this.loginHandle,
    required this.fetchedNotes,
  });

  @override
  String toString() {
    return 'AppState(isLoading: $isLoading, loginErrors: $loginErrors, loginHandle: $loginHandle, fetchedNotes: $fetchedNotes)';
  }
}

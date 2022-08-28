// Events, Actions

abstract class AppAction {
  const AppAction();
}

// define actions here
class LoginAction implements AppAction {
  // when user press login button, what data is passed.
  final String email;
  final String password;

  LoginAction({
    required this.email,
    required this.password,
  });
}

class LoadNotesAction implements AppAction {
  const LoadNotesAction();
}

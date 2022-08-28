import 'package:notes_app/models.dart';

abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({
    required String email,
    required String password,
  });
}

// LoginApi is singleton
class LoginApi implements LoginApiProtocol {
  // singleton pattern
  // const LoginApi._sharedInstance();
  // static const LoginApi _shared = LoginApi._sharedInstance();
  // factory LoginApi.instance() => _shared;

  @override
  Future<LoginHandle?> login(
      {required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'foo@bar.com' && password == 'foobar') {
      return const LoginHandle.fooBar();
    }
    return null;
  }
}

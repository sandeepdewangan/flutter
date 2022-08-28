import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/bloc/actions.dart';
import 'package:notes_app/bloc/bloc.dart';
import 'package:notes_app/views/widgets/input_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InputTextField(controller: emailController, label: 'Enter Email'),
            InputTextField(
                controller: passwordController, label: 'Enter Password'),
            ElevatedButton(
                onPressed: () {
                  context.read<AppBloc>().add(LoginAction(
                      email: emailController.text,
                      password: passwordController.text));
                },
                child: const Text("Login")),
          ],
        ),
      ),
    );
  }
}

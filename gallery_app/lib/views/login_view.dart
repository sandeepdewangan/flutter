import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gallary_app/bloc/app_bloc.dart';
import 'package:gallary_app/bloc/app_event.dart';

class LoginView extends HookWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(text: 'sandeep@gmail.com');
    final passwordController = useTextEditingController(text: 'Sandeep123@');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(hintText: 'Enter email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              hintText: 'Enter password',
            ),
            obscureText: true,
          ),
          TextButton(
            onPressed: () {
              final email = emailController.text;
              final password = passwordController.text;
              context.read<AppBloc>().add(AppEventLogin(
                    email: email,
                    password: password,
                  ));
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              context.read<AppBloc>().add(
                    const AppEventGotoRegistration(),
                  );
            },
            child: const Text('Not register? Register here.'),
          ),
        ]),
      ),
    );
  }
}

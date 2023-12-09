import 'package:flutter/material.dart';
import 'package:tracky/components/styled_button.dart';
import 'package:tracky/components/styled_input.dart';
import 'package:tracky/components/styled_text.dart';
import 'package:tracky/user_auth/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailInputController;
  late TextEditingController _passwordInputController;

  @override
  void initState() {
    super.initState();
    _emailInputController = TextEditingController();
    _passwordInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Widget loginForm() {
      return Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StyledText(text: 'Email'),
            const SizedBox(height: 8),
            StyledInput(
              controller: _emailInputController,
              hint: 'tracky-app@gmail.com',
            ),
            const SizedBox(height: 32),
            const StyledText(text: 'Password'),
            const SizedBox(height: 8),
            StyledInput(
              controller: _passwordInputController,
              hint: '*************',
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              const Image(image: AssetImage('assets/logo64.png')),
              const SizedBox(height: 32),
              const StyledText(text: 'Tracky', type: 'h1'),
              const SizedBox(height: 64),
              loginForm(),
              const SizedBox(height: 64),
              StyledButton(handlePress: () => {}, text: 'Log in'),
              const SizedBox(height: 32),
              const StyledText(text: 'or'),
              const SizedBox(height: 32),
              StyledButton(
                handlePress: () => signInWithGoogle(context),
                text: 'Sign in with Google',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

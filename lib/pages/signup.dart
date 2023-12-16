import 'package:flutter/material.dart';
import 'package:tracky/components/styled_button.dart';
import 'package:tracky/components/styled_input.dart';
import 'package:tracky/components/styled_text.dart';
import 'package:tracky/core/app_themes.dart';
import 'package:tracky/main.dart';
import 'package:tracky/user_auth/auth_services.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late TextEditingController _nameInputController;
  late TextEditingController _emailInputController;
  late TextEditingController _passwordInputController;

  String theme = Main.theme;

  @override
  void initState() {
    super.initState();
    _nameInputController = TextEditingController();
    _emailInputController = TextEditingController();
    _passwordInputController = TextEditingController();
  }

  Widget logoSection() {
    return Column(
      children: [
        Image(image: AssetImage('assets/logo64-$theme.png')),
        const SizedBox(height: 16),
        const StyledText(text: 'Tracky', type: 'h1'),
      ],
    );
  }

  Widget signupForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StyledText(text: 'Name'),
          const SizedBox(height: 8),
          StyledInput(
            controller: _nameInputController,
            hint: 'Emir Tugce',
          ),
          const SizedBox(height: 32),
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
            isPassword: true,
            hint: '*************',
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              const StyledText(
                text: 'You already have an account?',
                type: 'small',
              ),
              const SizedBox(
                width: 4,
              ),
              InkWell(
                onTap: () {
                  navigatorKey.currentState?.pop(context);
                },
                child: const StyledText(
                  text: 'Log in',
                  color: Color.fromRGBO(0, 117, 255, 1),
                  type: 'small',
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget signUpButtons() {
    return Column(
      children: [
        StyledButton(
          handlePress: () => AuthService().signUpWithEmailAndPassword(
            name: _nameInputController.text,
            email: _emailInputController.text,
            password: _passwordInputController.text,
          ),
          text: 'Sign up',
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: theme == 'light'
                    ? const Color.fromRGBO(0, 0, 0, 0.5)
                    : darkTextSmoke,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 31.0),
              child: StyledText(
                text: 'or',
                color: theme == 'light'
                    ? const Color.fromRGBO(0, 0, 0, 0.5)
                    : darkTextSmoke,
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: theme == 'light'
                    ? const Color.fromRGBO(0, 0, 0, 0.5)
                    : darkTextSmoke,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        StyledButton(
          handlePress: () => AuthService().signInWithGoogle(),
          text: 'Sign up with Google',
          type: 'secondary',
          icon: const Image(
            image: AssetImage('assets/google_logo32.png'),
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 55),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                logoSection(),
                const SizedBox(height: 48),
                signupForm(),
                const SizedBox(height: 32),
                signUpButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

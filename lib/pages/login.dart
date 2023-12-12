import 'package:flutter/material.dart';
import 'package:tracky/components/styled_button.dart';
import 'package:tracky/components/styled_input.dart';
import 'package:tracky/components/styled_text.dart';
import 'package:tracky/user_auth/auth_services.dart';
import 'package:tracky/pages/signup.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

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

  Widget logoSection() {
    return const Column(
      children: [
        Image(image: AssetImage('assets/logo64.png')),
        SizedBox(height: 32),
        StyledText(text: 'Tracky', type: 'h1'),
      ],
    );
  }

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
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              const StyledText(
                text: 'You don\'t have an account?',
                type: 'small',
              ),
              const SizedBox(
                width: 4,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupPage(),
                    ),
                  );
                },
                child: const StyledText(
                  text: 'Create one',
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

  Widget loginButtons() {
    return Column(
      children: [
        StyledButton(
          handlePress: () => AuthService().signInWithEmail(
            context,
            emailAddress: _emailInputController.text,
            password: _passwordInputController.text,
          ),
          text: 'Log in',
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: const Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 31.0),
              child: StyledText(text: 'or'),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: const Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        OutlinedButton(
          onPressed: () => AuthService().signInWithGoogle(context),
          style: OutlinedButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
                child: const Center(
                  child: StyledText(
                    text: 'Sign in with Google',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                ),
                child: const Image(
                  image: AssetImage('assets/google_logo32.png'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _wave() {
    return WaveWidget(
      waveFrequency: 4.5,
      wavePhase: 5,
      config: CustomConfig(
        durations: [5000, 4800],
        colors: [
          const Color.fromRGBO(117, 157, 234, 1),
          const Color.fromRGBO(117, 157, 234, 0.4),
        ],
        heightPercentages: [0.2, 0.19],
      ),
      waveAmplitude: 10,
      size: const Size(double.infinity, 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 55),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              logoSection(),
              const SizedBox(height: 64),
              loginForm(),
              const SizedBox(height: 64),
              loginButtons(),
              _wave(),
            ],
          ),
        ),
      ),
    );
  }
}

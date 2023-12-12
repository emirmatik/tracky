import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracky/core/user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('User Email: ${user?.email}'),
        Text('User Name: ${user?.displayName}'),
        ElevatedButton(
          onPressed: () => FirebaseAuth.instance.signOut(),
          child: const Text('log out'),
        )
      ],
    );
  }
}

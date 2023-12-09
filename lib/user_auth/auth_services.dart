import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:tracky/core/user_provider.dart';

Future<User?> signInWithGoogle(BuildContext context) async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

  // ignore: use_build_context_synchronously
  Provider.of<UserProvider>(context, listen: false)
      .setUser(userCredential.user);

  return userCredential.user;
}

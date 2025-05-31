import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inno_boon_interview/feature/home/view/home_screen.dart';
import 'package:inno_boon_interview/feature/authenticate/view/login_screen.dart';

class AuthStateScreen extends StatelessWidget {
  const AuthStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(
              color: Colors.lightBlueAccent,
            ),
          ));
        }

        if (snapshot.hasData) {
          // When firebase return auth information route to this screen
          return HomeScreen();
        } else {
          // When firebase return no auth information route to this screen
          return LoginScreen();
        }
      },
    );
  }
}

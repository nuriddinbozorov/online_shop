import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_shop_uz/screens/home_screen.dart';
import 'auth/login_screen.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream:
          FirebaseAuth.instance.authStateChanges(), // foydalanuvchini kuzatadi
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          // foydalanuvchi mavjud
          return HomeScreen();
        } else {
          // foydalanuvchi yo'q
          return LoginScreen();
        }
      },
    );
  }
}

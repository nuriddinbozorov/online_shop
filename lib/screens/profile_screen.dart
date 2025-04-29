import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser; // Hozir login bo'lgan user

    return Scaffold(
      appBar: AppBar(title: Text('Profil')),
      body:
          user == null
              ? Center(child: Text('Foydalanuvchi topilmadi'))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Profil rasmi
                    CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person, size: 40),
                    ),
                    SizedBox(height: 16),

                    // Ism va Email
                    Text(
                      user.displayName ?? 'Ism kiritilmagan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.email ?? 'Email topilmadi',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 32),

                    // Logout tugmasi
                    ElevatedButton.icon(
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.of(context).pushReplacementNamed(
                          '/login',
                        ); // login sahifaga qaytish
                      },
                      icon: Icon(Icons.logout),
                      label: Text('Chiqish'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Dastur haqida
                    TextButton(
                      onPressed: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Online Do‘kon',
                          applicationVersion: '1.0.0',
                          applicationIcon: Icon(Icons.store),
                          children: [
                            Text(
                              'Bu dastur Online savdo uchun ishlab chiqilgan.',
                            ),
                          ],
                        );
                      },
                      child: Text('Dastur haqida'),
                    ),
                  ],
                ),
              ),
    );
  }
}

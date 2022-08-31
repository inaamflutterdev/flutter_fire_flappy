import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser!.email;
  final creationTime = FirebaseAuth.instance.currentUser!.metadata.creationTime;

  User? user = FirebaseAuth.instance.currentUser;
  verifyEmail() async {
    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text(
            "Verification email has been sent. Check inbox or Spam box",
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User ID: $uid',
              style: const TextStyle(
                fontSize: 17.0,
              ),
            ),
            Row(
              children: [
                Text(
                  'Email: $email',
                  style: const TextStyle(fontSize: 17.0),
                ),
                user!.emailVerified
                    ? const Text(
                        'Verified',
                        style: TextStyle(
                            fontSize: 17.0, color: Colors.greenAccent),
                      )
                    : TextButton(
                        onPressed: () => {verifyEmail()},
                        child: const Text(
                          'Verify Email',
                          style: TextStyle(
                              color: Colors.orangeAccent, fontSize: 17.0),
                        ),
                      ),
              ],
            ),
            Text(
              'Created: $creationTime',
              style: const TextStyle(fontSize: 15.0),
            ),
          ],
        ),
      ),
    );
  }
}

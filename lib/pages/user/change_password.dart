import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_flappy/pages/login.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  var newPassword = "";

  final newPasswordController = TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  changePassword() async {
    try {
      await currentUser!.updatePassword(newPassword);
      FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text(
            "Password has been changed. Login Again",
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 150, 30, 10),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: true,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.grey,
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    controller: newPasswordController,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    }),
                  ),
                ),
              ],
            ),
            Container(
              height: 50,
              width: 200,
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orangeAccent,
                  shadowColor: Colors.orangeAccent,
                  elevation: 10,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      newPassword = newPasswordController.text;
                    });
                    changePassword();
                  }
                },
                child: const Text(
                  'Change Password',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_flappy/pages/login.dart';
import 'package:flutter_fire_flappy/pages/signup.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();

  var email = '';

  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // print("Password reset email has been sent");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text(
            "Password reset email has been sent. Check inbox or Spam box",
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // print("No user found for that Email");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              "No user found for that Email",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text("Reset Password"),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: const Text(
              'Reset link will be send to your email !',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Expanded(
            child: Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          autofocus: false,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.grey,
                              ),
                              labelText: 'Enter your email',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              )),
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            } else if (!value.contains('@')) {
                              return 'Please Enter VALID EMAIL';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 300,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.orangeAccent,
                                  shadowColor: Colors.orangeAccent,
                                  elevation: 10,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      email = emailController.text;
                                    });
                                    resetPassword();
                                  }
                                },
                                child: const Text(
                                  'Send Email',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                              TextButton(
                                  onPressed: () => {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            PageRouteBuilder(
                                                pageBuilder: (context, a, b) =>
                                                    const Login(),
                                                transitionDuration:
                                                    const Duration(seconds: 0)),
                                            (route) => false)
                                      },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color:
                                            Color.fromARGB(255, 109, 108, 108),
                                        fontWeight: FontWeight.bold),
                                  ))
                            ]),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 122, 121, 121),
                              ),
                            ),
                            TextButton(
                              onPressed: () => {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, a, b) =>
                                          const Signup(),
                                      transitionDuration:
                                          const Duration(seconds: 0),
                                    ),
                                    (route) => false)
                              },
                              child: const Text(
                                'SIGN UP',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 109, 108, 108),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

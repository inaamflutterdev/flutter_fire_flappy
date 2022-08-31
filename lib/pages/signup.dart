import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_flappy/pages/login.dart';
// ignore: depend_on_referenced_packages
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";
  var confirmPassword = "";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  registration() async {
    if (password == confirmPassword) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        // print(userCredential);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Registered Successfully. Please Login",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // print("Password provided is too Weak");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password provided is too Weak",
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          // print("Account already exists");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account already exists",
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
          );
        }
      }
    } else {
      // print("Password and Confirm Password not match");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Password and Confirm Password not match",
            style: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: ListView(
              children: [
                Container(
                  color: Colors.white,
                  child: ClipPath(
                    clipper: ProsteThirdOrderBezierCurve(
                      position: ClipPosition.bottom,
                      list: [
                        ThirdOrderBezierCurveSection(
                          p1: const Offset(0, 0),
                          p2: const Offset(0, 200),
                          p3: Offset(screenWidth, 50),
                          p4: Offset(screenWidth, 200),
                        ),
                      ],
                    ),
                    child: Container(
                      height: 220,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ),
                Container(
                    color: Colors.white,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 40),
                    )),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: TextFormField(
                    autofocus: false,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.orangeAccent,
                        ),
                        labelText: 'youremail@gmail.com',
                        labelStyle: TextStyle(
                          color: Colors.orangeAccent,
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
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
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
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: true,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.grey,
                        ),
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                          width: 340,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orangeAccent,
                              shadowColor: Colors.orangeAccent,
                              elevation: 10,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  email = emailController.text;
                                  password = passwordController.text;
                                  confirmPassword =
                                      confirmPasswordController.text;
                                });
                                registration();
                              }
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        ),
                      ]),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    "Already have an Account? ",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color.fromARGB(255, 122, 121, 121),
                    ),
                  ),
                  TextButton(
                    onPressed: () => {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                const Login(),
                            transitionDuration: const Duration(seconds: 0)),
                      )
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 17,
                          color: Color.fromARGB(255, 109, 108, 108),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
              ],
            ),
          )),
    );
  }
}

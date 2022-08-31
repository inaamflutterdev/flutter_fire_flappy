import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_flappy/pages/forget_password.dart';
import 'package:flutter_fire_flappy/pages/signup.dart';
import 'package:flutter_fire_flappy/pages/user/user_main.dart';
// ignore: depend_on_referenced_packages
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  var email = '';
  var password = '';

  bool isChecked = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late Box box1;

  @override
  void initState() {
    super.initState();
    createBox();
  }

  void createBox() async {
    //hive kia? PKG hy jesy. Shared_ pref wala hy theek
    box1 = await Hive.openBox('logindata');
    getData();
  }

  void getData() async {
    if (box1.get('email') != null) {
      emailController.text = box1.get('email');
    }
    if (box1.get('password') != null) {
      passwordController.text = box1.get('password');
    }
  }

  userLogin() async {
    if (isChecked) {
      box1.put('email', emailController.value.text);
      box1.put('password', passwordController.value.text);
    }
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UserMain(),
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
      } else if (e.code == 'wrong-password') {
        // print("Wrong password provided by User");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              "Wrong password provided by User",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
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
                    height: 200,
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
              Container(
                  color: Colors.white,
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 40),
                  )),
              Container(
                color: Colors.white,
                // color: Colors.redAccent,
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                // margin: const EdgeInsets.symmetric(
                //   vertical: 10.0,
                // ),
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
                      return 'Please enter email';
                    } else if (!value.contains('@')) {
                      return 'Please Enter VALID EMAIL';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
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
                alignment: AlignmentDirectional.centerEnd,
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 40),
                width: MediaQuery.of(context).size.width,
                // color: Colors.red,
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.only(right: 30)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const ForgetPassword())),
                    );
                  },
                  child: const Text(
                    'Forgot Password ?',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      // padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      height: 50,
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
                            });
                            userLogin();
                          }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Remember me",
                    style: TextStyle(
                      color: Color.fromARGB(255, 94, 92, 92),
                      fontSize: 20.0,
                    ),
                  ),
                  Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        isChecked = !isChecked;
                        setState(() {});
                      })
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                              pageBuilder: (context, a, b) => const Signup(),
                              transitionDuration: const Duration(seconds: 0),
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
        ),
      ),
    );
  }
}

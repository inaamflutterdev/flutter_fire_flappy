import 'package:flutter/cupertino.dart';

class Bird extends StatelessWidget {
  const Bird({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 70,
      child: Image.asset('assets/images/bird.png'),
    );
  }
}

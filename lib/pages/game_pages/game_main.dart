import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_flappy/pages/game_pages/barriers.dart';
import 'package:flutter_fire_flappy/pages/game_pages/bird.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  late int score = 0;
  late int bestScore = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  static double barrierXone = 2;
  double barrierXtwo = barrierXone + 1.5;

  void jump() {
    setState(() {
      time = 0;
      score += 1;
      initialHeight = birdYaxis;
    });
    if (score >= bestScore) {
      // yeh ab dekho kia logic bnao ge data read or write to hora
      bestScore = bestScore;
    }
  }

  // ignore: non_constant_identifier_names
  bool BirdIsDead() {
    if (birdYaxis > 0.6 || birdYaxis < -0.5) {
      return true;
    } else {
      return false;
    }
  }

  void startGame() {
    gameHasStarted = true;
    score = 0;
    Timer.periodic(const Duration(milliseconds: 40), (timer) {
      time += 0.04;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYaxis = initialHeight - height;
        setState(() {
          if (barrierXone < -1.1) {
            barrierXone += 2.2;
          } else {
            barrierXone -= 0.05;
          }
        });

        if (BirdIsDead()) {
          timer.cancel();
          _showDialog();
        }

        setState(() {
          if (barrierXtwo < -1.1) {
            barrierXtwo += 2.2;
          } else {
            barrierXtwo -= 0.05;
          }
        });
      });
      if (birdYaxis > 1) {
        timer.cancel();
        gameHasStarted = false;
      }
    });
  }

  Future<void> resetGame() async {
    Navigator.pop(context);
    await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'score': score,
    });
    setState(() {
      birdYaxis = 0;
      gameHasStarted = false;
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  // ignore: unused_element
  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black12,
            title: Center(
              child: Image.asset(
                'assets/images/gameover.png',
                width: 80,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () async => resetGame(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: 50,
                        width: 250,
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('user')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              // ignore: avoid_print
                              print(snapshot.data!.docs.length);
                              var data = snapshot.data!.docs[0];
                              var uid = data.id;
                              var score = data['score'];
                              return ListView.builder(
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return Text(
                                    '$uid  $score',
                                    style: const TextStyle(color: Colors.white),
                                  );
                                },
                              );
                            }),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          ' Start Again ',
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // final Future<FirebaseApp> _initialzation = Firebase.initiaizeApp;
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: const Duration(milliseconds: 0),
                    color: Colors.lightBlueAccent,
                    child: const Bird(),
                  ),
                  Container(
                    alignment: const Alignment(0, -0.99),
                    child: gameHasStarted
                        ? const Text('')
                        : Image.asset(
                            'assets/images/play.png',
                            width: 150,
                          ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, 1.1),
                    duration: const Duration(milliseconds: 0),
                    child: Barriers(
                      size: 200,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, -1.3),
                    duration: const Duration(milliseconds: 0),
                    child: Barriers(
                      size: 200,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, 1.2),
                    duration: const Duration(milliseconds: 0),
                    child: Barriers(
                      size: 150,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, -1.2),
                    duration: const Duration(milliseconds: 0),
                    child: Barriers(
                      size: 250,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 10,
              color: Colors.amber,
            ),
            Expanded(
              child: Container(
                color: Colors.lightGreen,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/score.png',
                            width: 60,
                          ),
                          const Text(
                            "Score",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                          Text(
                            "$score",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Image.asset(
                            'assets/images/best.png',
                            width: 60,
                          ),
                          const Text(
                            "Best Score",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                  //dobra reset ho jata hy  zahir h score change hojata
                                } else if (snapshot.hasData) {
                                  // print(snapshot.data!.data()!['score']);
                                  return Text(
                                    snapshot.data!.data()!['score'].toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    bestScore.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
//is ki zrort hy? Future
                              })
                        ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// 

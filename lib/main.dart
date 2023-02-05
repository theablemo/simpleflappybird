import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Bird',
      home: FlappyBird(),
    );
  }
}

class FlappyBird extends StatefulWidget {
  @override
  _FlappyBirdState createState() => _FlappyBirdState();
}

class _FlappyBirdState extends State<FlappyBird> {
  double birdY = 300;
  double birdSpeed = 0;
  List<double> pipesX = [400, 700];
  List<double> pipesY = [0, 0];
  int score = 0;
  bool isDead = false;
  late Timer timer;
  // late Timer addPipeTimer;

  void startGame() {
    setState(() {
      birdY = 300;
      birdSpeed = 0;
      pipesX = [400, 700];
      pipesY = [100, 200];
      score = 0;
      isDead = false;
    });

    timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      if (isDead) {
        timer.cancel();
        return;
      }
      setState(() {
        birdSpeed += 0.75;
        birdY += birdSpeed;
        for (int i = 0; i < pipesX.length; i++) {
          pipesX[i] -= 5;
          if (pipesX[i] + 50 < 0) {
            pipesX[i] = 700;
            pipesY[i] = Random().nextDouble() * 300;
          }
        }
        if (birdY >= 600 || birdY <= 0) {
          isDead = true;
        }
        for (int i = 0; i < pipesX.length; i++) {
          if (pipesX[i] <= 100 && pipesX[i] + 50 >= 100) {
            if (birdY <= pipesY[i] || birdY >= pipesY[i] + 200) {
              isDead = true;
            }
          }
          if (pipesX[i] == 100) {
            score++;
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startGame();
    print("Inja");
  }

  @override
  void dispose() {
    timer.cancel();
    // addPipeTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            print("Tapped");
            setState(() {
              birdSpeed = -10;
            });
          },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: CustomPaint(
              painter: _GamePainter(
                birdY: birdY,
                birdSpeed: birdSpeed,
                pipesX: pipesX,
                pipesY: pipesY,
                score: score,
                isDead: isDead,
              ),
            ),
          ),
        ),
        if (isDead)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 200,
                height: 100,
                child: GestureDetector(
                  onTap: () {
                    startGame();
                  },
                  child: Container(
                    width: 200,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        'Restart',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _GamePainter extends CustomPainter {
  double birdY;
  double birdSpeed;
  List<double> pipesX;
  List<double> pipesY;
  int score;
  bool isDead;

  _GamePainter({
    required this.birdY,
    required this.birdSpeed,
    required this.pipesX,
    required this.pipesY,
    required this.score,
    required this.isDead,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.red;
    canvas.drawCircle(
      Offset(100, birdY),
      20,
      paint,
    );

    for (int i = 0; i < pipesX.length; i++) {
      paint.color = Colors.green;
      canvas.drawRect(
        Rect.fromLTWH(pipesX[i], 0, 50, pipesY[i]),
        paint,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          pipesX[i],
          pipesY[i] + 200,
          50,
          600 - pipesY[i] - 200,
        ),
        paint,
      );
    }

    // draw score
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '$score',
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(canvas, Offset(size.width - 50, 50));

    // paint.color = Colors.black;
    // paint.textAlign = TextAlign.center;
    // paint.textBaseline = TextBaseline.alphabetic;
    // paint.fontSize = 30;
    // canvas.drawText(
    //   'Score: $score',
    //   Offset(350, 50),
    //   paint,
    // );
    if (isDead) {
      TextPainter gameOverPainter = TextPainter(
        text: TextSpan(
          text: 'Game Over',
          style: TextStyle(
            color: Colors.red,
            fontSize: 60,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      gameOverPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      gameOverPainter.paint(
        canvas,
        Offset(size.width / 2 - gameOverPainter.width / 2, 10),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

@override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: FlappyBird(),
    ),
  );
}

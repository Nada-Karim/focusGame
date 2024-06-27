import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(FocusGame());
}

class FocusGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Color> colorSequence = [];
  List<Color> userSequence = [];
  int level = 1;
  bool showSequence = true;
  int currentStep = 0;
  Random random = Random();

  void generateSequence() {
    colorSequence = [];
    for (int i = 0; i < level; i++) {
      colorSequence.add(Colors.primaries[random.nextInt(Colors.primaries.length)]);
    }
  }

  void startNewLevel() {
    setState(() {
      userSequence = [];
      currentStep = 0;
      level++;
      showSequence = true;
      generateSequence();
      showColorSequence();
    });
  }

  void showColorSequence() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentStep < colorSequence.length) {
        setState(() {
          showSequence = true;
        });
        Timer(Duration(milliseconds: 500), () {
          setState(() {
            showSequence = false;
            currentStep++;
          });
        });
      } else {
        timer.cancel();
        setState(() {
          currentStep = 0;
        });
      }
    });
  }

  void onColorButtonPressed(Color color) {
    setState(() {
      userSequence.add(color);
      if (userSequence.length == colorSequence.length) {
        if (userSequence.toString() == colorSequence.toString()) {
          startNewLevel();
        } else {
          showGameOverDialog();
        }
      }
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("You reached level $level"),
          actions: [
            TextButton(
              child: Text("Restart"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  level = 1;
                  startNewLevel();
                });
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    generateSequence();
    showColorSequence();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Focus Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showSequence && currentStep < colorSequence.length)
            Container(
              height: 100,
              width: 100,
              color: colorSequence[currentStep],
            ),
          if (!showSequence || currentStep >= colorSequence.length)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: Colors.primaries.map((color) {
                return ElevatedButton(
                  onPressed: () => onColorButtonPressed(color),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    minimumSize: Size(50, 50),
                  ),
                  child: Container(),
                );
              }).toList(),
            ),
          SizedBox(height: 20),
          Text(
            'Level: $level',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}

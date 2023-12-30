import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tetris/button.dart';
import 'package:tetris/icon_button.dart';
import 'package:tetris/tile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'PressStart2P'),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int numberOfSquares = 180;
  int numberOfSquaresInRow = 10;
  int randomNumber = 0;
  int score = 0;

  Timer? timer;
  Duration duration = const Duration(milliseconds: 50);
  Duration defaultDuration = const Duration(milliseconds: 600);

  bool hasGameStarted = false;
  bool isChangedDuration = false;

  List<int> I = [4, 14, 24, 34];
  List<int> O = [4, 5, 14, 15];
  List<int> T = [4, 5, 15, 6];
  List<int> J = [24, 5, 15, 25];
  List<int> L = [4, 14, 24, 25];
  List<int> S = [14, 5, 15, 6];
  List<int> Z = [4, 5, 15, 16];
  List<int> chosenTile = [];
  List<List<int>> allTiles = [];

  List<BoolColor> myGrid = [];

  @override
  void initState() {
    createMyGrid();
    super.initState();
  }

  void createMyGrid() {
    for (int i = 0; i < numberOfSquares; i++) {
      myGrid.add(BoolColor(value: false));
    }
  }

  void clearMyGrid() {
    for (int i = 0; i < numberOfSquares; i++) {
      myGrid[i] = BoolColor(value: false);
    }
  }

  void startGame() {
    score = 0;
    hasGameStarted = true;
    allTiles = [
      [...I],
      [...O],
      [...T],
      [...J],
      [...L],
      [...S],
      [...Z]
    ];
    clearMyGrid();
    chooseTile();
    startTimer(defaultDuration);
  }

  void startTimer(Duration duration) {
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        moveDown();
        clearRow();
        gameOver();
      });
    });
  }

  void changeTimerSpeed() {
    timer!.cancel();
    startTimer(duration);
    isChangedDuration = true;
  }

  void chooseTile() {
    if (isChangedDuration) {
      timer!.cancel();
      startTimer(defaultDuration);
      isChangedDuration = false;
    }
    randomNumber = Random().nextInt(7);
    chosenTile = [...allTiles[randomNumber]];
  }

  Color getProperColor() {
    switch (randomNumber) {
      case 0:
        return Colors.purple;
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.pink;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.green;
      case 6:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  int getMaxNumber() {
    return chosenTile.reduce(
        (currentMax, number) => number > currentMax ? number : currentMax);
  }

  void moveDown() {
    bool shouldStop = false;

    for (int index in chosenTile) {
      int newIndex = index + numberOfSquaresInRow;
      if (newIndex < myGrid.length && myGrid[newIndex].value) {
        shouldStop = true;
        break;
      }
    }

    if (shouldStop) {
      for (int i = 0; i < chosenTile.length; i++) {
        myGrid[chosenTile[i]] = BoolColor(value: true, color: getProperColor());
      }
      chooseTile();
    } else {
      if ((getMaxNumber() >= numberOfSquares - numberOfSquaresInRow)) {
        for (int i = 0; i < chosenTile.length; i++) {
          myGrid[chosenTile[i]] =
              BoolColor(value: true, color: getProperColor());
        }
        chooseTile();
      } else {
        for (int i = 0; i < chosenTile.length; i++) {
          chosenTile[i] += numberOfSquaresInRow;
        }
      }
    }
  }

  void moveLeft() {
    if (chosenTile.first % numberOfSquaresInRow != 0) {
      for (int i = 0; i < chosenTile.length; i++) {
        chosenTile[i] -= 1;
      }
    }
  }

  void moveRight() {
    if (chosenTile.last % numberOfSquaresInRow != numberOfSquaresInRow - 1) {
      for (int i = 0; i < chosenTile.length; i++) {
        chosenTile[i] += 1;
      }
    }
  }

  void clearRow() {
    int rowCount = numberOfSquares ~/ numberOfSquaresInRow;

    for (int row = 0; row < rowCount; row++) {
      bool isRowFull = true;

      for (int col = 0; col < numberOfSquaresInRow; col++) {
        int index = row * numberOfSquaresInRow + col;
        if (!myGrid[index].value) {
          isRowFull = false;
          break;
        }
      }

      if (isRowFull) {
        score++;
        for (int col = 0; col < numberOfSquaresInRow; col++) {
          int index = row * numberOfSquaresInRow + col;
          myGrid[index].value = false;

          for (int aboveRow = row - 1; aboveRow >= 0; aboveRow--) {
            int aboveIndex = aboveRow * numberOfSquaresInRow + col;
            if (myGrid[aboveIndex].value) {
              myGrid[aboveIndex].value = false;
              int newIndex = aboveIndex + 10;
              if (newIndex < myGrid.length) {
                myGrid[newIndex].value = true;
                myGrid[newIndex].color = myGrid[aboveIndex].color;
              }
            }
          }
        }
      }
    }
  }

  bool isGameOver() {
    bool shouldStop = false;

    for (int index in chosenTile) {
      if (index < myGrid.length && myGrid[index].value) {
        shouldStop = true;
        break;
      }
    }

    return shouldStop;
  }

  void gameOver() {
    if (isGameOver()) {
      timer!.cancel();
      hasGameStarted = false;
      gameOverBaner();
    }
  }

  void gameOverBaner() {
    showDialog(
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: AlertDialog(
                  elevation: 0,
                  backgroundColor: Colors.grey[900],
                  title: const Center(
                    child: Text('Game Over!',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Your score: $score',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16)),
                      const SizedBox(height: 5),
                      const MyButton(title: "Okay!"),
                    ],
                  )),
            ));
  }

  void rotateRight() {
    if (randomNumber != 1) {
      List<int> newPositions = [];
      int pivot = chosenTile[1];

      for (int tile in chosenTile) {
        int x = tile % numberOfSquaresInRow;
        int y = tile ~/ numberOfSquaresInRow;
        int pivotX = pivot % numberOfSquaresInRow;
        int pivotY = pivot ~/ numberOfSquaresInRow;

        int newX = pivotY - y + pivotX;
        int newY = x - pivotX + pivotY;

        int newIndex = newY * numberOfSquaresInRow + newX;

        newPositions.add(newIndex);
      }

      setState(() {
        chosenTile = newPositions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: numberOfSquares,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numberOfSquaresInRow),
              itemBuilder: (context, index) {
                if (chosenTile.contains(index)) {
                  return Tile(color: getProperColor());
                } else if (myGrid[index].value == true) {
                  return Tile(color: myGrid[index].color);
                } else {
                  return Tile(color: Colors.grey[900]);
                }
              },
            ),
          ),
          Row(
            children: [
              MyIconButton(
                  onPressed: () {
                    if (!hasGameStarted) startGame();
                  },
                  icon: Icons.play_arrow),
              const SizedBox(width: 5),
              MyIconButton(
                  onPressed: () {
                    timer?.cancel();
                    setState(() {
                      hasGameStarted = false;
                    });
                  },
                  icon: Icons.stop),
              const Spacer(),
              MyIconButton(
                  onPressed: moveLeft, icon: Icons.arrow_back_ios_new_rounded),
              const SizedBox(width: 5),
              MyIconButton(
                  onPressed: moveRight, icon: Icons.arrow_forward_ios_rounded),
              const SizedBox(width: 5),
              MyIconButton(onPressed: rotateRight, icon: Icons.rotate_right),
              const SizedBox(width: 5),
              MyIconButton(
                  onPressed: changeTimerSpeed,
                  icon: Icons.keyboard_arrow_down,
                  iconSize: 30),
            ],
          )
        ],
      ),
    );
  }
}

class BoolColor {
  bool value;
  Color? color;

  BoolColor({required this.value, this.color});
}

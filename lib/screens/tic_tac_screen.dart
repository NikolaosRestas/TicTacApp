import 'package:flutter/material.dart';

class GamePageScreen extends StatefulWidget {
  const GamePageScreen({super.key});

  @override
  _GamePageScreenState createState() => _GamePageScreenState();
}

class _GamePageScreenState extends State<GamePageScreen> {
  String player_x = "X";
  String player_o = "O";

  late String current_player;
  late bool game_end;
  late List<String> occupied = [];

  @override
  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame() {
    current_player = player_x;
    game_end = false;
    occupied = ["", "", "", "", "", "", "", "", ""];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _headerText(),
            _gameContainer(),
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return Column(
      children: <Widget>[
        const Text(
          'TIC TAC',
          style: TextStyle(
            color: Colors.pink,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$current_player turn',
          style: TextStyle(
            color: Colors.purple[900],
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _gameContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      margin: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: occupied.length,
        itemBuilder: (context, index) {
          return _box(index);
        },
      ),
    );
  }

  Widget _box(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          if (game_end || occupied[index].isNotEmpty) {
            return;
          }

          occupied[index] = current_player;
          changeTurn();
          winner();
        });
      },
      child: Container(
        color: occupied[index].isEmpty
            ? Colors.grey
            : occupied[index] == player_x
                ? Colors.blue
                : Colors.orange,
        margin: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            occupied[index],
            style: const TextStyle(
                fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }

  void changeTurn() {
    if (current_player == player_x) {
      current_player = player_o;
    } else {
      current_player = player_x;
    }
  }

  void winner() {
    List<List<int>> winningList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pos in winningList) {
      String playerPosition0 = occupied[pos[0]];
      String playerPosition1 = occupied[pos[1]];
      String playerPosition2 = occupied[pos[2]];

      if (playerPosition0.isNotEmpty) {
        if (playerPosition0 == playerPosition1 &&
            playerPosition0 == playerPosition2) {
          showGameOverMessage("player $playerPosition0 won");
          game_end = true;
          return;
        }
      }
    }
  }

  void showGameOverMessage(String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Game over $s',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlue
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../data/word_pairs.dart';
import 'vote_screen.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  final GameState gameState;
  GameScreen({required this.gameState});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int currentIndex = 0;
  bool showWord = false;

  @override
  void initState() {
    super.initState();
    assignRoles();
  }

void assignRoles() {
  final availablePairs = wordPairs.where((pair) =>
    !widget.gameState.usedPairs.any((used) => used[0] == pair[0] && used[1] == pair[1])
  ).toList();

  if (availablePairs.isEmpty) {
    // Plus de paires dispo — gère ça comme tu veux
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Plus de paires disponibles.'))
    );
    return;
  }

  final pair = availablePairs[Random().nextInt(availablePairs.length)];
  widget.gameState.usedPairs.add(pair); // Marque cette paire comme utilisée ✅

  int undercoverCount = widget.gameState.players.length >= 6 ? 2 : 1;
  List<Player> players = widget.gameState.players;

  players.shuffle();
  for (int i = 0; i < players.length; i++) {
    if (i < undercoverCount) {
      players[i].role = pair[1]; // undercover word
      players[i].isUndercover = true;
    } else {
      players[i].role = pair[0]; // villageois word
      players[i].isUndercover = false;
    }
  }
}


  void nextPlayer() {
    if (currentIndex < widget.gameState.players.length - 1) {
      setState(() {
        currentIndex++;
        showWord = false;
      });
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => VoteScreen(gameState: widget.gameState)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordered = widget.gameState.orderedPlayers;
    return Scaffold(
      appBar: AppBar(title: Text('Cartes')),
      body: Center(
        child: showWord
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${ordered[currentIndex].name}, ton mot est:'),
                SizedBox(height: 20),
                Text(ordered[currentIndex].role, style: TextStyle(fontSize: 32)),
                ElevatedButton(child: Text('Suivant'), onPressed: nextPlayer),
              ],
            )
          : ElevatedButton(
              child: Text('${ordered[currentIndex].name} Voir ma carte'),
              onPressed: () => setState(() => showWord = true),
            ),
      ),
    );
  }
}

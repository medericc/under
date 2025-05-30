import 'package:flutter/material.dart';
import '../models/game_state.dart';
import 'game_screen.dart';

class ScoreScreen extends StatelessWidget {
  final GameState gameState;

  ScoreScreen({required this.gameState});

  @override
  Widget build(BuildContext context) {
    // Classement des joueurs par score décroissant
    final sortedPlayers = List.from(gameState.players)
      ..sort((a, b) => b.score.compareTo(a.score));

    // Vérifie s'il y a un joueur à 25+
    final winner = sortedPlayers.firstWhere(
      (p) => p.score >= 25,
      orElse: () => sortedPlayers.first,
    );

    final hasWinner = winner.score >= 25;

    return Scaffold(
      appBar: AppBar(title: Text('Fin de la Partie')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              hasWinner
                  ? '🏆 ${winner.name} a remporté la partie !'
                  : '🎮 Fin du round',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Classement :', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            ...sortedPlayers.map((p) => Text(
                  '${p.name} — ${p.score} pts',
                  style: TextStyle(fontSize: 16),
                )),
            SizedBox(height: 30),
            if (!hasWinner)
              ElevatedButton(
                child: Text('Lancer un nouveau tour'),
                onPressed: () {
                  gameState.nextRound();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => GameScreen(gameState: gameState)),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

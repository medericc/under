import 'package:flutter/material.dart';
import '../models/player.dart';
import 'game_screen.dart';
import '../models/game_state.dart';

class PlayerInputScreen extends StatefulWidget {
  @override
  _PlayerInputScreenState createState() => _PlayerInputScreenState();
}

class _PlayerInputScreenState extends State<PlayerInputScreen> {
  int playerCount = 4;
  List<TextEditingController> controllers = List.generate(8, (_) => TextEditingController());

  bool allNamesFilled() {
    return controllers.take(playerCount).every((c) => c.text.trim().isNotEmpty);
  }

  void startGame() {
    final players = controllers.take(playerCount).map((c) => Player(name: c.text.trim())).toList();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(gameState: GameState(players: players)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Entrez les joueurs')),
      body: Column(
        children: [
          DropdownButton<int>(
            value: playerCount,
            onChanged: (val) {
              setState(() {
                playerCount = val!;
              });
            },
            items: [4, 5, 6, 7, 8]
                .map((n) => DropdownMenuItem(
                      value: n,
                      child: Text('$n joueurs'),
                    ))
                .toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: playerCount,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: TextField(
                  controller: controllers[index],
                  decoration: InputDecoration(labelText: 'Joueur ${index + 1}'),
                  onChanged: (_) => setState(() {}), // Met à jour le bouton
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: allNamesFilled() ? startGame : null,
              child: Text('Lancer la partie'),
            ),
          ),
        ],
      ),
    );
  }
}

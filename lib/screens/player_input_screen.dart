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
  final List<TextEditingController> controllers = List.generate(8, (_) => TextEditingController());

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
      backgroundColor: const Color(0xFF0A1E3F), // Bleu foncé profond
      appBar: AppBar(
        title: const Text(
          'Entrez les joueurs',
          style: TextStyle(
            color: Color(0xFFD4AF37), // Doré
            fontFamily: 'Cinzel', // Police stylisée (à importer)
          ),
        ),
        backgroundColor: const Color(0xFF1B263B), // Bleu légèrement plus clair
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: Column(
        children: [
          // Sélecteur de nombre de joueurs
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B263B).withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFD4AF37)), // Bordure dorée
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<int>(
              dropdownColor: const Color(0xFF1B263B),
              value: playerCount,
              onChanged: (val) => setState(() => playerCount = val!),
              items: [4, 5, 6, 7, 8].map((n) => DropdownMenuItem(
                value: n,
                child: Text(
                  '$n joueurs',
                  style: const TextStyle(
                    color: Color(0xFFFDF6E3), // Blanc crème
                    fontSize: 16,
                  ),
                ),
              )).toList(),
              underline: const SizedBox(), // Supprime la ligne par défaut
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFD4AF37)),
              isExpanded: true,
              style: const TextStyle(color: Color(0xFFFDF6E3)),
            ),
          ),

          // Liste des champs de texte
          Expanded(
            child: ListView.builder(
              itemCount: playerCount,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: controllers[index],
                  style: const TextStyle(color: Color(0xFFFDF6E3)), // Texte crème
                  decoration: InputDecoration(
                    labelText: 'Joueur ${index + 1}',
                    labelStyle: TextStyle(color: const Color(0xFFD4AF37).withOpacity(0.7)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.5)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD4AF37)),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1B263B).withOpacity(0.5),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),
          ),

          // Bouton de lancement
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: allNamesFilled() ? startGame : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37).withOpacity(0.9), // remplace 'primary'
                foregroundColor: const Color(0xFF0A1E3F), // remplace 'onPrimary'
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: const Color(0xFFFDF6E3).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                elevation: 4,
                shadowColor: const Color(0xFFD4AF37).withOpacity(0.3),
              ),
              child: const Text(
                'Lancer la partie',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
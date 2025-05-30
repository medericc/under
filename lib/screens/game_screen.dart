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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plus de paires disponibles.'))
        );
      });
      return;
    }

    final pair = availablePairs[Random().nextInt(availablePairs.length)];
    widget.gameState.usedPairs.add(pair);

    int undercoverCount = widget.gameState.players.length >= 6 ? 2 : 1;

    List<Player> players = widget.gameState.players;
    players.shuffle();

    final undercoverPlayers = players.sublist(0, undercoverCount);

    for (var player in players) {
      if (undercoverPlayers.contains(player)) {
        player.role = pair[1];
        player.isUndercover = true;
      } else {
        player.role = pair[0];
        player.isUndercover = false;
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
    final player = ordered[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0A1E3F),
      appBar: AppBar(
        title: const Text(
          'Révélation des Rôles',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontFamily: 'Cinzel',
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFF1B263B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/parchment_texture.png'),
            opacity: 0.05,
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // En-tête avec nom du joueur
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  player.name.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              // Carte centrale
              Expanded(
                child: GestureDetector(
                  onTap: !showWord ? () => setState(() => showWord = true) : null,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: showWord
                        ? Container(
                            key: const ValueKey('revealed'),
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B263B).withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: player.isUndercover 
                                    ? Colors.red.withOpacity(0.5)
                                    : const Color(0xFFD4AF37).withOpacity(0.7),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFD4AF37).withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'TON MOT SACRÉ',
                                  style: TextStyle(
                                    color: const Color(0xFFFDF6E3).withOpacity(0.7),
                                    fontSize: 16,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  player.role,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: player.isUndercover
                                        ? Colors.red[300]
                                        : const Color(0xFFD4AF37),
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (player.isUndercover)
                                  Text(
                                    '(Undercover)',
                                    style: TextStyle(
                                      color: Colors.red[200],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : Container(
                            key: const ValueKey('hidden'),
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 200,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B263B).withOpacity(0.6),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(0xFFD4AF37).withOpacity(0.4),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.contact_page_outlined,
                                  size: 50,
                                  color: const Color(0xFFD4AF37).withOpacity(0.6),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Touche pour révéler\nla carte',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFFFDF6E3).withOpacity(0.8),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ),
                  ),
                ),
              

              // Bouton d'action
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: showWord ? nextPlayer : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showWord ? const Color(0xFFD4AF37) : const Color(0xFF1B263B),
                    foregroundColor: showWord ? const Color(0xFF0A1E3F) : const Color(0xFFFDF6E3).withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: showWord 
                            ? const Color(0xFFFDF6E3).withOpacity(0.3)
                            : Colors.transparent,
                      ),
                    ),
                    elevation: showWord ? 4 : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (showWord) const Icon(Icons.arrow_forward, size: 22),
                      SizedBox(width: showWord ? 10 : 0),
                      Text(
                        showWord ? 'PASSER AU PROCHAIN' : 'CARTE CACHÉE',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
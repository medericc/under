import 'package:flutter/material.dart';
import '../models/game_state.dart';
import 'game_screen.dart';

class ScoreScreen extends StatelessWidget {
  final GameState gameState;

  ScoreScreen({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final sortedPlayers = List.from(gameState.players)
      ..sort((a, b) => b.score.compareTo(a.score));

    final winner = sortedPlayers.firstWhere(
      (p) => p.score >= 25,
      orElse: () => sortedPlayers.first,
    );

    final hasWinner = winner.score >= 25;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1E3F), // Bleu foncé profond
      appBar: AppBar(
        title: Text(
          hasWinner ? 'Couronnement' : 'Archives du Round',
          style: const TextStyle(
            color: Color(0xFFD4AF37), // Doré
            fontFamily: 'Cinzel', // Police stylisée
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFF1B263B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: Container(
       
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bannière du vainqueur
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasWinner ? const Color(0xFFD4AF37) : const Color(0xFFFDF6E3).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Text(
                  hasWinner
                      ? '👑 ${winner.name} règne en maître !'
                      : '📜 Chroniques du round',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Tableau des scores
              Text(
                'Tableau des Sages:',
                style: TextStyle(
                  color: const Color(0xFFFDF6E3).withOpacity(0.9),
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 15),
              
              Expanded(
                child: ListView.separated(
                  itemCount: sortedPlayers.length,
                  separatorBuilder: (_, __) => Divider(
                    color: const Color(0xFFD4AF37).withOpacity(0.2),
                    height: 12,
                  ),
                  itemBuilder: (context, index) {
                    final player = sortedPlayers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF1B263B),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Color(0xFFD4AF37),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        player.name,
                        style: const TextStyle(
                          color: Color(0xFFFDF6E3),
                          fontSize: 18,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B263B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: player == winner 
                                ? const Color(0xFFD4AF37) 
                                : const Color(0xFFFDF6E3).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          '${player.score} pts',
                          style: TextStyle(
                            color: player == winner 
                                ? const Color(0xFFD4AF37) 
                                : const Color(0xFFFDF6E3).withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bouton de nouvelle partie
              if (!hasWinner)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      gameState.nextRound();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => GameScreen(gameState: gameState)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37).withOpacity(0.9),
                      foregroundColor: const Color(0xFF0A1E3F),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: const Color(0xFFFDF6E3).withOpacity(0.3),
                        ),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.autorenew, size: 22),
                        SizedBox(width: 10),
                        Text(
                          'Défier à nouveau',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
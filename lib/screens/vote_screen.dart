import 'package:flutter/material.dart';
import '../models/game_state.dart';
import 'score_screen.dart';
import 'game_screen.dart';

class VoteScreen extends StatefulWidget {
  final GameState gameState;
  VoteScreen({required this.gameState});

  @override
  _VoteScreenState createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  Map<String, int> votes = {};
  String? selectedPlayer;

  void vote(String name) {
    setState(() {
      selectedPlayer = name;
      votes[name] = (votes[name] ?? 0) + 1;
    });
  }

  void checkGameState() {
    int undercoverCount = widget.gameState.players.where((p) => p.isUndercover && !p.isEliminated).length;
    int villageCount = widget.gameState.players.where((p) => !p.isUndercover && !p.isEliminated).length;

    bool victory = false;

    if (undercoverCount == 0) {
      widget.gameState.players.forEach((p) {
        if (!p.isUndercover) p.score += 1;
      });
      victory = true;
    } else if ((undercoverCount >= 1 && widget.gameState.players.where((p) => !p.isEliminated).length <= 2) ||
        (villageCount == 0)) {
      widget.gameState.players.forEach((p) {
        if (p.isUndercover) p.score += 2;
      });
      victory = true;
    } else {
      votes.clear();
      return;
    }

    bool hasWinner = widget.gameState.players.any((p) => p.score >= 25);

    if (hasWinner) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ScoreScreen(gameState: widget.gameState)),
      );
    } else if (victory) {
      showRoundRankingDialog();
    }
  }

  void showRoundRankingDialog() {
    final rankedPlayers = [...widget.gameState.players]
      ..sort((a, b) => b.score.compareTo(a.score));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Color(0xFF1B263B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Color(0xFFD4AF37), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ARCHIVES DU TOUR',
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 22,
                    fontFamily: 'Cinzel',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ...rankedPlayers.map((p) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        p.name,
                        style: TextStyle(
                          color: Color(0xFFFDF6E3),
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFF0A1E3F),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: p.isUndercover 
                                ? Colors.red.withOpacity(0.5)
                                : Color(0xFFD4AF37).withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          '${p.score} pts',
                          style: TextStyle(
                            color: p.isUndercover 
                                ? Colors.red[300]
                                : Color(0xFFD4AF37),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                SizedBox(height: 30),
              ElevatedButton(
  onPressed: () {
    Navigator.of(context).pop();
    widget.gameState.players.forEach((p) => p.isEliminated = false);
    widget.gameState.nextRound();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => GameScreen(gameState: widget.gameState)),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFFD4AF37),
    foregroundColor: Color(0xFF0A1E3F),
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
  child: Text(
    'NOUVEAU TOUR',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      letterSpacing: 1.1,
    ),
  ),
),




              ],
            ),
          ),
        );
      },
    );
  }

  void finishVoting() {
    String? eliminated;
    int maxVotes = 0;

    votes.forEach((name, count) {
      if (count > maxVotes) {
        eliminated = name;
        maxVotes = count;
      }
    });

    if (eliminated == null) return;

    var eliminatedPlayer = widget.gameState.players.firstWhere((p) => p.name == eliminated);
    bool wasUndercover = eliminatedPlayer.isUndercover;
    String displayedRole = wasUndercover ? 'Undercover' : 'Fidèle';

    setState(() {
      eliminatedPlayer.isEliminated = true;
    });

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Color(0xFF1B263B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: wasUndercover ? Colors.red : Color(0xFFD4AF37),
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  wasUndercover ? Icons.warning_amber_rounded : Icons.people_alt_rounded,
                  size: 50,
                  color: wasUndercover ? Colors.red : Color(0xFFD4AF37),
                ),
                SizedBox(height: 20),
                Text(
                  'JUGEMENT RENDU',
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cinzel',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  eliminatedPlayer.name,
                  style: TextStyle(
                    color: Color(0xFFFDF6E3),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'était un $displayedRole',
                  style: TextStyle(
                    color: wasUndercover ? Colors.red[300] : Color(0xFFD4AF37),
                    fontSize: 18,
                  ),
                ),
               
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: wasUndercover ? Colors.red.withOpacity(0.8) : Color(0xFFD4AF37),
                    foregroundColor: Color(0xFF0A1E3F),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    checkGameState();
                  },
                  child: Text(
                    'CONTINUER',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final activePlayers = widget.gameState.players.where((p) => !p.isEliminated).toList();

    return Scaffold(
      backgroundColor: Color(0xFF0A1E3F),
      appBar: AppBar(
        title: Text(
          'ASSEMBLÉE DES FIDÈLES',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontFamily: 'Cinzel',
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: Color(0xFF1B263B),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/parchment_texture.png'),
            opacity: 0.05,
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Choisissez qui bannir',
                style: TextStyle(
                  color: Color(0xFFFDF6E3).withOpacity(0.8),
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: activePlayers.length,
                  separatorBuilder: (_, __) => Divider(
                    color: Color(0xFFD4AF37).withOpacity(0.2),
                    height: 12,
                  ),
                  itemBuilder: (context, index) {
                    final player = activePlayers[index];
                    final voteCount = votes[player.name] ?? 0;
                    final isSelected = selectedPlayer == player.name;

                    return Container(
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Color(0xFF1B263B).withOpacity(0.7)
                            : Color(0xFF1B263B).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected 
                              ? Color(0xFFD4AF37).withOpacity(0.8)
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          player.name,
                          style: TextStyle(
                            color: Color(0xFFFDF6E3),
                            fontSize: 18,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (voteCount > 0)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFF0A1E3F),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Color(0xFFD4AF37).withOpacity(0.5),
                                  ),
                                ),
                                child: Text(
                                  '$voteCount',
                                  style: TextStyle(
                                    color: Color(0xFFD4AF37),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFD4AF37).withOpacity(isSelected ? 0.9 : 0.6),
                                foregroundColor: Color(0xFF0A1E3F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () => vote(player.name),
                              child: Text(
                                'VOTER',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD4AF37),
                    foregroundColor: Color(0xFF0A1E3F),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  onPressed: finishVoting,
                  child: Text(
                    'CONFIRMER LE VOTE',
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
        ),
      ),
    );
  }
}
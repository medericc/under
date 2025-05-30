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

  void vote(String name) {
    setState(() {
      votes[name] = (votes[name] ?? 0) + 1;
    });
  }
void checkGameState() {
  int undercoverCount = widget.gameState.players.where((p) => p.isUndercover && !p.isEliminated).length;
  int villageCount = widget.gameState.players.where((p) => !p.isUndercover && !p.isEliminated).length;

  if (undercoverCount == 0) {
    widget.gameState.players.forEach((p) {
      if (!p.isUndercover) p.score += 1;
    });
  } else if ((undercoverCount >= 1 && widget.gameState.players.where((p) => !p.isEliminated).length <= 2) || (villageCount == 0)) {
    widget.gameState.players.forEach((p) {
      if (p.isUndercover) p.score += 2;
    });
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
  } else {
    // Réinitialise les statuts pour le prochain tour
    widget.gameState.players.forEach((p) => p.isEliminated = false);
    widget.gameState.nextRound();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => GameScreen(gameState: widget.gameState)),
    );
  }
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

  // Chercher le joueur éliminé
  var eliminatedPlayer = widget.gameState.players.firstWhere((p) => p.name == eliminated);
  bool wasUndercover = eliminatedPlayer.isUndercover;
  String displayedRole = wasUndercover ? 'un Undercover' : 'un Villageois';
  String displayedWord = eliminatedPlayer.role;

setState(() {
  eliminatedPlayer.isEliminated = true;
});

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Joueur éliminé'),
        content: Text('Le joueur était $displayedRole.'),
        actions: [
          ElevatedButton(
            child: Text('Continuer'),
            onPressed: () {
              Navigator.of(context).pop();
              checkGameState(); // Continuer le jeu après avoir montré le rôle
            },
          )
        ],
      );
    },
  );
}


void showEliminatedRole(String role) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Joueur éliminé'),
        content: Text('Le joueur était un $role.'),
        actions: [
          ElevatedButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                votes.clear(); // Continue la partie si pas fini
              });
            },
          )
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Votez pour éliminer')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
             children: widget.gameState.players
    .where((p) => !p.isEliminated)
    .map((p) => ListTile(
      title: Text(p.name),
      trailing: ElevatedButton(
        child: Text('Voter'),
        onPressed: () => vote(p.name),
      ),
    ))
    .toList(),

            ),
          ),
          ElevatedButton(
            child: Text('Fin du vote'),
            onPressed: finishVoting,
          ),
        ],
      ),
    );
  }
}

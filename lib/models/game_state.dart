import 'player.dart';

class GameState {
  List<Player> players;
  int round;
  int startIndex;
  List<List<String>> usedPairs = [];

  GameState({required this.players, this.round = 0, this.startIndex = 0});

  void nextRound() {
    round++;
    startIndex = (startIndex + 1) % players.length;
  }

  List<Player> get orderedPlayers {
    return List.generate(players.length, (i) => players[(startIndex + i) % players.length]);
  }

  void resetPlayersForNewRound(List<Player> initialPlayers) {
    players = initialPlayers.map((p) => Player(name: p.name, score: p.score)).toList();
  }
}

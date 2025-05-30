class Player {
  String name;
  bool isUndercover;
  int score;
  String role;
  bool isEliminated;

  Player({
    required this.name,
    this.isUndercover = false,
    this.score = 0,
    this.role = '',
    this.isEliminated = false,
  });
}

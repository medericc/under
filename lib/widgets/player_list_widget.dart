import 'package:flutter/material.dart';
import '../models/player.dart';

class PlayerListWidget extends StatelessWidget {
  final List<Player> players;

  PlayerListWidget({required this.players});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) {
        final p = players[index];
        return ListTile(
          title: Text(p.name),
          subtitle: Text('Score: ${p.score}'),
        );
      },
    );
  }
}

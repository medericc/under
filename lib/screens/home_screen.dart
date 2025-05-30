import 'package:flutter/material.dart';
import 'player_input_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Undercover Chrétien')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bienvenue !\n\n- 4 à 8 joueurs\n- Règles rapides\n- Premier à 25 points gagne', textAlign: TextAlign.center),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Commencer'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerInputScreen())),
            ),
          ],
        ),
      ),
    );
  }
}

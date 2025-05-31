import 'package:flutter/material.dart';
import 'player_input_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B263B), // Bleu foncé profond (fond)
   appBar: AppBar(
  backgroundColor: const Color(0xFFD4AF37),
  elevation: 0,
  centerTitle: true,
  iconTheme: const IconThemeData(color: Color(0xFF0A1E3F)),
  toolbarHeight: 80, // Hauteur personnalisée
  title: const Text(
    "L'APOSTAT",
    style: TextStyle(
      color: Color(0xFF0A1E3F),
      fontSize: 26,
      fontWeight: FontWeight.bold,
    ),
  ),
),

  



      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: const Color(0xFF1B263B).withOpacity(0.7),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Color(0xFFD4AF37)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Bienvenue !\n\n⚠️ Un ou deux intrus se cachent...\n👀 Démasquez-les avant qu’ils ne vous piégent !\n⛪ 4 à 8 joueurs – 25 points pour gagner',
                    style: TextStyle(
                      color: Color(0xFFFAF3E0),
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PlayerInputScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37), // Doré
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: const Color(0xFF000000).withOpacity(0.3),
                ),
                child: const Text(
                  'COMMENCER',
                  style: TextStyle(
                    color: Color(0xFF0A1E3F), // Bleu foncé (texte)
                    fontWeight: FontWeight.bold,
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

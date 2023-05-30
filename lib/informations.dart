import 'package:chadgpt/main.dart';
import 'package:flutter/material.dart';

class Informations extends StatelessWidget {
  const Informations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Informations"),
        centerTitle: true,
        backgroundColor: botbackgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: DefaultTextStyle (
        style: const TextStyle(color: Colors.white),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ChadGPT.fr',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'L\'IA par les chads, pour les chads',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Cette IA gratuite vous permet de poser vos questions à un VRAI chad.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Parce que   "),
                    Image.asset(
                      'chad.png', // Chemin de l'image
                      width: 50,
                      height: 50,
                    ),
                    const Text("  >  "),
                    Image.asset(
                      'chat.png', // Chemin de l'image
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text("alors ChadGPT > ChatGPT"),
                const SizedBox(height: 25),
                const Text(
                  'Fait avec humour par Asyncrom avec GPT-3.5-turbo et Flutter Web',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const ChatPage()));
                    },
                    style: ElevatedButton.styleFrom(primary: botbackgroundColor, shape: const StadiumBorder(), minimumSize: const Size(40, 40)),
                    child: const Text("Chadder maintenant")
                ),
                const SizedBox(height: 30),
                const Text(
                  "Ce chatbot est à des fins humouristiques et éducatives uniquement.\n Veuillez noter que je ne suis pas responsable de l'utilisation qui en est faite.\n Merci de l'utiliser de manière responsable.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,

                ),

              ],),

          ),
        ),
      ),
    );
  }
}

// ElevatedButton(
// onPressed:  () {
// Navigator.popAndPushNamed(context, 'chat');
// },
// child: const Text("Fermer")
// )

import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingContent {
  final String title;
  final String image;
  final String description;

  OnboardingContent({
    required this.title,
    required this.image,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  late PageController _controller;

  // Définition de la couleur thème demandée
  final Color themeGreen = const Color(0xFF78B596); // Vert clair harmonieux

  final List<OnboardingContent> contents = [
    OnboardingContent(
      title: "Bienvenue sur MultiPay-Bénin",
      image: "assets/images/slide1.png",
      description: "Gérez tous vos comptes MTN, Moov et Celtiis en un seul endroit.",
    ),
    OnboardingContent(
      title: "Transactions Rapides",
      image: "assets/images/slide2.png",
      description: "Effectuez vos dépôts, retraits et achats de forfaits en quelques secondes.",
    ),
    OnboardingContent(
      title: "Sécurité Maximale",
      image: "assets/images/slide3.png",
      description: "Toutes vos opérations sont sécurisées et tracées pour votre tranquillité.",
    ),
  ];

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        i == 0 ? Icons.account_balance_wallet : 
                        i == 1 ? Icons.send_to_mobile : Icons.shield_outlined,
                        size: 160,
                        color: themeGreen, // Changement Indigo -> Vert Clair
                      ),
                      const SizedBox(height: 40),
                      Text(
                        contents[i].title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: themeGreen, // Changement Indigo -> Vert Clair
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        contents[i].description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900, // Description en GRAS bien lisible
                          color: Colors.black87,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          // Indicateurs de pages
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              contents.length,
              (index) => Container(
                height: 10,
                width: currentIndex == index ? 25 : 10,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: currentIndex == index ? themeGreen : Colors.grey.shade300,
                ),
              ),
            ),
          ),
          // Bouton dynamique
          Container(
            height: 60,
            margin: const EdgeInsets.all(40),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeGreen, // Changement Indigo -> Vert Clair
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                currentIndex == contents.length - 1 ? "COMMENCER" : "SUIVANT",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
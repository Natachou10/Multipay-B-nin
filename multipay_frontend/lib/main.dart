import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import indispensable
import 'screens/onboarding_screen.dart';

void main() {
  runApp(
    // On place le Provider tout en haut pour qu'il soit accessible partout
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MultiPayApp(),
    ),
  );
}

class MultiPayApp extends StatelessWidget {
  const MultiPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    // On écoute les changements de thème ici
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Multi-Pay Bénin',
      debugShowCheckedModeBanner: false,
      // Sélection dynamique du thème
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
      // Thème Clair
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.indigo,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),

      // Thème Sombre
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        useMaterial3: true,
        /* Tu peux personnaliser les couleurs sombres ici */
      ),
      
      home: const OnboardingScreen(),
    );
  }
}

// Ta classe ThemeProvider reste la même
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool value) {
    _isDarkMode = value;
    notifyListeners(); 
  } 
}
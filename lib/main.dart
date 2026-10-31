import 'package:flutter/material.dart';

import 'telas/tela_caes.dart';
import 'telas/tela_personagens.dart';
import 'telas/tela_pokedex.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Aplicativo());
}

class Aplicativo extends StatelessWidget {
  const Aplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF8875F4);
    return MaterialApp(
      title: 'APIs Divertidas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
          surface: const Color(0xFF161826),
        ),
        scaffoldBackgroundColor: const Color(0xFF10121C),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF10121C),
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1C1E2F),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Color(0xFF303247)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF222436),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
      home: const PaginaInicial(),
    );
  }
}

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  int _aba = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.api_rounded, color: Color(0xFF9B8CFF)),
            SizedBox(width: 12),
            Text('APIs Divertidas', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
      body: IndexedStack(
        index: _aba,
        children: const [TelaCaes(), TelaPokedex(), TelaPersonagens()],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF191B2A),
        indicatorColor: const Color(0xFF443A7C),
        selectedIndex: _aba,
        onDestinationSelected: (indice) => setState(() => _aba = indice),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.pets_outlined), selectedIcon: Icon(Icons.pets), label: 'Cães'),
          NavigationDestination(icon: Icon(Icons.catching_pokemon_outlined), selectedIcon: Icon(Icons.catching_pokemon), label: 'Pokédex'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Personagens'),
        ],
      ),
    );
  }
}

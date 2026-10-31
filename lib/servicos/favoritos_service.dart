import 'package:shared_preferences/shared_preferences.dart';

class FavoritosService {
  static const String _chave = 'personagens_favoritos_v1';
  final SharedPreferencesAsync _prefs;

  FavoritosService({SharedPreferencesAsync? preferencias})
      : _prefs = preferencias ?? SharedPreferencesAsync();

  Future<Set<int>> carregar() async {
    final salvos = await _prefs.getStringList(_chave) ?? <String>[];
    return salvos.map(int.tryParse).whereType<int>().toSet();
  }

  Future<Set<int>> alternar(int id) async {
    final atual = await carregar();
    if (!atual.add(id)) atual.remove(id);
    final ordenados = atual.toList()..sort();
    await _prefs.setStringList(_chave, ordenados.map((e) => e.toString()).toList());
    return atual;
  }
}

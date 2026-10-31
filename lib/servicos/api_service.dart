import 'dart:convert';

import 'package:http/http.dart' as http;

import '../modelos/personagem.dart';
import '../modelos/pokemon.dart';

class ApiException implements Exception {
  final String mensagem;
  const ApiException(this.mensagem);

  @override
  String toString() => mensagem;
}

class ApiService {
  final http.Client _cliente;

  ApiService({http.Client? cliente}) : _cliente = cliente ?? http.Client();

  Future<Map<String, dynamic>> _get(Uri url) async {
    try {
      final resposta = await _cliente.get(url).timeout(const Duration(seconds: 15));
      if (resposta.statusCode == 404) {
        throw const ApiException('Não encontramos esse resultado. Confira a busca.');
      }
      if (resposta.statusCode < 200 || resposta.statusCode >= 300) {
        throw ApiException('Servidor indisponível (HTTP ${resposta.statusCode}).');
      }
      final dado = jsonDecode(utf8.decode(resposta.bodyBytes));
      if (dado is! Map<String, dynamic>) {
        throw const ApiException('O servidor retornou dados inesperados.');
      }
      return dado;
    } on ApiException {
      rethrow;
    } on FormatException {
      throw const ApiException('A resposta do servidor não é um JSON válido.');
    } catch (_) {
      throw const ApiException('Falha na conexão. Verifique sua internet e tente novamente.');
    }
  }

  Future<String> buscarFotoCao({String? raca}) async {
    final caminho = raca == null
        ? '/api/breeds/image/random'
        : '/api/breed/$raca/images/random';
    final dados = await _get(Uri.https('dog.ceo', caminho));
    if (dados['status'] != 'success' || dados['message'] is! String) {
      throw const ApiException('Não foi possível obter a foto do cão.');
    }
    return dados['message'] as String;
  }

  Future<Pokemon> buscarPokemon(String termo) async {
    final nome = termo.trim().toLowerCase();
    if (nome.isEmpty) {
      throw const ApiException('Digite o nome ou ID de um Pokémon.');
    }
    final dados = await _get(Uri.https('pokeapi.co', '/api/v2/pokemon/${Uri.encodeComponent(nome)}'));
    return Pokemon.fromJson(dados);
  }

  Future<PaginaPersonagens> buscarPersonagens({int pagina = 1, String? status}) async {
    final parametros = <String, String>{'page': pagina.toString()};
    if (status != null && status != 'all') parametros['status'] = status;
    final dados = await _get(Uri.https('rickandmortyapi.com', '/api/character/', parametros));
    return PaginaPersonagens.fromJson(dados);
  }

  void dispose() => _cliente.close();
}

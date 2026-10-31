import 'dart:convert';

import 'package:apis_divertidas_flutter/servicos/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('Dog CEO: usa endpoint da raça e lê a URL da imagem', () async {
    final cliente = MockClient((req) async {
      expect(req.url.path, '/api/breed/beagle/images/random');
      return http.Response(jsonEncode({'status': 'success', 'message': 'https://dog.ceo/caes/foto.jpg'}), 200);
    });
    final api = ApiService(cliente: cliente);
    expect(await api.buscarFotoCao(raca: 'beagle'), endsWith('foto.jpg'));
    api.dispose();
  });

  test('PokéAPI: retorna mensagem amigável no 404', () async {
    final api = ApiService(cliente: MockClient((_) async => http.Response('{}', 404)));
    await expectLater(api.buscarPokemon('inexistente'), throwsA(isA<ApiException>()));
    api.dispose();
  });

  test('Rick and Morty: combina filtro e página na URL', () async {
    final api = ApiService(cliente: MockClient((req) async {
      expect(req.url.queryParameters['page'], '2');
      expect(req.url.queryParameters['status'], 'dead');
      return http.Response(jsonEncode({'info': {'pages': 8}, 'results': []}), 200);
    }));
    final pagina = await api.buscarPersonagens(pagina: 2, status: 'dead');
    expect(pagina.totalPaginas, 8);
    expect(pagina.personagens, isEmpty);
    api.dispose();
  });
}

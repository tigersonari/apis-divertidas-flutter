import 'package:flutter_test/flutter_test.dart';
import 'package:apis_divertidas_flutter/modelos/personagem.dart';
import 'package:apis_divertidas_flutter/modelos/pokemon.dart';

void main() {
  test('Pokémon converte decímetros/hectogramas e lê os tipos', () {
    final pokemon = Pokemon.fromJson({
      'id': 25,
      'name': 'pikachu',
      'height': 4,
      'weight': 60,
      'sprites': {
        'front_default': 'https://exemplo.com/pikachu.png',
        'other': {'official-artwork': {'front_default': 'https://exemplo.com/arte.png'}},
      },
      'types': [
        {'type': {'name': 'electric'}},
      ],
    });
    expect(pokemon.id, 25);
    expect(pokemon.alturaMetros, 0.4);
    expect(pokemon.pesoQuilos, 6.0);
    expect(pokemon.tipos, ['electric']);
    expect(pokemon.imagem, endsWith('arte.png'));
  });

  test('Personagem lê gênero e nome da localização', () {
    final personagem = Personagem.fromJson({
      'id': 1,
      'name': 'Rick Sanchez',
      'image': 'https://exemplo.com/rick.jpg',
      'species': 'Human',
      'status': 'Alive',
      'gender': 'Male',
      'location': {'name': 'Citadel of Ricks'},
      'origin': {'name': 'Earth'},
    });
    expect(personagem.genero, 'Male');
    expect(personagem.localizacao, 'Citadel of Ricks');
  });

  test('Paginação converte resultados em objetos tipados', () {
    final pagina = PaginaPersonagens.fromJson({
      'info': {'pages': 3},
      'results': [{
        'id': 2, 'name': 'Morty', 'image': 'https://exemplo.com/morty.jpg',
        'species': 'Human', 'status': 'Alive', 'gender': 'Male',
        'location': {'name': 'Earth'}, 'origin': {'name': 'Earth'},
      }],
    });
    expect(pagina.totalPaginas, 3);
    expect(pagina.personagens, hasLength(1));
    expect(pagina.personagens.first.nome, 'Morty');
  });
}

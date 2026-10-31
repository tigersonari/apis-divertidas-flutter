class Personagem {
  final int id;
  final String nome;
  final String imagem;
  final String especie;
  final String status;
  final String genero;
  final String localizacao;
  final String origem;

  const Personagem({
    required this.id,
    required this.nome,
    required this.imagem,
    required this.especie,
    required this.status,
    required this.genero,
    required this.localizacao,
    required this.origem,
  });

  factory Personagem.fromJson(Map<String, dynamic> json) {
    return Personagem(
      id: json['id'] as int,
      nome: json['name'] as String,
      imagem: json['image'] as String,
      especie: json['species'] as String,
      status: json['status'] as String,
      genero: json['gender'] as String,
      localizacao: (json['location'] as Map<String, dynamic>)['name'] as String,
      origem: (json['origin'] as Map<String, dynamic>)['name'] as String,
    );
  }
}

class PaginaPersonagens {
  final List<Personagem> personagens;
  final int totalPaginas;

  const PaginaPersonagens({required this.personagens, required this.totalPaginas});

  factory PaginaPersonagens.fromJson(Map<String, dynamic> json) {
    final info = json['info'] as Map<String, dynamic>;
    final resultados = json['results'] as List<dynamic>;
    return PaginaPersonagens(
      personagens: resultados
          .map((item) => Personagem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalPaginas: info['pages'] as int,
    );
  }
}

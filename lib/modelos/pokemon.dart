class Pokemon {
  final int id;
  final String nome;
  final String imagem;
  final double alturaMetros;
  final double pesoQuilos;
  final List<String> tipos;

  const Pokemon({
    required this.id,
    required this.nome,
    required this.imagem,
    required this.alturaMetros,
    required this.pesoQuilos,
    required this.tipos,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] as Map<String, dynamic>;
    final outros = sprites['other'] as Map<String, dynamic>?;
    final arte = outros?['official-artwork'] as Map<String, dynamic>?;
    final imagem = (arte?['front_default'] ?? sprites['front_default'] ?? '') as String;
    final tipos = (json['types'] as List<dynamic>)
        .map((item) => (item['type'] as Map<String, dynamic>)['name'] as String)
        .toList();

    return Pokemon(
      id: json['id'] as int,
      nome: json['name'] as String,
      imagem: imagem,
      alturaMetros: (json['height'] as num).toDouble() / 10,
      pesoQuilos: (json['weight'] as num).toDouble() / 10,
      tipos: tipos,
    );
  }
}

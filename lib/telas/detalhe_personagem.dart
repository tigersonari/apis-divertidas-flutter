import 'package:flutter/material.dart';

import '../modelos/personagem.dart';
import '../servicos/favoritos_service.dart';
import '../widgets/componentes.dart';

class DetalhePersonagem extends StatefulWidget {
  final Personagem personagem;
  final bool favorito;

  const DetalhePersonagem({super.key, required this.personagem, required this.favorito});

  @override
  State<DetalhePersonagem> createState() => _DetalhePersonagemState();
}

class _DetalhePersonagemState extends State<DetalhePersonagem> {
  final _favoritosService = FavoritosService();
  late bool _favorito;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _favorito = widget.favorito;
  }

  Future<void> _alternarFavorito() async {
    setState(() => _salvando = true);
    try {
      final favoritos = await _favoritosService.alternar(widget.personagem.id);
      if (!mounted) return;
      setState(() => _favorito = favoritos.contains(widget.personagem.id));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar o favorito.')),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.personagem;
    final cor = p.status == 'Alive' ? Colors.greenAccent : p.status == 'Dead' ? Colors.redAccent : Colors.orangeAccent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do personagem'),
        actions: [
          IconButton(
            tooltip: _favorito ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
            onPressed: _salvando ? null : _alternarFavorito,
            icon: Icon(_favorito ? Icons.star_rounded : Icons.star_border_rounded,
                color: _favorito ? Colors.amberAccent : null),
          ),
        ],
      ),
      body: ConteudoCentralizado(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                FotoInternet(url: p.imagem, altura: 270),
                Padding(
                  padding: const EdgeInsets.all(23),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p.nome, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    Row(children: [
                      Icon(Icons.circle, size: 12, color: cor),
                      const SizedBox(width: 8),
                      Text('${p.status} • ${p.especie}', style: const TextStyle(fontSize: 15)),
                    ]),
                    const Divider(height: 35),
                    _LinhaDetalhe(icone: Icons.badge_outlined, rotulo: 'Identificador', valor: '#${p.id}'),
                    _LinhaDetalhe(icone: Icons.wc_outlined, rotulo: 'Gênero', valor: p.genero),
                    _LinhaDetalhe(icone: Icons.travel_explore_outlined, rotulo: 'Localização atual', valor: p.localizacao),
                    _LinhaDetalhe(icone: Icons.public_outlined, rotulo: 'Origem', valor: p.origem),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _salvando ? null : _alternarFavorito,
                      icon: Icon(_favorito ? Icons.star : Icons.star_border),
                      label: Text(_favorito ? 'Remover dos favoritos' : 'Salvar como favorito'),
                    ),
                  ]),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinhaDetalhe extends StatelessWidget {
  final IconData icone;
  final String rotulo;
  final String valor;

  const _LinhaDetalhe({required this.icone, required this.rotulo, required this.valor});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icone, size: 21, color: const Color(0xFFB4A7FF)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(rotulo, style: const TextStyle(color: Color(0xFFB6B4C8), fontSize: 12)),
        const SizedBox(height: 3),
        Text(valor, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      ])),
    ]),
  );
}

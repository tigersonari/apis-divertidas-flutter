import 'dart:math';

import 'package:flutter/material.dart';

import '../modelos/pokemon.dart';
import '../servicos/api_service.dart';
import '../widgets/componentes.dart';

class TelaPokedex extends StatefulWidget {
  const TelaPokedex({super.key});

  @override
  State<TelaPokedex> createState() => _TelaPokedexState();
}

class _TelaPokedexState extends State<TelaPokedex> {
  final _api = ApiService();
  final _campo = TextEditingController(text: 'pikachu');
  final _aleatorio = Random();
  Pokemon? _pokemon;
  bool _carregando = false;
  String? _erro;
  int _sequencia = 0;

  @override
  void initState() {
    super.initState();
    _buscar();
  }

  Future<void> _buscar() async {
    final sequenciaAtual = ++_sequencia;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final pokemon = await _api.buscarPokemon(_campo.text);
      if (!mounted || sequenciaAtual != _sequencia) return;
      setState(() => _pokemon = pokemon);
    } catch (e) {
      if (!mounted || sequenciaAtual != _sequencia) return;
      setState(() {
        _pokemon = null;
        _erro = e.toString();
      });
    } finally {
      if (mounted && sequenciaAtual == _sequencia) {
        setState(() => _carregando = false);
      }
    }
  }

  void _sortear() {
    _campo.text = (_aleatorio.nextInt(151) + 1).toString();
    _buscar();
  }

  @override
  void dispose() {
    _campo.dispose();
    _api.dispose();
    super.dispose();
  }

  String _capitalizar(String texto) =>
      texto.isEmpty ? texto : '${texto[0].toUpperCase()}${texto.substring(1)}';

  @override
  Widget build(BuildContext context) {
    return ConteudoCentralizado(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
        children: [
          const TituloSecao(
            rotulo: 'PokéAPI • Pokédex',
            titulo: 'Pokédex ⚡',
            descricao: 'Pesquise pelo nome ou ID e descubra os tipos, a altura e o peso do seu Pokémon favorito.',
            icone: Icons.catching_pokemon,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _campo,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _buscar(),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Ex.: pikachu, bulbasaur ou 25',
              labelText: 'Buscar Pokémon',
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: _carregando ? null : _buscar,
                icon: const Icon(Icons.search),
                label: const Text('Buscar'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _carregando ? null : _sortear,
                icon: const Icon(Icons.shuffle),
                label: const Text('Aleatório (1–151)'),
              ),
            ),
          ]),
          const SizedBox(height: 20),
          if (_carregando)
            const Padding(padding: EdgeInsets.all(54), child: Center(child: CircularProgressIndicator()))
          else if (_erro != null)
            AvisoErro(mensagem: _erro!, aoTentar: _buscar)
          else if (_pokemon != null)
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(23),
                child: Column(children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('#${_pokemon!.id.toString().padLeft(3, '0')}',
                        style: const TextStyle(color: Color(0xFFA69AEF), fontWeight: FontWeight.w900, fontSize: 21)),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 220,
                    child: _pokemon!.imagem.isEmpty
                        ? const Icon(Icons.catching_pokemon, size: 90)
                        : FotoInternet(url: _pokemon!.imagem, altura: 220, ajuste: BoxFit.contain),
                  ),
                  const SizedBox(height: 8),
                  Text(_capitalizar(_pokemon!.nome), style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 14),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 6,
                    children: _pokemon!.tipos
                        .map((tipo) => Chip(
                              avatar: const Icon(Icons.bolt, size: 16),
                              label: Text(_capitalizar(tipo)),
                              backgroundColor: const Color(0xFF3B365A),
                              side: BorderSide.none,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(children: [
                    Expanded(child: _Indicador(nome: 'ALTURA', valor: '${_pokemon!.alturaMetros.toStringAsFixed(1)} m', icone: Icons.height)),
                    const SizedBox(width: 12),
                    Expanded(child: _Indicador(nome: 'PESO', valor: '${_pokemon!.pesoQuilos.toStringAsFixed(1)} kg', icone: Icons.monitor_weight_outlined)),
                  ]),
                ]),
              ),
            ),
        ],
      ),
    );
  }
}

class _Indicador extends StatelessWidget {
  final String nome;
  final String valor;
  final IconData icone;

  const _Indicador({required this.nome, required this.valor, required this.icone});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: const Color(0xFF282A3D), borderRadius: BorderRadius.circular(15)),
    child: Column(children: [
      Icon(icone, color: const Color(0xFFB4A7FF)),
      const SizedBox(height: 5),
      Text(nome, style: const TextStyle(color: Color(0xFFB6B4C8), fontSize: 11, letterSpacing: 1.5)),
      const SizedBox(height: 4),
      Text(valor, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
    ]),
  );
}

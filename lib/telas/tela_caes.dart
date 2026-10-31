import 'package:flutter/material.dart';

import '../servicos/api_service.dart';
import '../widgets/componentes.dart';

class TelaCaes extends StatefulWidget {
  const TelaCaes({super.key});

  @override
  State<TelaCaes> createState() => _TelaCaesState();
}

class _TelaCaesState extends State<TelaCaes> {
  static const _racas = <String, String>{
    'beagle': 'Beagle',
    'husky': 'Husky',
    'pug': 'Pug',
    'poodle': 'Poodle',
  };

  final ApiService _api = ApiService();
  String? _racaEscolhida;
  String? _foto;
  String? _erro;
  bool _carregando = false;
  int _quantidadeSorteios = 0;
  int _sequencia = 0;

  @override
  void initState() {
    super.initState();
    _sortear();
  }

  Future<void> _sortear() async {
    final sequenciaAtual = ++_sequencia;
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final url = await _api.buscarFotoCao(raca: _racaEscolhida);
      if (!mounted || sequenciaAtual != _sequencia) return;
      setState(() {
        _foto = url;
        _quantidadeSorteios++;
      });
    } catch (e) {
      if (!mounted || sequenciaAtual != _sequencia) return;
      setState(() => _erro = e.toString());
    } finally {
      if (mounted && sequenciaAtual == _sequencia) {
        setState(() => _carregando = false);
      }
    }
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConteudoCentralizado(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
        children: [
          const TituloSecao(
            rotulo: 'Dog CEO API • Galeria',
            titulo: 'Galeria de cães 🐶',
            descricao: 'Conheça um novo amigo a cada clique. Escolha uma raça ou surpreenda-se com uma foto aleatória.',
            icone: Icons.pets,
          ),
          const SizedBox(height: 25),
          const Text('ESCOLHA UMA RAÇA', style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.w800, fontSize: 11, color: Color(0xFFA9A7C4))),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _racas.entries.map((entrada) {
              return ChoiceChip(
                label: Text(entrada.value),
                selected: _racaEscolhida == entrada.key,
                onSelected: (_) {
                  setState(() => _racaEscolhida = entrada.key);
                  _sortear();
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 18, 18, 14),
                  child: Text('Um focinho novo, uma alegria diferente! 💜',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
                SizedBox(
                  height: 290,
                  child: _erro != null && _foto == null
                      ? AvisoErro(mensagem: _erro!, aoTentar: _sortear)
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            if (_foto != null) FotoInternet(url: _foto!, altura: 290)
                            else const Center(child: Icon(Icons.pets, size: 75, color: Colors.white24)),
                            if (_carregando)
                              ColoredBox(
                                color: Colors.black45,
                                child: const Center(child: CircularProgressIndicator()),
                              ),
                          ],
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_racaEscolhida == null ? 'Um amigo surpresa!' : 'Raça: ${_racas[_racaEscolhida]}',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 21)),
                      const SizedBox(height: 6),
                      const Text('Cada foto é buscada diretamente da API Dog CEO.', style: TextStyle(color: Color(0xFFB6B4C8))),
                      const SizedBox(height: 14),
                      Row(children: [
                        const Icon(Icons.photo_library_outlined, size: 19, color: Color(0xFF9B8CFF)),
                        const SizedBox(width: 9),
                        Text('Fotos sorteadas: $_quantidadeSorteios', style: const TextStyle(fontWeight: FontWeight.w700)),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_erro != null && _foto != null) ...[
            const SizedBox(height: 10),
            AvisoErro(mensagem: _erro!, aoTentar: _sortear),
          ],
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: _carregando ? null : _sortear,
            icon: const Icon(Icons.casino_outlined),
            label: Text(_carregando ? 'Buscando foto...' : 'Sortear outra foto'),
          ),
          if (_racaEscolhida != null) ...[
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {
                setState(() => _racaEscolhida = null);
                _sortear();
              },
              icon: const Icon(Icons.shuffle),
              label: const Text('Voltar para todas as raças'),
            ),
          ],
        ],
      ),
    );
  }
}

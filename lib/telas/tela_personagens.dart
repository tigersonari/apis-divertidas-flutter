import 'package:flutter/material.dart';

import '../modelos/personagem.dart';
import '../servicos/api_service.dart';
import '../servicos/favoritos_service.dart';
import '../widgets/componentes.dart';
import 'detalhe_personagem.dart';

class TelaPersonagens extends StatefulWidget {
  const TelaPersonagens({super.key});

  @override
  State<TelaPersonagens> createState() => _TelaPersonagensState();
}

class _TelaPersonagensState extends State<TelaPersonagens> {
  final _api = ApiService();
  final _favoritosService = FavoritosService();
  List<Personagem> _personagens = [];
  Set<int> _favoritos = {};
  String _status = 'all';
  int _pagina = 1;
  int _totalPaginas = 1;
  int _sequencia = 0;
  bool _carregando = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarFavoritos();
    _carregar();
  }

  Future<void> _carregarFavoritos() async {
    try {
      final ids = await _favoritosService.carregar();
      if (mounted) setState(() => _favoritos = ids);
    } catch (_) {
      // A listagem continua disponível se o armazenamento local falhar.
    }
  }

  Future<void> _carregar() async {
    final sequenciaAtual = ++_sequencia;
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final resultado = await _api.buscarPersonagens(pagina: _pagina, status: _status);
      if (!mounted || sequenciaAtual != _sequencia) return;
      setState(() {
        _personagens = resultado.personagens;
        _totalPaginas = resultado.totalPaginas;
      });
    } catch (e) {
      if (!mounted || sequenciaAtual != _sequencia) return;
      setState(() {
        _personagens = [];
        _erro = e.toString();
      });
    } finally {
      if (mounted && sequenciaAtual == _sequencia) {
        setState(() => _carregando = false);
      }
    }
  }

  void _filtrar(String status) {
    if (_status == status) return;
    setState(() {
      _status = status;
      _pagina = 1;
      _totalPaginas = 1;
    });
    _carregar();
  }

  void _irPara(int pagina) {
    if (_carregando || pagina < 1 || pagina > _totalPaginas) return;
    setState(() => _pagina = pagina);
    _carregar();
  }

  Future<void> _abrirDetalhes(Personagem personagem) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => DetalhePersonagem(
          personagem: personagem,
          favorito: _favoritos.contains(personagem.id),
        ),
      ),
    );
    await _carregarFavoritos();
  }

  Future<void> _alternarFavorito(int id) async {
    try {
      final atual = await _favoritosService.alternar(id);
      if (mounted) setState(() => _favoritos = atual);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar o favorito.')),
      );
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
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const TituloSecao(
              rotulo: 'Rick and Morty API • Personagens',
              titulo: 'Multiverso 👽',
              descricao: 'Explore personagens, filtre pelo status e guarde seus favoritos no dispositivo.',
              icone: Icons.public,
            ),
            const SizedBox(height: 22),
            const Text('FILTRAR POR STATUS', style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.w800, fontSize: 11, color: Color(0xFFA9A7C4))),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 6, children: [
              _chip('all', 'Todos'),
              _chip('alive', 'Vivos'),
              _chip('dead', 'Mortos'),
            ]),
            const SizedBox(height: 12),
            Text('${_favoritos.length} favorito(s) salvo(s) • Página $_pagina de $_totalPaginas',
                style: const TextStyle(color: Color(0xFFABA9C1), fontSize: 12)),
            const SizedBox(height: 6),
          ]),
        ),
        Expanded(
          child: _carregando
              ? const Center(child: CircularProgressIndicator())
              : _erro != null
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: AvisoErro(mensagem: _erro!, aoTentar: _carregar),
                    )
                  : RefreshIndicator(
                      onRefresh: _carregar,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                        itemCount: _personagens.length,
                        itemBuilder: (context, index) {
                          final p = _personagens[index];
                          final favorito = _favoritos.contains(p.id);
                          final cor = p.status == 'Alive'
                              ? Colors.greenAccent
                              : p.status == 'Dead' ? Colors.redAccent : Colors.orangeAccent;
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            clipBehavior: Clip.antiAlias,
                            child: ListTile(
                              contentPadding: const EdgeInsets.fromLTRB(12, 9, 7, 9),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: SizedBox(
                                  width: 59,
                                  height: 62,
                                  child: FotoInternet(url: p.imagem, altura: 62),
                                ),
                              ),
                              title: Text(p.nome, maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.w800)),
                              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const SizedBox(height: 4),
                                Text(p.especie, maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Row(children: [
                                  Icon(Icons.circle, color: cor, size: 8),
                                  const SizedBox(width: 5),
                                  Text(p.status, style: const TextStyle(fontSize: 12)),
                                ]),
                              ]),
                              trailing: IconButton(
                                tooltip: favorito ? 'Desfavoritar' : 'Favoritar',
                                onPressed: () => _alternarFavorito(p.id),
                                icon: Icon(favorito ? Icons.star : Icons.star_border,
                                    color: favorito ? Colors.amberAccent : null),
                              ),
                              onTap: () => _abrirDetalhes(p),
                            ),
                          );
                        },
                      ),
                    ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _carregando || _pagina <= 1 ? null : () => _irPara(_pagina - 1),
                  icon: const Icon(Icons.chevron_left),
                  label: const Text('Anterior'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _carregando || _pagina >= _totalPaginas ? null : () => _irPara(_pagina + 1),
                  icon: const Icon(Icons.chevron_right),
                  label: const Text('Próxima'),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _chip(String chave, String nome) => ChoiceChip(
    label: Text(nome),
    selected: _status == chave,
    onSelected: (_) => _filtrar(chave),
  );
}

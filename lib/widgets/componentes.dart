import 'package:flutter/material.dart';

class TituloSecao extends StatelessWidget {
  final String rotulo;
  final String titulo;
  final String descricao;
  final IconData icone;

  const TituloSecao({super.key, required this.rotulo, required this.titulo, required this.descricao, required this.icone});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icone, size: 16, color: cores.primary),
          const SizedBox(width: 8),
          Text(rotulo.toUpperCase(), style: TextStyle(color: cores.primary, letterSpacing: 2, fontSize: 11, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 10),
        Text(titulo, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -0.9)),
        const SizedBox(height: 8),
        Text(descricao, style: const TextStyle(color: Color(0xFFB9B9CE), height: 1.5)),
      ],
    );
  }
}

class AvisoErro extends StatelessWidget {
  final String mensagem;
  final VoidCallback aoTentar;

  const AvisoErro({super.key, required this.mensagem, required this.aoTentar});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.orangeAccent, size: 44),
          const SizedBox(height: 12),
          Text(mensagem, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton.icon(onPressed: aoTentar, icon: const Icon(Icons.refresh), label: const Text('Tentar novamente')),
        ]),
      ),
    );
  }
}

class FotoInternet extends StatelessWidget {
  final String url;
  final double? altura;
  final BoxFit ajuste;

  const FotoInternet({super.key, required this.url, this.altura, this.ajuste = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      height: altura,
      width: double.infinity,
      fit: ajuste,
      errorBuilder: (context, erro, pilha) => Container(
        height: altura ?? 200,
        color: const Color(0xFF282B3E),
        child: const Center(child: Icon(Icons.broken_image_outlined, size: 52, color: Colors.white54)),
      ),
      loadingBuilder: (context, filho, progresso) {
        if (progresso == null) return filho;
        return Container(
          height: altura ?? 200,
          color: const Color(0xFF282B3E),
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      },
    );
  }
}

class ConteudoCentralizado extends StatelessWidget {
  final Widget child;
  const ConteudoCentralizado({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 790),
      child: child,
    ),
  );
}

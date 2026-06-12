import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/services/postagem_service.dart';
import '../models/postagem_model.dart';
import '../widgets/app_background.dart';
import '../widgets/postagem_card.dart';
import 'nova_denuncia_screen.dart';

class PostagensScreen extends StatefulWidget {
  final bool embedded;
  final VoidCallback? onNovaDenuncia;

  const PostagensScreen({
    super.key,
    this.embedded = false,
    this.onNovaDenuncia,
  });

  @override
  State<PostagensScreen> createState() => _PostagensScreenState();
}

class _PostagensScreenState extends State<PostagensScreen> {
  final List<Postagem> _mockPostagens = [
    Postagem(
      id: -1001,
      titulo: 'Cratera no centro de Maringá',
      descricao:
          'Descrição relacionada a denúncia informada pelo cidadão. O problema precisa de atenção dos órgãos responsáveis.',
      imagemBase64: null,
      imagemAsset: 'assets/images/cratera.webp',
      local: 'Centro',
      dataCriacao: 'Hoje',
      likes: 18,
    ),
    Postagem(
      id: -1002,
      titulo: 'Lixo acumulado em rua de Maringá',
      descricao:
          'Lixo acumulado em via pública, causando mau cheiro e risco para os moradores da região.',
      imagemBase64: null,
      imagemAsset: 'assets/images/lixo.jpg',
      local: 'Zona 7',
      dataCriacao: 'Hoje',
      likes: 12,
    ),
    Postagem(
      id: -1003,
      titulo: 'Falta de iluminação em ruas de Maringá',
      descricao:
          'Rua com iluminação precária durante a noite, causando insegurança para pedestres.',
      imagemBase64: null,
      imagemAsset: 'assets/images/iluminacao.webp',
      local: 'Jardim Alvorada',
      dataCriacao: 'Ontem',
      likes: 24,
    ),
    Postagem(
      id: -1004,
      titulo: 'Bueiros entupidos em Maringá',
      descricao: 'Bueiros entupidos gerando acúmulo de água em dias de chuva.',
      imagemBase64: null,
      imagemAsset: 'assets/images/bueiro.jpg',
      local: 'Centro',
      dataCriacao: 'Ontem',
      likes: 9,
    ),
    Postagem(
      id: -1005,
      titulo: 'Calçada quebrada',
      descricao:
          'Calçada danificada dificultando a passagem de idosos, crianças e pessoas com deficiência.',
      imagemBase64: null,
      imagemAsset: 'assets/images/calcada.webp',
      local: 'Av. Brasil',
      dataCriacao: '2 dias',
      likes: 15,
    ),
    Postagem(
      id: -1006,
      titulo: 'Entulhos jogados na rua',
      descricao: 'Entulho descartado de forma irregular em área pública.',
      imagemBase64: null,
      imagemAsset: 'assets/images/entulho.jpg',
      local: 'Jardim Universo',
      dataCriacao: '2 dias',
      likes: 7,
    ),
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<PostagemService>().carregarPostagens();
    });
  }

  void _openNovaDenuncia() {
    if (widget.onNovaDenuncia != null) {
      widget.onNovaDenuncia!();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NovaDenunciaScreen(),
      ),
    );
  }

  Future<void> _apagarPostagem(Postagem postagem) async {
    final service = context.read<PostagemService>();

    final estaNoService = service.postagens.any(
      (item) => item.id == postagem.id,
    );

    if (estaNoService) {
      await service.apagarPostagem(postagem.id);
    } else {
      setState(() {
        _mockPostagens.removeWhere((item) => item.id == postagem.id);
      });
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Denúncia apagada.'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = AppBackground(
      dark: true,
      opacity: 0.34,
      child: Consumer<PostagemService>(
        builder: (context, service, _) {
          final postagens = [
            ...service.postagens,
            ..._mockPostagens,
          ];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Postagens',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<PostagemService>().carregarPostagens();
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: postagens.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma denúncia encontrada.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 18),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.58,
                        ),
                        itemCount: postagens.length,
                        itemBuilder: (context, index) {
                          return PostagemCard(
                            postagem: postagens[index],
                            onDelete: _apagarPostagem,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );

    if (widget.embedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Postagens',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openNovaDenuncia,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: content,
    );
  }
}
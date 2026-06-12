import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/services/postagem_service.dart';
import '../models/postagem_model.dart';

class PostagemCard extends StatefulWidget {
  final Postagem postagem;
  final void Function(Postagem postagem)? onDelete;

  const PostagemCard({
    super.key,
    required this.postagem,
    this.onDelete,
  });

  @override
  State<PostagemCard> createState() => _PostagemCardState();
}

class _PostagemCardState extends State<PostagemCard> {
  late int likes;
  bool liked = false;

  @override
  void initState() {
    super.initState();
    likes = widget.postagem.likes;
  }

  Uint8List? _decodeBase64Image(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    try {
      final cleanValue = value.contains(',') ? value.split(',').last : value;
      return base64Decode(cleanValue);
    } catch (_) {
      return null;
    }
  }

  Future<void> _like() async {
    setState(() {
      liked = !liked;
      likes += liked ? 1 : -1;
    });

    await context.read<PostagemService>().darLike(widget.postagem.id);
  }

  Future<void> _confirmarExclusao() async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Apagar denúncia'),
          content: const Text(
            'Tem certeza que deseja apagar esta denúncia?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Apagar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmou == true) {
      widget.onDelete?.call(widget.postagem);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageBytes = _decodeBase64Image(widget.postagem.imagemBase64);

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.74),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 4, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.postagem.titulo,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _confirmarExclusao,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 96,
            width: double.infinity,
            child: imageBytes != null
                ? Image.memory(
                    imageBytes,
                    fit: BoxFit.cover,
                  )
                : widget.postagem.imagemAsset != null
                    ? Image.asset(
                        widget.postagem.imagemAsset!,
                        fit: BoxFit.cover,
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/catedral.jpg',
                            fit: BoxFit.cover,
                          ),
                          Container(
                            color: Colors.black.withOpacity(0.28),
                          ),
                          const Center(
                            child: Icon(
                              Icons.report_problem_outlined,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ],
                      ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Text(
                widget.postagem.descricao,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  height: 1.15,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: SizedBox(
              width: double.infinity,
              height: 32,
              child: ElevatedButton.icon(
                onPressed: _like,
                icon: Icon(
                  liked ? Icons.thumb_up : Icons.thumb_up_outlined,
                  size: 14,
                ),
                label: Text('$likes likes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.likeColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
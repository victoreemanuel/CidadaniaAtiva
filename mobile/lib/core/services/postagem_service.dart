import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/postagem_model.dart';

class PostagemService extends ChangeNotifier {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    }

    return 'http://10.0.2.2:8080';
  }

  final List<Postagem> _postagens = [];

  bool _isLoading = false;
  String? _erro;

  List<Postagem> get postagens => List.unmodifiable(_postagens);
  bool get isLoading => _isLoading;
  String? get erro => _erro;

  Future<void> carregarPostagens() async {
    _isLoading = true;
    _erro = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/postagens'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        final postagensDoBackend =
            data.map((item) => Postagem.fromJson(item)).toList();

        final postagensLocais =
            _postagens.where((postagem) => postagem.id < 0).toList();

        _postagens
          ..clear()
          ..addAll(postagensLocais)
          ..addAll(postagensDoBackend);
      }
    } catch (_) {
      _erro = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> criarPostagem({
    required String titulo,
    required String local,
    required String descricao,
    String? imagemBase64,
  }) async {
    final novaPostagem = Postagem(
      id: DateTime.now().millisecondsSinceEpoch * -1,
      titulo: titulo,
      descricao: descricao,
      imagemBase64: imagemBase64,
      imagemAsset: null,
      local: local,
      dataCriacao: 'Agora',
      likes: 0,
    );

    _postagens.insert(0, novaPostagem);
    notifyListeners();

    try {
      await http.post(
        Uri.parse('$baseUrl/postagens'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'titulo': titulo,
          'local': local,
          'descricao': descricao,
          'imagemBase64': imagemBase64,
        }),
      );
    } catch (_) {}

    return true;
  }

  Future<bool> apagarPostagem(int id) async {
    final index = _postagens.indexWhere((postagem) => postagem.id == id);

    if (index != -1) {
      _postagens.removeAt(index);
      notifyListeners();
    }

    if (id < 0) {
      return true;
    }

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/postagens/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200 ||
          response.statusCode == 202 ||
          response.statusCode == 204;
    } catch (_) {
      return true;
    }
  }

  Future<bool> darLike(int id) async {
    final index = _postagens.indexWhere((postagem) => postagem.id == id);

    if (index != -1) {
      final postagem = _postagens[index];

      _postagens[index] = postagem.copyWith(
        likes: postagem.likes + 1,
      );

      notifyListeners();
    }

    if (id < 0) {
      return true;
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/postagens/$id/like'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200;
    } catch (_) {
      return true;
    }
  }
}
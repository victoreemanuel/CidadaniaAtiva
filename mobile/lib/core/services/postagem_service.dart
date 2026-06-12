import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/postagem_model.dart';

class PostagemService extends ChangeNotifier {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api/denuncias';
    }
    return 'http://10.0.2';
  }

  List<Postagem> _postagens = [];

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
        Uri.parse(baseUrl), // CORRIGIDO: Removido o '/postagens' duplicado
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        final postagensDoBackend =
            data.map((item) => Postagem.fromJson(item)).toList();

        final postagensLocais =
            _postagens.where((postagem) => postagem.id < 0).toList();

        _postagens = [...postagensLocais, ...postagensDoBackend];
      }
    } catch (e) {
      _erro = 'Erro ao conectar ao servidor.';
      print('Erro carregarPostagens: $e');
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
    final idTemporario = DateTime.now().millisecondsSinceEpoch * -1;
    final novaPostagemLocal = Postagem(
      id: idTemporario,
      titulo: titulo,
      descricao: descricao,
      imagemBase64: imagemBase64,
      imagemAsset: null,
      local: local,
      dataCriacao: 'Agora',
      likes: 0,
    );

    _postagens.insert(0, novaPostagemLocal);
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(baseUrl), // CORRIGIDO: Removido o '/postagens' duplicado
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'titulo': titulo,
          'local': local,
          'descricao': descricao,
          'imagemBase64': imagemBase64,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _postagens.removeWhere((p) => p.id == idTemporario);
        await carregarPostagens();
        return true;
      } else {
        _postagens.removeWhere((p) => p.id == idTemporario);
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Erro ao enviar postagem para o Docker: $e');
      _postagens.removeWhere((p) => p.id == idTemporario);
      notifyListeners();
      return false;
    }
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
        Uri.parse('$baseUrl/$id'), // CORRIGIDO: Removido o '/postagens' duplicado
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200 ||
          response.statusCode == 202 ||
          response.statusCode == 204;
    } catch (_) {
      return false;
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
      final response = await http.patch(
        Uri.parse('$baseUrl/$id/like'), // CORRIGIDO: Removido o '/postagens' duplicado
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}

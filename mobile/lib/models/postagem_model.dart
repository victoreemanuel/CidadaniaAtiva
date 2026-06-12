class Postagem {
  final int id;
  final String titulo;
  final String descricao;
  final String? imagemBase64;
  final String? imagemAsset;
  final String local;
  final String dataCriacao;
  final int likes;

  Postagem({
    required this.id,
    required this.titulo,
    required this.descricao,
    this.imagemBase64,
    this.imagemAsset,
    required this.local,
    required this.dataCriacao,
    required this.likes,
  });

  factory Postagem.fromJson(Map<String, dynamic> json) {
    return Postagem(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'] ?? '',
      imagemBase64: json['imagemBase64'],
      imagemAsset: null,
      local: json['local'] ?? '',
      dataCriacao: json['dataCriacao'] ?? '',
      likes: json['likes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'imagemBase64': imagemBase64,
      'local': local,
    };
  }

  Postagem copyWith({
    int? id,
    String? titulo,
    String? descricao,
    String? imagemBase64,
    String? imagemAsset,
    String? local,
    String? dataCriacao,
    int? likes,
  }) {
    return Postagem(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      imagemBase64: imagemBase64 ?? this.imagemBase64,
      imagemAsset: imagemAsset ?? this.imagemAsset,
      local: local ?? this.local,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      likes: likes ?? this.likes,
    );
  }
}
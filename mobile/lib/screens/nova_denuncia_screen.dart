import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/services/postagem_service.dart';
import '../widgets/app_background.dart';

class NovaDenunciaScreen extends StatefulWidget {
  final bool embedded;
  final VoidCallback? onCancel;
  final VoidCallback? onSaved;

  const NovaDenunciaScreen({
    super.key,
    this.embedded = false,
    this.onCancel,
    this.onSaved,
  });

  @override
  State<NovaDenunciaScreen> createState() => _NovaDenunciaScreenState();
}

class _NovaDenunciaScreenState extends State<NovaDenunciaScreen> {
  final _formKey = GlobalKey<FormState>();

  final _tituloController = TextEditingController();
  final _localController = TextEditingController();
  final _descricaoController = TextEditingController();

  String? _categoria;
  bool _anonimoOk = false;
  bool _enviando = false;

  String? _nomeArquivo;
  String? _imagemBase64;
  Uint8List? _imagemBytes;

  final List<String> _categorias = const [
    'Buracos',
    'Iluminação',
    'Bueiros',
    'Áreas públicas',
    'Lixo',
    'Calçadas',
  ];

  @override
  void dispose() {
    _tituloController.dispose();
    _localController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarArquivo() async {
    final resultado = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (resultado == null || resultado.files.isEmpty) {
      return;
    }

    final arquivo = resultado.files.first;
    final bytes = arquivo.bytes;

    if (bytes == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível carregar a imagem selecionada.'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    setState(() {
      _nomeArquivo = arquivo.name;
      _imagemBytes = bytes;
      _imagemBase64 = base64Encode(bytes);
    });
  }

  Future<void> _enviarDenuncia() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_anonimoOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Marque a confirmação da denúncia anônima.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _enviando = true;
    });

    final descricaoCompleta =
        'Categoria: $_categoria\n\n${_descricaoController.text.trim()}';

    final sucesso = await context.read<PostagemService>().criarPostagem(
          titulo: _tituloController.text.trim(),
          local: _localController.text.trim(),
          descricao: descricaoCompleta,
          imagemBase64: _imagemBase64,
        );

    if (!mounted) {
      return;
    }

    setState(() {
      _enviando = false;
    });

    if (!sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível enviar a denúncia.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _limparFormulario();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Denúncia enviada com sucesso!'),
        backgroundColor: AppColors.accent,
      ),
    );

    if (widget.onSaved != null) {
      widget.onSaved!();
    } else {
      Navigator.pop(context);
    }
  }

  void _limparFormulario() {
    _tituloController.clear();
    _localController.clear();
    _descricaoController.clear();

    setState(() {
      _categoria = null;
      _anonimoOk = false;
      _nomeArquivo = null;
      _imagemBase64 = null;
      _imagemBytes = null;
    });
  }

  void _cancelar() {
    if (widget.onCancel != null) {
      widget.onCancel!();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = AppBackground(
      dark: true,
      opacity: 0.38,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 90),
        child: Column(
          children: [
            const Text(
              'Nova Denúncia',
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
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.78),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FormLabel('Título da Denúncia:'),
                    TextFormField(
                      controller: _tituloController,
                      style: const TextStyle(color: Colors.black),
                      decoration: _inputDecoration(),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o título.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    const _FormLabel('Categoria:'),
                    DropdownButtonFormField<String>(
                      value: _categoria,
                      dropdownColor: Colors.grey.shade900,
                      iconEnabledColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(),
                      items: _categorias.map((categoria) {
                        return DropdownMenuItem(
                          value: categoria,
                          child: Text(categoria),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _categoria = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Selecione uma categoria.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    const _FormLabel('Local:'),
                    TextFormField(
                      controller: _localController,
                      style: const TextStyle(color: Colors.black),
                      decoration: _inputDecoration(),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o local.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    const _FormLabel('Descrição:'),
                    TextFormField(
                      controller: _descricaoController,
                      maxLines: 5,
                      style: const TextStyle(color: Colors.black),
                      decoration: _inputDecoration(),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe a descrição.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    const _FormLabel('Anexar imagem:'),
                    GestureDetector(
                      onTap: _selecionarArquivo,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white38),
                          color: Colors.black.withOpacity(0.18),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.attach_file,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _nomeArquivo ?? 'Toque para escolher uma imagem',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (_imagemBytes != null) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          _imagemBytes!,
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],

                    const SizedBox(height: 14),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _anonimoOk,
                          activeColor: AppColors.accent,
                          checkColor: Colors.black,
                          onChanged: (value) {
                            setState(() {
                              _anonimoOk = value ?? false;
                            });
                          },
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'EU NÃO ESTOU ENVIANDO DADOS PESSOAIS PRÓPRIOS E/OU DE OUTROS. ESTANDO CIENTE DE QUE ESTA É UMA DENÚNCIA ANÔNIMA',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                height: 1.25,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _enviando ? null : _enviarDenuncia,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                              _enviando ? 'Enviando...' : 'Enviar Denúncia',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _enviando ? null : _cancelar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (widget.embedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Nova Denúncia',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: content,
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade400,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 1,
        ),
      ),
      errorStyle: const TextStyle(
        color: Colors.orangeAccent,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String text;

  const _FormLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
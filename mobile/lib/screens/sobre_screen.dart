import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../widgets/app_background.dart';

class SobreScreen extends StatelessWidget {
  final bool embedded;

  const SobreScreen({
    super.key,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = AppBackground(
      dark: true,
      opacity: 0.42,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
        child: Column(
          children: [
            const Text(
              'Sobre',
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
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.76),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Text(
                    'O Cidadania Ativa é uma plataforma que conecta cidadãos e órgãos públicos, permitindo o registro e acompanhamento de problemas urbanos de forma simples e acessível.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 26),
                  _InfoItem(
                    icon: Icons.track_changes,
                    title: 'Missão',
                    description:
                        'Facilitar a comunicação entre cidadãos e órgãos públicos para a identificação e resolução de problemas urbanos.',
                  ),
                  SizedBox(height: 22),
                  _InfoItem(
                    icon: Icons.remove_red_eye_outlined,
                    title: 'Visão',
                    description:
                        'Contribuir para cidades mais inteligentes, organizadas e sustentáveis através da participação da população.',
                  ),
                  SizedBox(height: 22),
                  _InfoItem(
                    icon: Icons.diamond_outlined,
                    title: 'Valores',
                    description:
                        'Transparência, cidadania, inovação, acessibilidade, responsabilidade social e compromisso com a comunidade.',
                  ),
                  SizedBox(height: 26),
                  Text(
                    'Obrigado pela sua contribuição.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Desenvolvido por:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Gustavo Marques\nNicoly Souza\nVictor Santana',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (embedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Sobre',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: content,
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}
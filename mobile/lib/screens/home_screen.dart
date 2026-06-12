import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/services/postagem_service.dart';
import '../widgets/app_background.dart';
import 'nova_denuncia_screen.dart';
import 'postagens_screen.dart';
import 'sobre_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<PostagemService>().carregarPostagens();
    });
  }

  void _goToInicio() {
    setState(() {
      _page = 0;
    });
  }

  void _goToPostagens() {
    setState(() {
      _page = 1;
    });
  }

  void _goToNovaDenuncia() {
    setState(() {
      _page = 2;
    });
  }

  void _goToSobre() {
    setState(() {
      _page = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;

    if (_page == 0) {
      currentPage = InicioContent(onStartDenuncia: _goToNovaDenuncia);
    } else if (_page == 1) {
      currentPage = PostagensScreen(
        embedded: true,
        onNovaDenuncia: _goToNovaDenuncia,
      );
    } else if (_page == 2) {
      currentPage = NovaDenunciaScreen(
        embedded: true,
        onCancel: _goToInicio,
        onSaved: _goToPostagens,
      );
    } else {
      currentPage = const SobreScreen(embedded: true);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF081D49),
      body: SafeArea(
        child: Column(
          children: [
            const _HeaderLogo(),
            _TopNavigation(
              selectedPage: _page,
              onInicio: _goToInicio,
              onPostagens: _goToPostagens,
              onNovaDenuncia: _goToNovaDenuncia,
              onSobre: _goToSobre,
            ),
            Expanded(child: currentPage),
          ],
        ),
      ),
    );
  }
}

class _HeaderLogo extends StatelessWidget {
  const _HeaderLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: double.infinity,
      color: const Color(0xFF0D2A63),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: Colors.white.withOpacity(0.18)),
            ),
            child: const Icon(
              Icons.account_balance,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Cidadania Ativa',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopNavigation extends StatelessWidget {
  final int selectedPage;
  final VoidCallback onInicio;
  final VoidCallback onPostagens;
  final VoidCallback onNovaDenuncia;
  final VoidCallback onSobre;

  const _TopNavigation({
    required this.selectedPage,
    required this.onInicio,
    required this.onPostagens,
    required this.onNovaDenuncia,
    required this.onSobre,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      color: const Color(0xFF102D67),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _NavItem(
              title: 'Início',
              selected: selectedPage == 0,
              onTap: onInicio,
            ),
            _NavItem(
              title: 'Postagens',
              selected: selectedPage == 1,
              onTap: onPostagens,
            ),
            _NavItem(
              title: 'Nova Denúncia',
              selected: selectedPage == 2,
              onTap: onNovaDenuncia,
            ),
            _NavItem(
              title: 'Sobre',
              selected: selectedPage == 3,
              onTap: onSobre,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: selected ? Colors.white.withOpacity(0.08) : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: selected ? const Color(0xFF4FC3F7) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class InicioContent extends StatelessWidget {
  final VoidCallback onStartDenuncia;

  const InicioContent({super.key, required this.onStartDenuncia});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      dark: true,
      opacity: 0.50,
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroSection(onStartDenuncia: onStartDenuncia),
            const _StatsBar(),
            const _HomeBody(),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final VoidCallback onStartDenuncia;

  const _HeroSection({required this.onStartDenuncia});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 54, 22, 54),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.lightBlueAccent.withOpacity(0.35),
              ),
            ),
            child: const Text(
              '📍 MARINGÁ · PARANÁ',
              style: TextStyle(
                color: Color(0xFFB8E5FF),
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Reporte problemas urbanos\nda sua cidade',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              height: 1.10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Envie denúncias sobre buracos, iluminação pública, lixo acumulado e outros problemas urbanos. Sua voz importa.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: onStartDenuncia,
            icon: const Text('📢'),
            label: const Text('Iniciar Denúncia'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF43A047),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  const _StatsBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1B2D4C).withOpacity(0.85),
      child: const Row(
        children: [
          Expanded(
            child: _StatItem(number: '250', label: 'Denúncias registradas'),
          ),
          Expanded(
            child: _StatItem(number: '180', label: 'Resolvidas'),
          ),
          Expanded(
            child: _StatItem(number: '15', label: 'Bairros atendidos'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String number;
  final String label;

  const _StatItem({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(
              color: Color(0xFF6EC6FF),
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 42, 22, 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _SectionTitle('CATEGORIAS'),
          SizedBox(height: 14),
          _CategoryList(),
          SizedBox(height: 32),
          _SectionTitle('DENÚNCIAS RECENTES'),
          SizedBox(height: 14),
          _RecentPostsList(),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.75),
        fontSize: 15,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _CategoryChip(emoji: '🕳️', title: 'Buracos', selected: true),
        _CategoryChip(emoji: '💡', title: 'Iluminação'),
        _CategoryChip(emoji: '🌊', title: 'Bueiros'),
        _CategoryChip(emoji: '🏞️', title: 'Áreas públicas'),
        _CategoryChip(emoji: '🗑️', title: 'Lixo'),
        _CategoryChip(emoji: '🚶', title: 'Calçadas'),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String emoji;
  final String title;
  final bool selected;

  const _CategoryChip({
    required this.emoji,
    required this.title,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF1E88E5)
            : Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected
              ? const Color(0xFF1E88E5)
              : Colors.white.withOpacity(0.25),
        ),
      ),
      child: Text(
        '$emoji  $title',
        style: TextStyle(
          color: selected ? Colors.white : Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _RecentPostsList extends StatelessWidget {
  const _RecentPostsList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _RecentPostCard(
          emoji: '🕳️',
          category: 'BURACO',
          title: 'Cratera no centro de Maringá',
          location: 'Av. Brasil',
          time: '2 dias atrás',
          description:
              'Grande buraco na Av. Brasil próximo ao terminal central, causando risco para veículos e pedestres.',
          likes: 47,
          status: 'Em andamento',
          statusColor: Color(0xFF1976D2),
        ),
        SizedBox(height: 16),
        _RecentPostCard(
          emoji: '🗑️',
          category: 'LIXO',
          title: 'Lixo acumulado em rua de Maringá',
          location: 'R. Santos Dumont',
          time: '1 dia atrás',
          description:
              'Acúmulo de entulho e lixo doméstico na calçada há mais de uma semana sem coleta.',
          likes: 23,
          status: 'Pendente',
          statusColor: Color(0xFFF57C00),
        ),
        SizedBox(height: 16),
        _RecentPostCard(
          emoji: '💡',
          category: 'ILUMINAÇÃO',
          title: 'Falta de iluminação em ruas de Maringá',
          location: 'Jd. Alvorada',
          time: '3 dias atrás',
          description:
              'Três postes sem funcionar deixam o trecho completamente escuro à noite, causando insegurança.',
          likes: 61,
          status: 'Resolvido',
          statusColor: Color(0xFF2E7D32),
        ),
      ],
    );
  }
}

class _RecentPostCard extends StatelessWidget {
  final String emoji;
  final String category;
  final String title;
  final String location;
  final String time;
  final String description;
  final int likes;
  final String status;
  final Color statusColor;

  const _RecentPostCard({
    required this.emoji,
    required this.category,
    required this.title,
    required this.location,
    required this.time,
    required this.description,
    required this.likes,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FA),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 126,
            width: double.infinity,
            color: const Color(0xFFDDE7F0),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 36)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CategoryBadge(category),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF13213B),
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '📍 $location · $time',
                  style: const TextStyle(
                    color: Color(0xFF607D8B),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF546E7A),
                    fontSize: 14,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFFE1E8EF)),
                Row(
                  children: [
                    Text(
                      '👍  $likes curtidas',
                      style: TextStyle(
                        color: likes > 50
                            ? const Color(0xFFE65100)
                            : const Color(0xFF546E7A),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String category;

  const _CategoryBadge(this.category);

  @override
  Widget build(BuildContext context) {
    Color background;
    Color textColor;

    if (category == 'BURACO') {
      background = const Color(0xFFFFE0B2);
      textColor = const Color(0xFFE65100);
    } else if (category == 'LIXO') {
      background = const Color(0xFFE1BEE7);
      textColor = const Color(0xFF8E24AA);
    } else if (category == 'ILUMINAÇÃO') {
      background = const Color(0xFFFFF9C4);
      textColor = const Color(0xFFF57F17);
    } else {
      background = const Color(0xFFBBDEFB);
      textColor = const Color(0xFF1565C0);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

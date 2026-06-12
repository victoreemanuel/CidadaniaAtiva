import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_colors.dart';
import 'core/services/postagem_service.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CidadaniaAtivaApp());
}

class CidadaniaAtivaApp extends StatelessWidget {
  const CidadaniaAtivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostagemService(),
      child: MaterialApp(
        title: 'Cidadania Ativa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
          ),
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
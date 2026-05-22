import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../features/hospedagens/pages/lista_hospedagens_page.dart';

class PousadaApp extends StatelessWidget {
  const PousadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Hospedagens',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const ListaHospedagensPage(),
    );
  }
}

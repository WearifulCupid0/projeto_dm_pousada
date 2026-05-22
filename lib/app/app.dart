import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../features/cadastro/pages/cadastro_hospedagem_page.dart';

class PousadaApp extends StatelessWidget {
  const PousadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Hospedagem',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const CadastroHospedagemPage(),
    );
  }
}

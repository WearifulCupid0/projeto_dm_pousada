import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'core/providers/hospedagem_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => HospedagemProvider(),
      child: const PousadaApp(),
    ),
  );
}

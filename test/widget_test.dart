import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pousada_sistema/app/app.dart';
import 'package:pousada_sistema/core/providers/hospedagem_provider.dart';
import 'package:pousada_sistema/core/models/hospedagem.dart';

Widget _buildApp() => ChangeNotifierProvider(
      create: (_) => HospedagemProvider(),
      child: const PousadaApp(),
    );

void main() {
  testWidgets('Tela inicial exibe estado vazio', (tester) async {
    await tester.pumpWidget(_buildApp());
    expect(find.text('Nenhuma hospedagem cadastrada'), findsOneWidget);
    expect(find.text('Nova Hospedagem'), findsOneWidget);
  });

  testWidgets('Botão Nova Hospedagem abre formulário', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.tap(find.text('Nova Hospedagem'));
    await tester.pumpAndSettle();
    expect(find.text('Nova Hospedagem'), findsWidgets); // AppBar title
    expect(find.text('Nome do Hóspede *'), findsOneWidget);
  });

  testWidgets('Formulário valida campos obrigatórios', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.tap(find.text('Nova Hospedagem'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cadastrar Hospedagem'));
    await tester.pump();
    expect(find.text('Informe o nome do hóspede.'), findsOneWidget);
    expect(find.text('Informe a quantidade de diárias.'), findsOneWidget);
    expect(find.text('Selecione o tipo de quarto.'), findsOneWidget);
    expect(find.text('Selecione a forma de pagamento.'), findsOneWidget);
  });

  testWidgets('Provider adiciona hospedagem corretamente', (tester) async {
    final prov = HospedagemProvider();
    prov.adicionar(
      nomeHospede: 'João Silva',
      tipoQuarto: TipoQuarto.luxo,
      quantidadeDiarias: 3,
      formaPagamento: FormaPagamento.pix,
      vagaGaragem: true,
    );
    expect(prov.totalHospedagens, 1);
    expect(prov.hospedagensFiltradas.first.nomeHospede, 'João Silva');
  });

  testWidgets('Busca filtra por nome', (tester) async {
    final prov = HospedagemProvider();
    prov.adicionar(
      nomeHospede: 'Maria Souza',
      tipoQuarto: TipoQuarto.standard,
      quantidadeDiarias: 2,
      formaPagamento: FormaPagamento.dinheiro,
      vagaGaragem: false,
    );
    prov.adicionar(
      nomeHospede: 'Carlos Lima',
      tipoQuarto: TipoQuarto.confort,
      quantidadeDiarias: 1,
      formaPagamento: FormaPagamento.cartaoCredito,
      vagaGaragem: false,
    );
    prov.setBusca('maria');
    expect(prov.hospedagensFiltradas.length, 1);
    expect(prov.hospedagensFiltradas.first.nomeHospede, 'Maria Souza');
  });

  test('Total da hospedagem calculado corretamente', () {
    final prov = HospedagemProvider();
    prov.adicionar(
      nomeHospede: 'Ana',
      tipoQuarto: TipoQuarto.luxo,    // R$ 450/diária
      quantidadeDiarias: 2,
      formaPagamento: FormaPagamento.pix,
      vagaGaragem: true,              // R$ 30/diária
    );
    final h = prov.hospedagensFiltradas.first;
    // (450 + 30) * 2 = 960
    expect(h.totalHospedagem, 960.0);
  });

  test('Provider remove hospedagem por id', () {
    final prov = HospedagemProvider();
    prov.adicionar(
      nomeHospede: 'Pedro',
      tipoQuarto: TipoQuarto.confort,
      quantidadeDiarias: 1,
      formaPagamento: FormaPagamento.dinheiro,
      vagaGaragem: false,
    );
    final id = prov.hospedagensFiltradas.first.id;
    prov.remover(id);
    expect(prov.totalHospedagens, 0);
  });
}

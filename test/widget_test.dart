import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pousada_app/main.dart';

void main() {
  testWidgets('App inicializa corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(const PousadaApp());

    // 2 TextFields: nome e idade
    expect(find.byType(TextField), findsNWidgets(2));
    // 1 DropdownButtonFormField: tipo de quarto
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    expect(find.text('Visualizar Dados'), findsOneWidget);
    expect(find.text('Limpar Campos'), findsOneWidget);
  });

  testWidgets('Exibe erros de validação quando campos estão vazios',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PousadaApp());

    await tester.tap(find.text('Visualizar Dados'));
    await tester.pump();

    expect(find.text('Informe o nome do hóspede.'), findsOneWidget);
    expect(find.text('Informe a idade.'), findsOneWidget);
    expect(find.text('Selecione um tipo de quarto.'), findsOneWidget);
  });

  testWidgets('Campo idade só aceita números', (WidgetTester tester) async {
    await tester.pumpWidget(const PousadaApp());

    final idadeField = find.byType(TextField).last;
    await tester.enterText(idadeField, 'abc');
    await tester.pump();

    final tf = tester.widget<TextField>(idadeField);
    expect(tf.controller?.text, isEmpty);
  });

  testWidgets('Abre AlertDialog com dados corretos',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PousadaApp());

    final fields = find.byType(TextField);
    await tester.enterText(fields.first, 'João da Silva');
    await tester.enterText(fields.last, '35');

    // Abre dropdown e seleciona Luxo
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Luxo').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Visualizar Dados'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('João da Silva'), findsOneWidget);
    expect(find.text('35 anos'), findsOneWidget);
    expect(find.text('Luxo'), findsWidgets);
  });

  testWidgets('Botão Limpar apaga os campos e reseta dropdown',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PousadaApp());

    final fields = find.byType(TextField);
    await tester.enterText(fields.first, 'Maria Souza');
    await tester.enterText(fields.last, '28');

    await tester.tap(find.text('Limpar Campos'));
    await tester.pump();

    final textFields = tester.widgetList<TextField>(fields).toList();
    expect(textFields[0].controller?.text, isEmpty);
    expect(textFields[1].controller?.text, isEmpty);
  });
}

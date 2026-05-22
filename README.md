# 🏨 Pousada App — Cadastro de Hospedagem

Aplicativo Flutter para cadastro inicial de hospedagem em pousada, desenvolvido com **Material 3**.

## 📋 Funcionalidades

- Cadastro de hóspede com nome e tipo de quarto
- Visualização dos dados em `AlertDialog`
- Limpeza dos campos com um botão
- Validação de campos obrigatórios via `SnackBar`
- Interface moderna com Material Design 3

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK `>=3.3.0`
- Dart SDK `>=3.3.0`
- Android Studio / VS Code com extensão Flutter

### Passos

```bash
# Clone ou extraia o projeto
cd pousada_app

# Instale as dependências
flutter pub get

# Execute o aplicativo
flutter run
```

## 🗂️ Estrutura do Projeto

```
pousada_app/
├── lib/
│   ├── main.dart                        # Ponto de entrada do app
│   ├── app/
│   │   └── app.dart                     # MaterialApp + Tema M3
│   ├── features/
│   │   └── cadastro/
│   │       ├── pages/
│   │       │   └── cadastro_hospedagem_page.dart
│   │       └── widgets/
│   │           ├── header_card.dart
│   │           ├── form_card.dart
│   │           └── info_row.dart
│   └── core/
│       └── theme/
│           └── app_theme.dart           # Definição do tema
├── test/
│   └── widget_test.dart
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

## 🎨 Tecnologias

- **Flutter** 3.x
- **Dart** 3.x
- **Material Design 3** (`useMaterial3: true`)
- `TextField` + `TextEditingController`
- `AlertDialog`, `FilledButton`, `OutlinedButton`

## 👨‍💻 Autor

Guilherme Campos Feuser

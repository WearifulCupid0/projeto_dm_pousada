# 🏨 Sistema de Hospedagens em Pousada

Aplicação Flutter completa para registrar, listar, editar e remover hospedagens em uma pousada, desenvolvida com **Material Design 3** e gerenciamento de estado via **Provider**.

---

## ⚠️ ATENÇÃO UTILIZAÇÃO DE IA

Este projeto foi utilizado IA para os seguintes itens:
 - Revisão do código
 - Criação do README.md
 - Verificação se o código valida todos os requisitos solicitados
 - Otimizações pontuais para melhor performance

---

## 📋 Requisitos Atendidos

| Requisito | Implementação |
|-----------|--------------|
| Nome do hóspede | `TextFormField` com validação (mín. 3 chars) |
| Tipo de quarto | `DropdownButtonFormField` — Standard / Confort / Luxo |
| Quantidade de diárias | `TextFormField` numérico (1–365), teclado numérico no mobile |
| Forma de pagamento | `DropdownButtonFormField` — Dinheiro / Débito / Crédito / Pix |
| Vaga de garagem | `SwitchListTile` animado |
| Criar hospedagem | Formulário em `FormularioHospedagemPage` (modo criação) |
| Listar hospedagens | `ListaHospedagensPage` com `ListView` |
| Editar hospedagem | Mesmo formulário reutilizado (modo edição) |
| Remover hospedagem | `AlertDialog` de confirmação + `PopupMenuButton` |
| Busca por hóspede | `TextField` de busca em tempo real |
| Filtro por tipo de quarto | `ChoiceChip` no `FiltrosSheet` (BottomSheet) |
| Filtro por forma de pagamento | `ChoiceChip` no `FiltrosSheet` |
| Validação de formulário | `Form` + `GlobalKey<FormState>` + `validator` em cada campo |
| README.md | Este arquivo |
| Documentação de IA | Pasta `/docs/ia_usage/` |

---

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK `>=3.3.0`
- Dart SDK `>=3.3.0`

### Passos

```bash
# 1. Entre na pasta do projeto
cd projeto_dm_pousada

# 2. Instale as dependências
flutter pub get

# 3. Execute o app
flutter run

# 4. (Opcional) Rode os testes
flutter test
```

---

## 🗂️ Estrutura do Projeto

```
projeto_dm_pousada/
├── lib/
│   ├── main.dart                            # Ponto de entrada + Provider
│   ├── app/
│   │   └── app.dart                         # MaterialApp + tema
│   ├── core/
│   │   ├── models/
│   │   │   └── hospedagem.dart              # Entidade + enums
│   │   ├── providers/
│   │   │   └── hospedagem_provider.dart     # Estado global (CRUD + filtros)
│   │   └── theme/
│   │       └── app_theme.dart               # Material 3 theme
│   └── features/
│       └── hospedagens/
│           ├── pages/
│           │   ├── lista_hospedagens_page.dart   # Listagem + busca + filtros
│           │   └── formulario_hospedagem_page.dart # Criar / Editar
│           └── widgets/
│               ├── hospedagem_card.dart     # Card da lista
│               └── filtros_sheet.dart       # BottomSheet de filtros
├── test/
│   └── widget_test.dart                     # Testes unitários e de widget
├── docs/
│   └── ia_usage/
│       └── uso_ia.md                        # Documentação do uso de IA
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

---

## 🧠 Arquitetura

O projeto segue a arquitetura **Feature-first** com separação por camadas:

- **`core/models`** — entidades de domínio puras (`Hospedagem`, `TipoQuarto`, `FormaPagamento`)
- **`core/providers`** — gerenciamento de estado com `ChangeNotifier` (Provider)
- **`core/theme`** — tema centralizado com Material 3
- **`features/`** — UI organizada por funcionalidade (pages + widgets)

O fluxo de dados é unidirecional:

```
UI → Provider.método() → notifyListeners() → UI reconstruída
```

---

## 💰 Cálculo de Valores

| Tipo de Quarto | Valor/Diária |
|---------------|-------------|
| Standard | R$ 150,00 |
| Confort | R$ 250,00 |
| Luxo | R$ 450,00 |
| Vaga de Garagem | + R$ 30,00/diária |

---

## 🎨 Tecnologias

- **Flutter 3.x** + **Dart 3.x**
- **Material Design 3** (`useMaterial3: true`)
- **Provider** `^6.1.2` — gerenciamento de estado
- **UUID** `^4.4.0` — geração de IDs únicos
- `DropdownButtonFormField`, `SwitchListTile`, `Form` + `GlobalKey`
- `ModalBottomSheet`, `PopupMenuButton`, `Badge`, `ChoiceChip`

---

## 👨‍💻 Autor

**Guilherme Campos Feuser**

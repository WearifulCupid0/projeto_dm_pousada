# 🤖 Documentação do Uso de IA no Desenvolvimento

Este documento descreve como a Inteligência Artificial (IA) foi utilizada durante o desenvolvimento do **Sistema de Hospedagens em Pousada**.

---

## Ferramenta Utilizada

**Claude (Anthropic)** — modelo de linguagem utilizado como assistente de desenvolvimento via interface de chat em [claude.ai](https://claude.ai).

---

## Como a IA foi Utilizada

### 1. Geração de Código Inicial (Scaffolding)

A IA foi utilizada para gerar a estrutura inicial do projeto Flutter a partir dos requisitos fornecidos. O prompt inicial descrevia as funcionalidades esperadas (CRUD de hospedagens, filtros, validações), e a IA produziu:

- Estrutura de pastas seguindo a arquitetura **Feature-first**
- Entidade `Hospedagem` com enums `TipoQuarto` e `FormaPagamento`
- `HospedagemProvider` com `ChangeNotifier` para gerenciamento de estado
- Telas de listagem e formulário

### 2. Refinamento Iterativo

O desenvolvimento foi conduzido em iterações com a IA:

| Iteração | O que foi pedido | O que a IA gerou |
|----------|-----------------|-----------------|
| 1 | Projeto base com cadastro simples | `main.dart`, `app.dart`, formulário inicial |
| 2 | Validações, dropdown de tipo de quarto, campo numérico de idade | `FilteringTextInputFormatter`, `DropdownButtonFormField`, validações inline |
| 3 | Checkbox de termos de uso, switch de atendimento prioritário | `TermosCard`, `SwitchListTile`, `ModalBottomSheet` com termos |
| 4 | CRUD completo, listagem com busca e filtros, Provider | Arquitetura completa com `HospedagemProvider`, `FiltrosSheet`, `HospedagemCard` |

### 3. Geração de Testes

Os testes unitários e de widget foram gerados pela IA com base na lógica implementada, cobrindo:

- Estado vazio da lista
- Validação de formulário
- Lógica de busca e filtro no provider
- Cálculo de total da hospedagem
- Remoção de hospedagem por ID

### 4. Documentação

- `README.md` gerado com auxílio da IA, estruturado para cobrir todos os requisitos do projeto
- Este documento (`uso_ia.md`) foi elaborado com suporte da IA

---

## Revisão Humana

Todo o código gerado pela IA foi **revisado pelo desenvolvedor** antes de ser incorporado ao projeto. Foram verificados:

- Coerência com os requisitos da atividade
- Correto uso das APIs Flutter (Material 3, Provider, Form)
- Nomenclatura em português, conforme padrão do projeto
- Funcionamento correto das validações e do fluxo de dados

---

## Limitações Observadas

- A IA ocasionalmente gerava código com APIs deprecadas do Flutter, exigindo ajuste manual
- Partes da lógica de filtro combinado (busca + tipo + pagamento) foram revisadas para garantir que todos os critérios fossem aplicados simultaneamente
- O cálculo automático do total estimado no formulário exigiu revisão para atualizar em tempo real ao alterar campos

---

## Conclusão

O uso da IA acelerou significativamente o desenvolvimento, especialmente nas etapas de scaffolding, geração de widgets repetitivos e escrita de testes. A revisão humana foi essencial para garantir a qualidade e a aderência aos requisitos da atividade.

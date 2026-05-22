import 'package:flutter/material.dart';
import '../widgets/form_card.dart';
import '../widgets/termos_card.dart';
import '../widgets/info_row.dart';
import '../widgets/conteudo_termos.dart';

class CadastroHospedagemPage extends StatefulWidget {
  const CadastroHospedagemPage({super.key});

  @override
  State<CadastroHospedagemPage> createState() => _CadastroHospedagemPageState();
}

class _CadastroHospedagemPageState extends State<CadastroHospedagemPage> {
  final TextEditingController _hospedeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final FocusNode _hospedeFocus = FocusNode();
  final FocusNode _idadeFocus = FocusNode();

  String? _tipoQuartoSelecionado;
  bool _atendimentoPrioritario = false;
  bool _aceitouTermos = false;

  String? _erroHospede;
  String? _erroIdade;
  String? _erroTipoQuarto;
  String? _erroTermos;

  @override
  void dispose() {
    _hospedeController.dispose();
    _idadeController.dispose();
    _hospedeFocus.dispose();
    _idadeFocus.dispose();
    super.dispose();
  }

  bool _validar() {
    final hospede = _hospedeController.text.trim();
    final idadeText = _idadeController.text.trim();
    bool valido = true;

    setState(() {
      if (hospede.isEmpty) {
        _erroHospede = 'Informe o nome do hóspede.';
        valido = false;
      } else if (hospede.length < 3) {
        _erroHospede = 'O nome deve ter ao menos 3 caracteres.';
        valido = false;
      } else {
        _erroHospede = null;
      }

      if (idadeText.isEmpty) {
        _erroIdade = 'Informe a idade.';
        valido = false;
      } else {
        final idade = int.tryParse(idadeText);
        if (idade == null || idade < 1 || idade > 120) {
          _erroIdade = 'Informe uma idade entre 1 e 120 anos.';
          valido = false;
        } else {
          if (idade > 60) {
            _atendimentoPrioritario = true;
          }
          _erroIdade = null;
        }
      }

      if (_tipoQuartoSelecionado == null) {
        _erroTipoQuarto = 'Selecione um tipo de quarto.';
        valido = false;
      } else {
        _erroTipoQuarto = null;
      }

      if (!_aceitouTermos) {
        _erroTermos = 'Você deve aceitar os termos para continuar.';
        valido = false;
      } else {
        _erroTermos = null;
      }
    });

    return valido;
  }

  void _visualizarDados() {
    FocusScope.of(context).unfocus();
    if (!_validar()) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.hotel_rounded, size: 36),
        title: const Text(
          'Dados da Hospedagem',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            const SizedBox(height: 8),
            InfoRow(
              icon: Icons.person_rounded,
              label: 'Hóspede',
              value: _hospedeController.text.trim(),
            ),
            const SizedBox(height: 12),
            InfoRow(
              icon: Icons.cake_rounded,
              label: 'Idade',
              value: '${_idadeController.text.trim()} anos',
            ),
            const SizedBox(height: 12),
            InfoRow(
              icon: Icons.bed_rounded,
              label: 'Tipo de Quarto',
              value: _tipoQuartoSelecionado!,
            ),
            const SizedBox(height: 12),
            InfoRow(
              icon: _atendimentoPrioritario
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              label: 'Atendimento',
              value: _atendimentoPrioritario ? 'Prioritário' : 'Padrão',
            ),
            const SizedBox(height: 12),
            const InfoRow(
              icon: Icons.gavel_rounded,
              label: 'Termos de Uso',
              value: 'Aceitos',
            ),
            const SizedBox(height: 8),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.check_rounded),
            label: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _limparCampos() {
    _hospedeController.clear();
    _idadeController.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      _tipoQuartoSelecionado = null;
      _atendimentoPrioritario = false;
      _aceitouTermos = false;
      _erroHospede = null;
      _erroIdade = null;
      _erroTipoQuarto = null;
      _erroTermos = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Campos limpos com sucesso!')),
    );
  }

  void _abrirTermos() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (_, scrollController) => Column(
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Icon(Icons.gavel_rounded,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Termos de Uso',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: const ConteudoTermos(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    setState(() {
                      _aceitouTermos = true;
                      _erroTermos = null;
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Termos aceitos com sucesso!')),
                    );
                  },
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Aceitar e Fechar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Icon(Icons.hotel_rounded),
        ),
        title: const Text(
          'Cadastro de Hospedagem',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              FormCard(
                hospedeController: _hospedeController,
                idadeController: _idadeController,
                tipoQuartoSelecionado: _tipoQuartoSelecionado,
                hospedeFocus: _hospedeFocus,
                idadeFocus: _idadeFocus,
                onTipoQuartoChanged: (v) =>
                    setState(() => _tipoQuartoSelecionado = v),
                onSubmit: _visualizarDados,
                erroHospede: _erroHospede,
                erroIdade: _erroIdade,
                erroTipoQuarto: _erroTipoQuarto,
              ),
              const SizedBox(height: 16),
              TermosCard(
                aceitouTermos: _aceitouTermos,
                atendimentoPrioritario: _atendimentoPrioritario,
                onTermosChanged: (v) => setState(() {
                  _aceitouTermos = v ?? false;
                  if (_aceitouTermos) _erroTermos = null;
                }),
                onPrioritarioChanged: (v) =>
                    setState(() => _atendimentoPrioritario = v),
                onVerTermos: _abrirTermos,
                erroTermos: _erroTermos,
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: _visualizarDados,
                icon: const Icon(Icons.visibility_rounded),
                label: const Text('Visualizar Dados'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _limparCampos,
                icon: const Icon(Icons.cleaning_services_rounded),
                label: const Text('Limpar Campos'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

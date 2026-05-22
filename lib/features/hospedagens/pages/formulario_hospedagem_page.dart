import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/models/hospedagem.dart';
import '../../../core/providers/hospedagem_provider.dart';

class FormularioHospedagemPage extends StatefulWidget {
  final Hospedagem? hospedagem;

  const FormularioHospedagemPage({super.key, this.hospedagem});

  bool get modoEdicao => hospedagem != null;

  @override
  State<FormularioHospedagemPage> createState() =>
      _FormularioHospedagemPageState();
}

class _FormularioHospedagemPageState extends State<FormularioHospedagemPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeCtrl;
  late final TextEditingController _diariasCtrl;

  TipoQuarto? _tipoQuarto;
  FormaPagamento? _formaPagamento;
  bool _vagaGaragem = false;

  @override
  void initState() {
    super.initState();
    final h = widget.hospedagem;
    _nomeCtrl = TextEditingController(text: h?.nomeHospede ?? '');
    _diariasCtrl =
        TextEditingController(text: h != null ? '${h.quantidadeDiarias}' : '');
    _tipoQuarto = h?.tipoQuarto;
    _formaPagamento = h?.formaPagamento;
    _vagaGaragem = h?.vagaGaragem ?? false;
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _diariasCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final prov = context.read<HospedagemProvider>();

    if (widget.modoEdicao) {
      prov.editar(
        id: widget.hospedagem!.id,
        nomeHospede: _nomeCtrl.text.trim(),
        tipoQuarto: _tipoQuarto!,
        quantidadeDiarias: int.parse(_diariasCtrl.text.trim()),
        formaPagamento: _formaPagamento!,
        vagaGaragem: _vagaGaragem,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hospedagem atualizada com sucesso!')),
      );
    } else {
      prov.adicionar(
        nomeHospede: _nomeCtrl.text.trim(),
        tipoQuarto: _tipoQuarto!,
        quantidadeDiarias: int.parse(_diariasCtrl.text.trim()),
        formaPagamento: _formaPagamento!,
        vagaGaragem: _vagaGaragem,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hospedagem cadastrada com sucesso!')),
      );
    }

    Navigator.of(context).pop();
  }

  double get _totalEstimado {
    final diarias = int.tryParse(_diariasCtrl.text.trim()) ?? 0;
    if (_tipoQuarto == null || diarias <= 0) return 0;
    return Hospedagem.valorDiaria(_tipoQuarto!) * diarias +
        (_vagaGaragem ? 30.0 * diarias : 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(
          widget.modoEdicao ? 'Editar Hospedagem' : 'Nova Hospedagem',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _SectionHeader(icon: Icons.person_rounded, title: 'Dados do Hóspede'),
            const SizedBox(height: 14),

            TextFormField(
              controller: _nomeCtrl,
              decoration: const InputDecoration(
                labelText: 'Nome do Hóspede *',
                hintText: 'Digite o nome completo',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Informe o nome do hóspede.';
                }
                if (v.trim().length < 3) {
                  return 'O nome deve ter ao menos 3 caracteres.';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            const _SectionHeader(
                icon: Icons.bed_rounded, title: 'Detalhes da Estadia'),
            const SizedBox(height: 14),

            DropdownButtonFormField<TipoQuarto>(
              value: _tipoQuarto,
              decoration: const InputDecoration(
                labelText: 'Tipo de Quarto *',
                prefixIcon: Icon(Icons.bed_outlined),
              ),
              hint: const Text('Selecione o tipo'),
              items: TipoQuarto.values.map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Row(
                    children: [
                      Icon(_iconeTipo(tipo), size: 18, color: cs.primary),
                      const SizedBox(width: 10),
                      Text(tipo.label),
                      const Spacer(),
                      Text(
                        'R\$ ${Hospedagem.valorDiaria(tipo).toStringAsFixed(0)}/diária',
                        style: tt.bodySmall
                            ?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) => setState(() => _tipoQuarto = v),
              validator: (v) =>
                  v == null ? 'Selecione o tipo de quarto.' : null,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _diariasCtrl,
              decoration: const InputDecoration(
                labelText: 'Quantidade de Diárias *',
                hintText: 'Ex: 3',
                prefixIcon: Icon(Icons.calendar_today_outlined),
                counterText: '',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _DiariasFormatter(),
              ],
              maxLength: 3,
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Informe a quantidade de diárias.';
                }
                final n = int.tryParse(v.trim());
                if (n == null || n < 1) {
                  return 'Informe ao menos 1 diária.';
                }
                if (n > 365) {
                  return 'Máximo de 365 diárias.';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            const _SectionHeader(
                icon: Icons.payment_rounded, title: 'Pagamento'),
            const SizedBox(height: 14),

            DropdownButtonFormField<FormaPagamento>(
              value: _formaPagamento,
              decoration: const InputDecoration(
                labelText: 'Forma de Pagamento *',
                prefixIcon: Icon(Icons.credit_card_outlined),
              ),
              hint: const Text('Selecione a forma'),
              items: FormaPagamento.values.map((forma) {
                return DropdownMenuItem(
                  value: forma,
                  child: Row(
                    children: [
                      Icon(_iconeForma(forma), size: 18, color: cs.primary),
                      const SizedBox(width: 10),
                      Text(forma.label),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) => setState(() => _formaPagamento = v),
              validator: (v) =>
                  v == null ? 'Selecione a forma de pagamento.' : null,
            ),

            const SizedBox(height: 16),

            const _SectionHeader(icon: Icons.tune_rounded, title: 'Extras'),
            const SizedBox(height: 10),

            Card(
              color: _vagaGaragem
                  ? cs.primaryContainer.withOpacity(0.5)
                  : cs.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: _vagaGaragem
                      ? cs.primary.withOpacity(0.4)
                      : cs.outlineVariant,
                ),
              ),
              child: SwitchListTile(
                value: _vagaGaragem,
                onChanged: (v) => setState(() => _vagaGaragem = v),
                title: Text(
                  'Vaga de Garagem',
                  style: tt.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  _vagaGaragem
                      ? 'R\$ 30,00 por diária (incluído no total)'
                      : 'Solicitar vaga coberta no estacionamento',
                  style: tt.bodySmall?.copyWith(
                    color: _vagaGaragem ? cs.primary : cs.onSurfaceVariant,
                  ),
                ),
                secondary: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _vagaGaragem
                        ? cs.primaryContainer
                        : cs.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _vagaGaragem
                        ? Icons.directions_car_rounded
                        : Icons.directions_car_outlined,
                    color: _vagaGaragem ? cs.primary : cs.onSurfaceVariant,
                    size: 22,
                  ),
                ),
                activeColor: cs.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 24),

            _TotalEstimadoCard(total: _totalEstimado),

            const SizedBox(height: 28),

            FilledButton.icon(
              onPressed: _salvar,
              icon: Icon(
                  widget.modoEdicao ? Icons.save_rounded : Icons.check_rounded),
              label: Text(
                  widget.modoEdicao ? 'Salvar Alterações' : 'Cadastrar Hospedagem'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded),
              label: const Text('Cancelar'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  IconData _iconeTipo(TipoQuarto tipo) {
    switch (tipo) {
      case TipoQuarto.standard:
        return Icons.bed_rounded;
      case TipoQuarto.confort:
        return Icons.hotel_rounded;
      case TipoQuarto.luxo:
        return Icons.star_rounded;
    }
  }

  IconData _iconeForma(FormaPagamento forma) {
    switch (forma) {
      case FormaPagamento.dinheiro:
        return Icons.money_rounded;
      case FormaPagamento.cartaoDebito:
        return Icons.credit_card_rounded;
      case FormaPagamento.cartaoCredito:
        return Icons.credit_score_rounded;
      case FormaPagamento.pix:
        return Icons.qr_code_rounded;
    }
  }
}

class _TotalEstimadoCard extends StatelessWidget {
  final double total;
  const _TotalEstimadoCard({required this.total});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    if (total <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.receipt_long_rounded, color: cs.onSecondaryContainer),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Estimado',
                style: tt.labelMedium
                    ?.copyWith(color: cs.onSecondaryContainer),
              ),
              const SizedBox(height: 2),
              Text(
                'R\$ ${total.toStringAsFixed(2)}',
                style: tt.headlineSmall?.copyWith(
                  color: cs.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: cs.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: cs.outlineVariant)),
      ],
    );
  }
}

class _DiariasFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    final n = int.tryParse(newValue.text);
    if (n == null || n < 0) return oldValue;
    if (n > 365) return oldValue;
    return newValue;
  }
}

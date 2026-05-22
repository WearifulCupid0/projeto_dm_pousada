import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/hospedagem.dart';
import '../../../core/providers/hospedagem_provider.dart';

class FiltrosSheet extends StatelessWidget {
  const FiltrosSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<HospedagemProvider>();
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

            // Título
            Row(
              children: [
                Icon(Icons.tune_rounded, color: cs.primary),
                const SizedBox(width: 10),
                Text(
                  'Filtros',
                  style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (prov.temFiltrosAtivos)
                  TextButton(
                    onPressed: () {
                      prov.limparFiltros();
                      Navigator.pop(context);
                    },
                    child: const Text('Limpar tudo'),
                  ),
              ],
            ),

            const SizedBox(height: 20),
            Text(
              'Tipo de Quarto',
              style: tt.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                _OpcaoChip(
                  label: 'Todos',
                  selecionado: prov.filtroTipoQuarto == null,
                  onTap: () => prov.setFiltroTipoQuarto(null),
                ),
                ...TipoQuarto.values.map(
                  (tipo) => _OpcaoChip(
                    label: tipo.label,
                    selecionado: prov.filtroTipoQuarto == tipo,
                    onTap: () => prov.setFiltroTipoQuarto(tipo),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Text(
              'Forma de Pagamento',
              style: tt.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _OpcaoChip(
                  label: 'Todas',
                  selecionado: prov.filtroFormaPagamento == null,
                  onTap: () => prov.setFiltroFormaPagamento(null),
                ),
                ...FormaPagamento.values.map(
                  (forma) => _OpcaoChip(
                    label: forma.label,
                    selecionado: prov.filtroFormaPagamento == forma,
                    onTap: () => prov.setFiltroFormaPagamento(forma),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check_rounded),
                label: const Text('Aplicar Filtros'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpcaoChip extends StatelessWidget {
  final String label;
  final bool selecionado;
  final VoidCallback onTap;

  const _OpcaoChip({
    required this.label,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: selecionado,
      onSelected: (_) => onTap(),
      selectedColor: cs.primaryContainer,
      labelStyle: TextStyle(
        color: selecionado ? cs.onPrimaryContainer : cs.onSurface,
        fontWeight: selecionado ? FontWeight.w600 : FontWeight.normal,
      ),
      showCheckmark: selecionado,
      checkmarkColor: cs.onPrimaryContainer,
    );
  }
}

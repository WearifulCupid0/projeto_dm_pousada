import 'package:flutter/material.dart';
import '../../../core/models/hospedagem.dart';

class HospedagemCard extends StatelessWidget {
  final Hospedagem hospedagem;
  final VoidCallback onEditar;
  final VoidCallback onRemover;

  const HospedagemCard({
    super.key,
    required this.hospedagem,
    required this.onEditar,
    required this.onRemover,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final h = hospedagem;

    return Card(
      color: cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: InkWell(
        onTap: onEditar,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: cs.primaryContainer,
                    radius: 22,
                    child: Text(
                      h.nomeHospede.isNotEmpty
                          ? h.nomeHospede[0].toUpperCase()
                          : '?',
                      style: tt.titleMedium?.copyWith(
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          h.nomeHospede,
                          style: tt.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _BadgeQuarto(tipo: h.tipoQuarto),
                            const SizedBox(width: 6),
                            if (h.vagaGaragem) _BadgeGaragem(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert_rounded,
                        color: cs.onSurfaceVariant),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onSelected: (v) {
                      if (v == 'editar') onEditar();
                      if (v == 'remover') onRemover();
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'editar',
                        child: Row(children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 10),
                          Text('Editar'),
                        ]),
                      ),
                      PopupMenuItem(
                        value: 'remover',
                        child: Row(children: [
                          Icon(Icons.delete_outline_rounded,
                              size: 18,
                              color: Theme.of(context).colorScheme.error),
                          const SizedBox(width: 10),
                          Text('Remover',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.error)),
                        ]),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),
              Divider(height: 1, color: cs.outlineVariant.withValues(alpha: 0.5)),
              const SizedBox(height: 12),

              Row(
                children: [
                  _InfoItem(
                    icon: Icons.calendar_today_outlined,
                    label:
                        '${h.quantidadeDiarias} diária${h.quantidadeDiarias > 1 ? 's' : ''}',
                  ),
                  const SizedBox(width: 16),
                  _InfoItem(
                    icon: _iconeForma(h.formaPagamento),
                    label: h.formaPagamento.label,
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total',
                        style: tt.labelSmall
                            ?.copyWith(color: cs.onSurfaceVariant),
                      ),
                      Text(
                        'R\$ ${h.totalHospedagem.toStringAsFixed(2)}',
                        style: tt.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconeForma(FormaPagamento f) {
    switch (f) {
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

class _BadgeQuarto extends StatelessWidget {
  final TipoQuarto tipo;
  const _BadgeQuarto({required this.tipo});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        tipo.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: cs.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _BadgeGaragem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions_car_rounded,
              size: 11, color: cs.onTertiaryContainer),
          const SizedBox(width: 3),
          Text(
            'Garagem',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: cs.onTertiaryContainer,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: cs.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

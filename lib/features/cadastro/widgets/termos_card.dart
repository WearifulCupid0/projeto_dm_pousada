import 'package:flutter/material.dart';

class TermosCard extends StatelessWidget {
  final bool aceitouTermos;
  final bool atendimentoPrioritario;
  final ValueChanged<bool?> onTermosChanged;
  final ValueChanged<bool> onPrioritarioChanged;
  final String? erroTermos;
  final VoidCallback onVerTermos;

  const TermosCard({
    super.key,
    required this.aceitouTermos,
    required this.atendimentoPrioritario,
    required this.onTermosChanged,
    required this.onPrioritarioChanged,
    required this.onVerTermos,
    this.erroTermos,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título da seção
            Row(
              children: [
                Icon(Icons.tune_rounded, color: colorScheme.primary, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Preferências e Termos',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Switch: Atendimento Prioritário ────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: atendimentoPrioritario
                    ? colorScheme.primaryContainer.withOpacity(0.5)
                    : colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: atendimentoPrioritario
                      ? colorScheme.primary.withOpacity(0.4)
                      : colorScheme.outlineVariant,
                ),
              ),
              child: SwitchListTile(
                value: atendimentoPrioritario,
                onChanged: onPrioritarioChanged,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(
                  'Atendimento Prioritário',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  atendimentoPrioritario
                      ? 'Ativado — check-in preferencial e suporte dedicado.'
                      : 'Atendimento padrão.',
                  style: textTheme.bodySmall?.copyWith(
                    color: atendimentoPrioritario
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                secondary: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: atendimentoPrioritario
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    atendimentoPrioritario
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: atendimentoPrioritario
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    size: 22,
                  ),
                ),
                activeColor: colorScheme.primary,
              ),
            ),

            const SizedBox(height: 16),

            // ── Termos de Uso ──────────────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox + label
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: aceitouTermos,
                      onChanged: onTermosChanged,
                      isError: erroTermos != null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Li e aceito os ',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          GestureDetector(
                            onTap: onVerTermos,
                            child: Text(
                              'Termos de Uso e Política de Privacidade',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: colorScheme.primary,
                              ),
                            ),
                          ),
                          Text(
                            ' da pousada.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Mensagem de erro dos termos
                if (erroTermos != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline_rounded,
                            size: 14, color: colorScheme.error),
                        const SizedBox(width: 4),
                        Text(
                          erroTermos!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
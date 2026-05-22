import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormCard extends StatelessWidget {
  final TextEditingController hospedeController;
  final TextEditingController idadeController;
  final String? tipoQuartoSelecionado;
  final FocusNode hospedeFocus;
  final FocusNode idadeFocus;
  final ValueChanged<String?> onTipoQuartoChanged;
  final VoidCallback onSubmit;

  // Mensagens de erro vindas da validação na page
  final String? erroHospede;
  final String? erroIdade;
  final String? erroTipoQuarto;

  static const List<String> tiposDeQuarto = [
    'Standard',
    'Confort',
    'Luxo',
    'Cobertura'
  ];

  const FormCard({
    super.key,
    required this.hospedeController,
    required this.idadeController,
    required this.tipoQuartoSelecionado,
    required this.hospedeFocus,
    required this.idadeFocus,
    required this.onTipoQuartoChanged,
    required this.onSubmit,
    this.erroHospede,
    this.erroIdade,
    this.erroTipoQuarto,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
            // Título
            Row(
              children: [
                Icon(Icons.assignment_ind_rounded,
                    color: colorScheme.primary, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Informações do Hóspede',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Campo: Nome do Hóspede ────────────────────────────────────
            TextField(
              controller: hospedeController,
              focusNode: hospedeFocus,
              decoration: InputDecoration(
                labelText: 'Nome do Hóspede *',
                hintText: 'Digite o nome completo',
                prefixIcon: const Icon(Icons.person_outline_rounded),
                errorText: erroHospede,
              ),
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => idadeFocus.requestFocus(),
            ),

            const SizedBox(height: 16),

            // ── Campo: Idade ───────────────────────────────────────────────
            // keyboardType: number → teclado numérico no celular
            // FilteringTextInputFormatter.digitsOnly → bloqueia letras no desktop
            // _IdadeInputFormatter → limita 1-120
            TextField(
              controller: idadeController,
              focusNode: idadeFocus,
              decoration: InputDecoration(
                labelText: 'Idade *',
                hintText: 'Ex: 30',
                prefixIcon: const Icon(Icons.cake_outlined),
                counterText: '',
                helperText: 'Entre 1 e 120 anos',
                errorText: erroIdade,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _IdadeInputFormatter(),
              ],
              maxLength: 3,
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 16),

            // ── Dropdown: Tipo de Quarto ───────────────────────────────────
            // Valores fixos: Standard, Confort, Luxo
            DropdownButtonFormField<String>(
              value: tipoQuartoSelecionado,
              decoration: InputDecoration(
                labelText: 'Tipo de Quarto *',
                prefixIcon: const Icon(Icons.bed_outlined),
                fillColor: colorScheme.surfaceContainerLow,
                filled: true,
                errorText: erroTipoQuarto,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: erroTipoQuarto != null
                        ? colorScheme.error
                        : colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.error, width: 2),
                ),
              ),
              hint: const Text('Selecione o tipo de quarto'),
              items: tiposDeQuarto
                  .map(
                    (tipo) => DropdownMenuItem(
                      value: tipo,
                      child: Row(
                        children: [
                          Icon(_iconePorTipo(tipo),
                              size: 18, color: colorScheme.primary),
                          const SizedBox(width: 10),
                          Text(tipo),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onTipoQuartoChanged,
            ),

            const SizedBox(height: 12),

            Text(
              '* Campos obrigatórios',
              style:
                  TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconePorTipo(String tipo) {
    switch (tipo) {
      case 'Cobertura':
        return Icons.house;
      case 'Luxo':
        return Icons.star_rounded;
      case 'Confort':
        return Icons.hotel_rounded;
      case 'Standard':
      default:
        return Icons.bed_rounded;
    }
  }
}

/// Bloqueia entradas fora do intervalo 1–120
class _IdadeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final numero = int.tryParse(newValue.text);
    if (numero == null) return oldValue;
    if (numero > 120) return oldValue;
    return newValue;
  }
}

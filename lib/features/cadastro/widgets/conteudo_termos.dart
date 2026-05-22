import 'package:flutter/material.dart';

class ConteudoTermos extends StatelessWidget {
  const ConteudoTermos();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    Widget titulo(String texto) => Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 6),
          child: Text(
            texto,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        );

    Widget paragrafo(String texto) => Text(
          texto,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        paragrafo(
          'Bem-vindo à Pousada. Ao realizar o cadastro, você concorda com os termos e condições descritos abaixo. Leia com atenção antes de prosseguir.',
        ),
        titulo('1. Dados Pessoais'),
        paragrafo(
          'As informações fornecidas neste cadastro (nome, idade e tipo de quarto) são utilizadas exclusivamente para fins de reserva e gerenciamento da hospedagem. Não compartilhamos seus dados com terceiros sem o seu consentimento.',
        ),
        titulo('2. Atendimento Prioritário'),
        paragrafo(
          'O serviço de Atendimento Prioritário garante check-in preferencial, suporte dedicado 24h e acesso antecipado às instalações da pousada, sujeito à disponibilidade.',
        ),
        titulo('3. Cancelamento e Reembolso'),
        paragrafo(
          'Cancelamentos realizados com até 48 horas de antecedência têm direito a reembolso integral. Cancelamentos com menos de 48 horas estão sujeitos à retenção de 50% do valor da diária.',
        ),
        titulo('4. Responsabilidades do Hóspede'),
        paragrafo(
          'O hóspede é responsável pela conservação do quarto e das áreas comuns. Danos causados por mau uso serão cobrados ao responsável pela reserva.',
        ),
        titulo('5. Política de Privacidade'),
        paragrafo(
          'Seus dados são armazenados de forma segura e tratados conforme a Lei Geral de Proteção de Dados (LGPD — Lei nº 13.709/2018). Você pode solicitar a exclusão dos seus dados a qualquer momento.',
        ),
        titulo('6. Alterações nos Termos'),
        paragrafo(
          'A pousada reserva-se o direito de atualizar estes termos a qualquer momento. Notificações serão enviadas com antecedência razoável.',
        ),
        const SizedBox(height: 8),
        Text(
          'Última atualização: maio de 2025',
          style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withOpacity(0.6)),
        ),
      ],
    );
  }
}
enum TipoQuarto {
  standard('Standard'),
  confort('Confort'),
  luxo('Luxo');

  final String label;
  const TipoQuarto(this.label);

  static TipoQuarto fromLabel(String label) =>
      TipoQuarto.values.firstWhere((e) => e.label == label);
}

enum FormaPagamento {
  dinheiro('Dinheiro'),
  cartaoDebito('Cartão de Débito'),
  cartaoCredito('Cartão de Crédito'),
  pix('Pix');

  final String label;
  const FormaPagamento(this.label);

  static FormaPagamento fromLabel(String label) =>
      FormaPagamento.values.firstWhere((e) => e.label == label);
}

class Hospedagem {
  final String id;
  final String nomeHospede;
  final TipoQuarto tipoQuarto;
  final int quantidadeDiarias;
  final FormaPagamento formaPagamento;
  final bool vagaGaragem;
  final DateTime dataCadastro;

  const Hospedagem({
    required this.id,
    required this.nomeHospede,
    required this.tipoQuarto,
    required this.quantidadeDiarias,
    required this.formaPagamento,
    required this.vagaGaragem,
    required this.dataCadastro,
  });

  static double valorDiaria(TipoQuarto tipo) {
    switch (tipo) {
      case TipoQuarto.standard:
        return 150.0;
      case TipoQuarto.confort:
        return 250.0;
      case TipoQuarto.luxo:
        return 450.0;
    }
  }

  double get totalHospedagem =>
      valorDiaria(tipoQuarto) * quantidadeDiarias +
      (vagaGaragem ? 30.0 * quantidadeDiarias : 0.0);

  Hospedagem copyWith({
    String? id,
    String? nomeHospede,
    TipoQuarto? tipoQuarto,
    int? quantidadeDiarias,
    FormaPagamento? formaPagamento,
    bool? vagaGaragem,
    DateTime? dataCadastro,
  }) {
    return Hospedagem(
      id: id ?? this.id,
      nomeHospede: nomeHospede ?? this.nomeHospede,
      tipoQuarto: tipoQuarto ?? this.tipoQuarto,
      quantidadeDiarias: quantidadeDiarias ?? this.quantidadeDiarias,
      formaPagamento: formaPagamento ?? this.formaPagamento,
      vagaGaragem: vagaGaragem ?? this.vagaGaragem,
      dataCadastro: dataCadastro ?? this.dataCadastro,
    );
  }

  @override
  String toString() =>
      'Hospedagem(id: $id, hospede: $nomeHospede, quarto: ${tipoQuarto.label})';
}

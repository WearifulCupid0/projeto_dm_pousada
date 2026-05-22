import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/hospedagem.dart';

class HospedagemProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  final List<Hospedagem> _hospedagens = [];

  String _termoBusca = '';
  TipoQuarto? _filtroTipoQuarto;
  FormaPagamento? _filtroFormaPagamento;


  String get termoBusca => _termoBusca;
  TipoQuarto? get filtroTipoQuarto => _filtroTipoQuarto;
  FormaPagamento? get filtroFormaPagamento => _filtroFormaPagamento;

  bool get temFiltrosAtivos =>
      _termoBusca.isNotEmpty ||
      _filtroTipoQuarto != null ||
      _filtroFormaPagamento != null;

  List<Hospedagem> get hospedagensFiltradas {
    return _hospedagens.where((h) {
      final matchBusca = _termoBusca.isEmpty ||
          h.nomeHospede.toLowerCase().contains(_termoBusca.toLowerCase());
      final matchTipo =
          _filtroTipoQuarto == null || h.tipoQuarto == _filtroTipoQuarto;
      final matchPagamento = _filtroFormaPagamento == null ||
          h.formaPagamento == _filtroFormaPagamento;
      return matchBusca && matchTipo && matchPagamento;
    }).toList()
      ..sort((a, b) => b.dataCadastro.compareTo(a.dataCadastro));
  }

  int get totalHospedagens => _hospedagens.length;
  int get totalFiltradas => hospedagensFiltradas.length;

  void adicionar({
    required String nomeHospede,
    required TipoQuarto tipoQuarto,
    required int quantidadeDiarias,
    required FormaPagamento formaPagamento,
    required bool vagaGaragem,
  }) {
    final nova = Hospedagem(
      id: _uuid.v4(),
      nomeHospede: nomeHospede,
      tipoQuarto: tipoQuarto,
      quantidadeDiarias: quantidadeDiarias,
      formaPagamento: formaPagamento,
      vagaGaragem: vagaGaragem,
      dataCadastro: DateTime.now(),
    );
    _hospedagens.add(nova);
    notifyListeners();
  }

  void editar({
    required String id,
    required String nomeHospede,
    required TipoQuarto tipoQuarto,
    required int quantidadeDiarias,
    required FormaPagamento formaPagamento,
    required bool vagaGaragem,
  }) {
    final index = _hospedagens.indexWhere((h) => h.id == id);
    if (index == -1) return;
    _hospedagens[index] = _hospedagens[index].copyWith(
      nomeHospede: nomeHospede,
      tipoQuarto: tipoQuarto,
      quantidadeDiarias: quantidadeDiarias,
      formaPagamento: formaPagamento,
      vagaGaragem: vagaGaragem,
    );
    notifyListeners();
  }

  void remover(String id) {
    _hospedagens.removeWhere((h) => h.id == id);
    notifyListeners();
  }

  Hospedagem? buscarPorId(String id) {
    try {
      return _hospedagens.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

  void setBusca(String termo) {
    _termoBusca = termo;
    notifyListeners();
  }

  void setFiltroTipoQuarto(TipoQuarto? tipo) {
    _filtroTipoQuarto = tipo;
    notifyListeners();
  }

  void setFiltroFormaPagamento(FormaPagamento? forma) {
    _filtroFormaPagamento = forma;
    notifyListeners();
  }

  void limparFiltros() {
    _termoBusca = '';
    _filtroTipoQuarto = null;
    _filtroFormaPagamento = null;
    notifyListeners();
  }
}

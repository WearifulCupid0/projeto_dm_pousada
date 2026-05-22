import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/hospedagem.dart';
import '../../../core/providers/hospedagem_provider.dart';
import '../widgets/hospedagem_card.dart';
import '../widgets/filtros_sheet.dart';
import 'formulario_hospedagem_page.dart';

class ListaHospedagensPage extends StatelessWidget {
  const ListaHospedagensPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(Icons.hotel_rounded),
        ),
        title: const Text(
          'Hospedagens',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          _BotaoFiltros(),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _BarraBusca(),
          _ChipsFiltrosAtivos(),
          _ResumoResultados(),
          Expanded(child: _ListaHospedagens()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(context, null),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nova Hospedagem'),
      ),
    );
  }

  static void _abrirFormulario(BuildContext context, Hospedagem? hospedagem) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FormularioHospedagemPage(hospedagem: hospedagem),
      ),
    );
  }
}

class _BarraBusca extends StatefulWidget {
  @override
  State<_BarraBusca> createState() => _BarraBuscaState();
}

class _BarraBuscaState extends State<_BarraBusca> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: TextField(
        controller: _ctrl,
        decoration: InputDecoration(
          hintText: 'Buscar por nome do hóspede…',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _ctrl.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () {
                    _ctrl.clear();
                    context.read<HospedagemProvider>().setBusca('');
                  },
                )
              : null,
          fillColor: cs.surface,
        ),
        onChanged: context.read<HospedagemProvider>().setBusca,
      ),
    );
  }
}

class _ChipsFiltrosAtivos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prov = context.watch<HospedagemProvider>();
    if (!prov.temFiltrosAtivos) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final chips = <Widget>[];

    if (prov.filtroTipoQuarto != null) {
      chips.add(_FiltroChip(
        label: prov.filtroTipoQuarto!.label,
        onRemove: () => prov.setFiltroTipoQuarto(null),
      ));
    }
    if (prov.filtroFormaPagamento != null) {
      chips.add(_FiltroChip(
        label: prov.filtroFormaPagamento!.label,
        onRemove: () => prov.setFiltroFormaPagamento(null),
      ));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          Icon(Icons.filter_list_rounded, size: 16, color: cs.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Wrap(spacing: 6, children: chips),
          ),
          TextButton(
            onPressed: prov.limparFiltros,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              visualDensity: VisualDensity.compact,
            ),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }
}

class _FiltroChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _FiltroChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onDeleted: onRemove,
      deleteIcon: const Icon(Icons.close_rounded, size: 14),
      backgroundColor: cs.primaryContainer,
      labelStyle: TextStyle(color: cs.onPrimaryContainer),
      deleteIconColor: cs.onPrimaryContainer,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

class _BotaoFiltros extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final temFiltro = context.watch<HospedagemProvider>().temFiltrosAtivos;
    return Badge(
      isLabelVisible: temFiltro,
      child: IconButton(
        icon: const Icon(Icons.tune_rounded),
        tooltip: 'Filtros',
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (_) => ChangeNotifierProvider.value(
            value: context.read<HospedagemProvider>(),
            child: const FiltrosSheet(),
          ),
        ),
      ),
    );
  }
}

class _ResumoResultados extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prov = context.watch<HospedagemProvider>();
    final total = prov.totalHospedagens;
    final filtradas = prov.totalFiltradas;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Row(
        children: [
          Text(
            prov.temFiltrosAtivos
                ? '$filtradas de $total hospedagem(ns)'
                : '$total hospedagem(ns) cadastrada(s)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _ListaHospedagens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hospedagens = context.watch<HospedagemProvider>().hospedagensFiltradas;

    if (hospedagens.isEmpty) {
      return _EstadoVazio(
        temFiltro: context.read<HospedagemProvider>().temFiltrosAtivos,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: hospedagens.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final h = hospedagens[index];
        return HospedagemCard(
          hospedagem: h,
          onEditar: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => FormularioHospedagemPage(hospedagem: h),
            ),
          ),
          onRemover: () => _confirmarRemocao(context, h),
        );
      },
    );
  }

  void _confirmarRemocao(BuildContext context, Hospedagem h) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.delete_outline_rounded, size: 32),
        title: const Text('Remover Hospedagem?'),
        content: Text(
          'A hospedagem de "${h.nomeHospede}" será removida permanentemente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              context.read<HospedagemProvider>().remover(h.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Hospedagem de ${h.nomeHospede} removida.'),
                  action: SnackBarAction(
                    label: 'OK',
                    onPressed: () {},
                  ),
                ),
              );
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  final bool temFiltro;
  const _EstadoVazio({required this.temFiltro});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            temFiltro ? Icons.search_off_rounded : Icons.hotel_outlined,
            size: 72,
            color: cs.onSurfaceVariant.withOpacity(0.35),
          ),
          const SizedBox(height: 16),
          Text(
            temFiltro
                ? 'Nenhuma hospedagem encontrada'
                : 'Nenhuma hospedagem cadastrada',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            temFiltro
                ? 'Tente ajustar os filtros ou a busca.'
                : 'Toque em "Nova Hospedagem" para começar.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant.withOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

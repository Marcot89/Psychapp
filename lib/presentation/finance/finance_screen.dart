// lib/presentation/finance/finance_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/models/transaction.dart';
import '../../shared/theme/app_colors.dart';
import 'finance_notifier.dart';
import 'transaction_form_screen.dart';

class FinanceScreen extends ConsumerWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financeAsync = ref.watch(financeProvider);
    final currencyFmt = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      appBar: AppBar(title: const Text('Financeiro')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const TransactionFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: financeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (state) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(child: _SummaryCard(
                  label: 'Recebido',
                  value: currencyFmt.format(state.totalPaid),
                  color: AppColors.paid,
                )),
                const SizedBox(width: 12),
                Expanded(child: _SummaryCard(
                  label: 'Pendente',
                  value: currencyFmt.format(state.totalPending),
                  color: AppColors.pending,
                )),
              ],
            ),
            const SizedBox(height: 16),
            if (state.transactions.isEmpty)
              const Center(child: Text('Nenhum lançamento este mês.'))
            else
              ...state.transactions.map((t) => _TransactionTile(transaction: t)),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends ConsumerWidget {
  final Transaction transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fmt = DateFormat('dd/MM/yyyy');
    final currencyFmt = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Card(
      child: ListTile(
        leading: Icon(
          transaction.isPaid ? Icons.check_circle : Icons.radio_button_unchecked,
          color: transaction.isPaid ? AppColors.paid : AppColors.pending,
        ),
        title: Text(currencyFmt.format(transaction.amount)),
        subtitle: Text(fmt.format(transaction.date)),
        trailing: transaction.isPaid
            ? null
            : TextButton(
                onPressed: () => ref.read(financeProvider.notifier).markAsPaid(transaction.id),
                child: const Text('Marcar pago'),
              ),
      ),
    );
  }
}

// lib/presentation/finance/finance_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/models/transaction.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/empty_state.dart';
import 'finance_notifier.dart';
import 'pending_payments_screen.dart';
import 'transaction_form_screen.dart';

class FinanceScreen extends ConsumerWidget {
  const FinanceScreen({super.key});

  static final _currencyFmt = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financeAsync = ref.watch(financeProvider);
    final currencyFmt = _currencyFmt;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financeiro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.warning_amber),
            tooltip: 'Pagamentos pendentes',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const PendingPaymentsScreen(),
              ),
            ),
          ),
        ],
      ),
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
            _RevenueChart(data: state.monthlyRevenue),
            const SizedBox(height: 16),
            if (state.transactions.isEmpty)
              const EmptyState(
                icon: Icons.receipt_long,
                message: 'Nenhuma transação este mês.\nToque em + para registrar.',
              )
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
  static final _dateFmt = DateFormat('dd/MM/yyyy');
  static final _moneyFmt = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  final Transaction transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fmt = _dateFmt;
    final currencyFmt = _moneyFmt;

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

class _RevenueChart extends StatelessWidget {
  static const _chartColor = Color(0xFF5856D6);

  final List<MapEntry<DateTime, double>> data;
  const _RevenueChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final spots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.value);
    }).toList();

    final months = ['Jan','Fev','Mar','Abr','Mai','Jun',
                    'Jul','Ago','Set','Out','Nov','Dez'];

    final maxY = data.map((e) => e.value).fold(0.0, (a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 12),
              child: Text(
                'Receita — últimos 6 meses',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxY == 0 ? 100 : maxY * 1.2,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: Colors.grey.withValues(alpha: 0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 48,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const Text('');
                          return Text(
                            'R\$${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= data.length) {
                            return const Text('');
                          }
                          final month = data[idx].key.month - 1;
                          return Text(
                            months[month],
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: _chartColor,
                      barWidth: 2.5,
                      dotData: FlDotData(
                        getDotPainter: (spot, _, __, ___) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: _chartColor,
                          strokeWidth: 0,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: _chartColor.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

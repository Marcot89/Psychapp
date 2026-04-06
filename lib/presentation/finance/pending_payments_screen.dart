// lib/presentation/finance/pending_payments_screen.dart
// Tela que lista pacientes com cobranças pendentes (não pagas).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../app/providers.dart';
import '../../domain/models/patient.dart';
import '../patients/patient_detail_screen.dart';

// Record com paciente e total pendente
typedef _PendingEntry = ({Patient patient, double totalPending});

/// Carrega todos os pacientes com ao menos uma transação não paga nos últimos 12 meses.
final pendingPaymentsProvider = FutureProvider<List<_PendingEntry>>((ref) async {
  final txRepo = ref.read(transactionRepositoryProvider);
  final patientRepo = ref.read(patientRepositoryProvider);
  final now = DateTime.now();

  // Acumula total pendente por patientId
  final pendingByPatient = <String, double>{};
  for (int i = 0; i < 12; i++) {
    final month = DateTime(now.year, now.month - i, 1);
    final txs = await txRepo.getByMonth(month.year, month.month);
    for (final t in txs) {
      if (!t.isPaid) {
        pendingByPatient[t.patientId] =
            (pendingByPatient[t.patientId] ?? 0) + t.amount;
      }
    }
  }

  if (pendingByPatient.isEmpty) return [];

  // Busca dados dos pacientes
  final entries = <_PendingEntry>[];
  for (final entry in pendingByPatient.entries) {
    final patient = await patientRepo.getById(entry.key);
    if (patient != null) {
      entries.add((patient: patient, totalPending: entry.value));
    }
  }

  // Ordena pelo maior valor pendente primeiro
  entries.sort((a, b) => b.totalPending.compareTo(a.totalPending));
  return entries;
});

class PendingPaymentsScreen extends ConsumerWidget {
  const PendingPaymentsScreen({super.key});

  static final _moneyFmt = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(pendingPaymentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pagamentos Pendentes')),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 64, color: Color(0xFF34C759)),
                    SizedBox(height: 16),
                    Text(
                      'Nenhum pagamento pendente!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final e = entries[i];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFF3B30),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(e.patient.fullName),
                  subtitle: const Text('Pagamento pendente'),
                  trailing: Text(
                    _moneyFmt.format(e.totalPending),
                    style: const TextStyle(
                      color: Color(0xFFFF3B30),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PatientDetailScreen(patientId: e.patient.id),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

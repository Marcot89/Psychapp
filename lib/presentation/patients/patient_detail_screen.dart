// lib/presentation/patients/patient_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'patients_notifier.dart';
import 'patient_form_screen.dart';
import '../../domain/models/appointment.dart';
import '../../domain/models/transaction.dart';
import '../../app/providers.dart';

// Loads appointments for a specific patient
final _patientAppointmentsProvider =
    FutureProvider.family<List<Appointment>, String>((ref, patientId) async {
  final repo = ref.read(appointmentRepositoryProvider);
  return repo.getByPatient(patientId);
});

// Loads transactions for a specific patient across last 12 months
final _patientTransactionsProvider =
    FutureProvider.family<List<Transaction>, String>((ref, patientId) async {
  final repo = ref.read(transactionRepositoryProvider);
  final now = DateTime.now();
  final results = <Transaction>[];
  for (int i = 0; i < 12; i++) {
    final month = DateTime(now.year, now.month - i, 1);
    final txs = await repo.getByMonth(month.year, month.month);
    results.addAll(txs.where((t) => t.patientId == patientId));
  }
  return results;
});

class PatientDetailScreen extends ConsumerWidget {
  final String patientId;
  const PatientDetailScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientsAsync = ref.watch(patientsProvider);

    return patientsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Erro: $e'))),
      data: (patients) {
        final patient = patients.where((p) => p.id == patientId).firstOrNull;
        if (patient == null) {
          return const Scaffold(body: Center(child: Text('Paciente não encontrado')));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(patient.fullName),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => PatientFormScreen(patient: patient),
                )),
              ),
              IconButton(
                icon: const Icon(Icons.archive_outlined),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Arquivar paciente?'),
                      content: const Text('O paciente será desativado. O histórico será mantido.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Arquivar')),
                      ],
                    ),
                  );
                  if (confirm == true && context.mounted) {
                    await ref.read(patientsProvider.notifier).archive(patientId);
                    if (!context.mounted) return;
                    context.pop();
                  }
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dados do Paciente', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      if (patient.email.isNotEmpty) _row(context, Icons.email_outlined, patient.email),
                      if (patient.phone.isNotEmpty) _row(context, Icons.phone_outlined, patient.phone),
                      if (patient.notes.isNotEmpty) _row(context, Icons.note_outlined, patient.notes),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Sessões', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ref.watch(_patientAppointmentsProvider(patient.id)).when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Erro: $e'),
                data: (appointments) {
                  if (appointments.isEmpty) {
                    return const Card(
                      child: ListTile(
                        leading: Icon(Icons.event_busy, color: Colors.grey),
                        title: Text('Nenhuma sessão registrada'),
                      ),
                    );
                  }
                  final fmt = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');
                  return Column(
                    children: appointments.map((a) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.event, color: Color(0xFF5856D6)),
                        title: Text(fmt.format(a.startDate)),
                        subtitle: Text(a.type.name),
                        trailing: _statusChip(a.status),
                      ),
                    )).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text('Cobranças', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ref.watch(_patientTransactionsProvider(patient.id)).when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Erro: $e'),
                data: (txs) {
                  if (txs.isEmpty) {
                    return const Card(
                      child: ListTile(
                        leading: Icon(Icons.receipt_long, color: Colors.grey),
                        title: Text('Nenhuma cobrança registrada'),
                      ),
                    );
                  }
                  final fmtDate = DateFormat('dd/MM/yyyy', 'pt_BR');
                  final fmtMoney = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
                  return Column(
                    children: txs.map((t) => Card(
                      child: ListTile(
                        leading: Icon(
                          t.isPaid ? Icons.check_circle : Icons.pending,
                          color: t.isPaid ? const Color(0xFF34C759) : Colors.orange,
                        ),
                        title: Text(fmtMoney.format(t.amount)),
                        subtitle: Text(fmtDate.format(t.date)),
                        trailing: t.isPaid
                            ? const Text('Pago', style: TextStyle(color: Color(0xFF34C759)))
                            : const Text('Pendente', style: TextStyle(color: Colors.orange)),
                      ),
                    )).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _row(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _statusChip(AppointmentStatus status) {
    const labels = {
      AppointmentStatus.scheduled: 'Agendada',
      AppointmentStatus.confirmed: 'Confirmada',
      AppointmentStatus.completed: 'Realizada',
      AppointmentStatus.cancelled: 'Cancelada',
      AppointmentStatus.noShow: 'Falta',
    };
    const colors = {
      AppointmentStatus.scheduled: Colors.blue,
      AppointmentStatus.confirmed: Colors.green,
      AppointmentStatus.completed: Color(0xFF5856D6),
      AppointmentStatus.cancelled: Colors.red,
      AppointmentStatus.noShow: Colors.orange,
    };
    return Chip(
      label: Text(
        labels[status] ?? status.name,
        style: const TextStyle(fontSize: 11, color: Colors.white),
      ),
      backgroundColor: colors[status] ?? Colors.grey,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

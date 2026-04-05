// lib/presentation/patients/patient_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/patient.dart';
import 'patients_notifier.dart';
import 'patient_form_screen.dart';

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
}

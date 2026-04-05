// lib/presentation/patients/patients_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/patient.dart';
import 'patients_notifier.dart';
import 'patient_form_screen.dart';
import 'patient_detail_screen.dart';

class PatientsScreen extends ConsumerStatefulWidget {
  const PatientsScreen({super.key});

  @override
  ConsumerState<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends ConsumerState<PatientsScreen> {
  final _searchCtrl = TextEditingController();
  List<Patient>? _searchResults;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _searchResults = null);
      return;
    }
    final results = await ref.read(patientsProvider.notifier).search(query.trim());
    setState(() => _searchResults = results);
  }

  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(patientsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PatientFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Buscar paciente...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _searchResults = null);
                      })
                    : null,
              ),
            ),
          ),
          Expanded(
            child: _searchResults != null
                ? _PatientList(patients: _searchResults!)
                : patientsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Erro: $e')),
                    data: (patients) => patients.isEmpty
                        ? const Center(child: Text('Nenhum paciente cadastrado.\nToque em + para adicionar.', textAlign: TextAlign.center))
                        : _PatientList(patients: patients),
                  ),
          ),
        ],
      ),
    );
  }
}

class _PatientList extends StatelessWidget {
  final List<Patient> patients;
  const _PatientList({required this.patients});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: patients.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final p = patients[i];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(p.fullName.isNotEmpty ? p.fullName[0].toUpperCase() : '?'),
            ),
            title: Text(p.fullName),
            subtitle: p.phone.isNotEmpty ? Text(p.phone) : null,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => PatientDetailScreen(patientId: p.id),
            )),
          ),
        );
      },
    );
  }
}

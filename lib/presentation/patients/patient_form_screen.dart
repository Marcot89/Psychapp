// lib/presentation/patients/patient_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/patient.dart';
import 'patients_notifier.dart';

class PatientFormScreen extends ConsumerStatefulWidget {
  final Patient? patient;
  const PatientFormScreen({super.key, this.patient});

  @override
  ConsumerState<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends ConsumerState<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _notesCtrl;
  bool _loading = false;

  bool get _isEditing => widget.patient != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.patient?.fullName ?? '');
    _emailCtrl = TextEditingController(text: widget.patient?.email ?? '');
    _phoneCtrl = TextEditingController(text: widget.patient?.phone ?? '');
    _notesCtrl = TextEditingController(text: widget.patient?.notes ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final notifier = ref.read(patientsProvider.notifier);
    if (_isEditing) {
      await notifier.updatePatient(widget.patient!.copyWith(
        fullName: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        notes: _notesCtrl.text.trim(),
      ));
    } else {
      await notifier.add(
        _nameCtrl.text.trim(),
        _emailCtrl.text.trim(),
        _phoneCtrl.text.trim(),
        notes: _notesCtrl.text.trim(),
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Editar Paciente' : 'Novo Paciente')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nome completo *'),
              textCapitalization: TextCapitalization.words,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Nome obrigatório' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(labelText: 'Telefone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(labelText: 'Observações'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(_isEditing ? 'Salvar' : 'Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}

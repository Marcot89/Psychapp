// lib/presentation/schedule/appointment_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/models/appointment.dart';
import '../../domain/models/patient.dart';
import '../patients/patients_notifier.dart';
import 'schedule_notifier.dart';

class AppointmentFormScreen extends ConsumerStatefulWidget {
  /// If provided, the form opens in edit mode pre-filled with this appointment.
  final Appointment? appointment;
  const AppointmentFormScreen({super.key, this.appointment});

  @override
  ConsumerState<AppointmentFormScreen> createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends ConsumerState<AppointmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  Patient? _selectedPatient;
  late DateTime _startDate;
  late Duration _duration;
  late SessionType _type;
  late final TextEditingController _notesCtrl;
  bool _loading = false;

  bool get _isEditing => widget.appointment != null;
  DateTime get _endDate => _startDate.add(_duration);

  @override
  void initState() {
    super.initState();
    final a = widget.appointment;
    if (a != null) {
      _startDate = a.startDate;
      _duration = a.endDate.difference(a.startDate);
      _type = a.type;
      _notesCtrl = TextEditingController(text: a.notes);
    } else {
      _startDate = DateTime.now().add(const Duration(hours: 1));
      _duration = const Duration(hours: 1);
      _type = SessionType.individual;
      _notesCtrl = TextEditingController();
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startDate),
    );
    if (time == null) return;
    setState(() {
      _startDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isEditing && _selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um paciente')));
      return;
    }
    setState(() => _loading = true);

    if (_isEditing) {
      final updated = widget.appointment!.copyWith(
        startDate: _startDate,
        endDate: _endDate,
        type: _type,
        notes: _notesCtrl.text.trim(),
      );
      await ref.read(weekAppointmentsProvider.notifier).updateAppointment(updated);
    } else {
      await ref.read(weekAppointmentsProvider.notifier).add(
        patientId: _selectedPatient!.id,
        startDate: _startDate,
        endDate: _endDate,
        type: _type,
        notes: _notesCtrl.text.trim(),
      );
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(patientsProvider);
    final fmt = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Sessão' : 'Nova Sessão'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (!_isEditing)
              patientsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Erro: $e'),
                data: (patients) => DropdownButtonFormField<Patient>(
                  initialValue: _selectedPatient,
                  decoration: const InputDecoration(labelText: 'Paciente *'),
                  items: patients.map((p) => DropdownMenuItem(value: p, child: Text(p.fullName))).toList(),
                  onChanged: (p) => setState(() => _selectedPatient = p),
                  validator: (v) => v == null ? 'Selecione um paciente' : null,
                ),
              ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Data e hora'),
              subtitle: Text(fmt.format(_startDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDateTime,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Duração'),
              subtitle: Text('${_duration.inMinutes} minutos'),
              trailing: const Icon(Icons.timelapse),
              onTap: () async {
                final options = [30, 45, 50, 60, 90];
                final picked = await showDialog<int>(
                  context: context,
                  builder: (_) => SimpleDialog(
                    title: const Text('Duração (minutos)'),
                    children: options.map((m) => SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, m),
                      child: Text('$m minutos'),
                    )).toList(),
                  ),
                );
                if (picked != null) setState(() => _duration = Duration(minutes: picked));
              },
            ),
            DropdownButtonFormField<SessionType>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Tipo de sessão'),
              items: SessionType.values.map((t) => DropdownMenuItem(
                value: t,
                child: Text(_sessionTypeLabel(t)),
              )).toList(),
              onChanged: (t) => setState(() => _type = t!),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(labelText: 'Observações'),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Agendar Sessão'),
            ),
          ],
        ),
      ),
    );
  }

  String _sessionTypeLabel(SessionType t) => switch (t) {
    SessionType.individual => 'Individual',
    SessionType.couple => 'Casal',
    SessionType.family => 'Família',
    SessionType.evaluation => 'Avaliação',
    SessionType.other => 'Outro',
  };
}

// lib/presentation/schedule/schedule_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/models/appointment.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/empty_state.dart';
import 'schedule_notifier.dart';
import 'appointment_form_screen.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(weekAppointmentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Agenda — Esta Semana')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AppointmentFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: appointmentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (appointments) {
          if (appointments.isEmpty) {
            return const EmptyState(
              icon: Icons.event_note,
              message: 'Nenhuma sessão nesta semana.\nToque em + para agendar.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) => _AppointmentCard(appointment: appointments[i]),
          );
        },
      ),
    );
  }
}

class _AppointmentCard extends ConsumerWidget {
  static final _fmt = DateFormat('EEE dd/MM HH:mm');

  final Appointment appointment;
  const _AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _statusColor(appointment.status);

    return Card(
      child: ListTile(
        leading: Container(
          width: 4,
          height: 48,
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text('Sessão #${appointment.sessionNumber}'),
        subtitle: Text(_fmt.format(appointment.startDate)),
        trailing: PopupMenuButton<AppointmentStatus>(
          icon: const Icon(Icons.more_vert),
          onSelected: (status) => ref
              .read(weekAppointmentsProvider.notifier)
              .updateStatus(appointment.id, status),
          itemBuilder: (_) => AppointmentStatus.values
              .map((s) => PopupMenuItem(value: s, child: Text(_statusLabel(s))))
              .toList(),
        ),
      ),
    );
  }

  Color _statusColor(AppointmentStatus s) => switch (s) {
    AppointmentStatus.scheduled => AppColors.scheduled,
    AppointmentStatus.confirmed => AppColors.confirmed,
    AppointmentStatus.completed => AppColors.completed,
    AppointmentStatus.cancelled => AppColors.cancelled,
    AppointmentStatus.noShow => AppColors.noShow,
  };

  String _statusLabel(AppointmentStatus s) => switch (s) {
    AppointmentStatus.scheduled => 'Agendada',
    AppointmentStatus.confirmed => 'Confirmada',
    AppointmentStatus.completed => 'Realizada',
    AppointmentStatus.cancelled => 'Cancelada',
    AppointmentStatus.noShow => 'Falta',
  };
}

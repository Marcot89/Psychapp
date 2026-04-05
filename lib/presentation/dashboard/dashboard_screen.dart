// lib/presentation/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/models/appointment.dart';
import '../../shared/theme/app_colors.dart';
import '../patients/patients_notifier.dart';
import '../schedule/appointment_form_screen.dart';
import '../patients/patient_form_screen.dart';
import 'dashboard_notifier.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final patientsAsync = ref.watch(patientsProvider);
    final currencyFmt = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final timeFmt = DateFormat('HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('PsychApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(dashboardProvider),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(dashboardProvider),
        child: dashboardAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erro: $e')),
          data: (state) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Próxima sessão
              if (state.nextAppointment != null) ...[
                Text('Próxima sessão', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, size: 32, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sessão #${state.nextAppointment!.sessionNumber}',
                                style: Theme.of(context).textTheme.titleSmall),
                            Text(timeFmt.format(state.nextAppointment!.startDate),
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.primary, fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Receita do mês
              Text('Receita do mês', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.attach_money, size: 32, color: AppColors.paid),
                      const SizedBox(width: 12),
                      Text(currencyFmt.format(state.monthRevenue),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Sessões de hoje
              Text('Hoje (${state.todayAppointments.length} sessões)',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (state.todayAppointments.isEmpty)
                const Card(child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Nenhuma sessão hoje.'),
                ))
              else
                ...state.todayAppointments.map((a) => Card(
                  child: ListTile(
                    leading: Icon(Icons.circle, size: 12, color: _statusColor(a.status)),
                    title: Text('Sessão #${a.sessionNumber}'),
                    subtitle: Text('${timeFmt.format(a.startDate)} – ${timeFmt.format(a.endDate)}'),
                  ),
                )),
              const SizedBox(height: 16),

              // Atalhos rápidos
              Text('Atalhos', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Nova sessão'),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AppointmentFormScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.person_add),
                      label: const Text('Novo paciente'),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PatientFormScreen()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Total de pacientes
              patientsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (patients) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.people, color: AppColors.primary),
                    title: const Text('Pacientes ativos'),
                    trailing: Text('${patients.length}',
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                ),
              ),
            ],
          ),
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
}

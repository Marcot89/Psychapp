// lib/presentation/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (settings) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Seção Google Calendar
            Text('Google Calendar', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: settings.isGoogleSignedIn
                  ? ListTile(
                      leading: const Icon(Icons.check_circle, color: Color(0xFF34C759)),
                      title: const Text('Conectado'),
                      subtitle: Text(settings.googleEmail ?? ''),
                      trailing: TextButton(
                        onPressed: () => ref.read(settingsProvider.notifier).signOutGoogle(),
                        child: const Text('Desconectar'),
                      ),
                    )
                  : ListTile(
                      leading: const Icon(Icons.sync_disabled, color: Colors.grey),
                      title: const Text('Não conectado'),
                      subtitle: const Text('Conecte para sincronizar sessões'),
                      trailing: ElevatedButton(
                        onPressed: () => ref.read(settingsProvider.notifier).signInGoogle(),
                        child: const Text('Conectar'),
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            // Seção Notificações
            Text('Notificações', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: SwitchListTile(
                title: const Text('Lembretes de sessões'),
                subtitle: const Text('24h e 1h antes de cada sessão'),
                value: settings.notificationsEnabled,
                onChanged: (value) =>
                    ref.read(settingsProvider.notifier).toggleNotifications(value),
              ),
            ),
            const SizedBox(height: 24),
            // Sobre o app
            Text('Sobre', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Card(
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('PsychApp'),
                subtitle: Text('Versão 1.0.0 — Fase 2'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

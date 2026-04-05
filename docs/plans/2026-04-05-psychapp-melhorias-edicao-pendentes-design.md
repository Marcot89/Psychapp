# PsychApp — Design: Edição de Sessões + Tela de Pendentes

**Data:** 2026-04-05  
**Status:** Aprovado

---

## Melhoria 1: Edição de Sessão Existente

### Problema
`AppointmentFormScreen` só cria sessões. `ScheduleNotifier` não tem método para atualizar dados completos. Usuário não consegue alterar duração, data ou tipo de uma sessão já agendada.

### Solução

**`ScheduleNotifier`:** adicionar método `updateAppointment(Appointment updated)` que:
1. Chama `_repo.update(updated)`
2. Cancela notificações antigas e reagenda
3. Atualiza evento no Google Calendar se `googleEventId != null`
4. Invalida o provider

**`AppointmentFormScreen`:** receber parâmetro opcional `Appointment? appointment`:
- Se `null` → modo criação (comportamento atual)
- Se preenchido → modo edição: campos inicializados com valores existentes, botão chama `updateAppointment`

**`ScheduleScreen`:** adicionar opção "Editar" no `PopupMenuButton` do `_AppointmentCard`, que navega para `AppointmentFormScreen(appointment: a)`.

### Campos editáveis
- Data e hora de início
- Duração (30/45/50/60/90 min)
- Tipo de sessão
- Observações

### Campos não editáveis na edição
- Paciente (não muda o vínculo)
- Número da sessão (sequencial, não alterável)

---

## Melhoria 2: Tela de Clientes com Pagamentos Pendentes

### Problema
Não há forma de ver rapidamente quais pacientes têm cobranças em aberto.

### Solução

**Nova tela:** `PendingPaymentsScreen` (`lib/presentation/finance/pending_payments_screen.dart`)
- Acessada via botão no AppBar da `FinanceScreen` (ícone `Icons.warning_amber`)
- Lista pacientes com pelo menos uma transação `isPaid == false`
- Por paciente: nome + total pendente em BRL
- Toque → abre `PatientDetailScreen` do paciente (já mostra histórico de cobranças)

**Lógica de dados:**
- Novo provider `pendingPaymentsProvider` do tipo `FutureProvider<List<({Patient patient, double totalPending})>>`
- Busca transações dos últimos 12 meses onde `isPaid == false`
- Agrupa por `patientId`, soma valores, faz join com `PatientRepository.getById`

**Não requer:** mudança no banco de dados, novos repositórios ou novas rotas no go_router (usa `Navigator.push` simples como as outras telas de detalhe).

---

## Arquivos Afetados

| Arquivo | Mudança |
|---------|---------|
| `lib/presentation/schedule/schedule_notifier.dart` | Adicionar `updateAppointment()` |
| `lib/presentation/schedule/appointment_form_screen.dart` | Suporte a edição (parâmetro opcional) |
| `lib/presentation/schedule/schedule_screen.dart` | Opção "Editar" no PopupMenuButton |
| `lib/presentation/finance/finance_screen.dart` | Botão no AppBar → PendingPaymentsScreen |
| `lib/presentation/finance/pending_payments_screen.dart` | Nova tela (criar) |

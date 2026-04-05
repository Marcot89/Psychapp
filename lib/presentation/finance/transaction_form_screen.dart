// lib/presentation/finance/transaction_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/transaction.dart';
import '../patients/patients_notifier.dart';
import 'finance_notifier.dart';

class TransactionFormScreen extends ConsumerStatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  ConsumerState<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String? _selectedPatientId;
  PaymentMethod _method = PaymentMethod.pix;
  bool _isPaid = false;
  bool _loading = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPatientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione um paciente')));
      return;
    }
    setState(() => _loading = true);

    await ref.read(financeProvider.notifier).add(
      patientId: _selectedPatientId!,
      amount: double.parse(_amountCtrl.text.replaceAll(',', '.')),
      method: _method,
      isPaid: _isPaid,
      notes: _notesCtrl.text.trim(),
    );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(patientsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nova Cobrança')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            patientsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Erro: $e'),
              data: (patients) => DropdownButtonFormField<String>(
                initialValue: _selectedPatientId,
                decoration: const InputDecoration(labelText: 'Paciente *'),
                items: patients.map((p) => DropdownMenuItem(value: p.id, child: Text(p.fullName))).toList(),
                onChanged: (id) => setState(() => _selectedPatientId = id),
                validator: (v) => v == null ? 'Selecione um paciente' : null,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountCtrl,
              decoration: const InputDecoration(labelText: 'Valor (R\$) *', prefixText: 'R\$ '),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Informe o valor';
                final n = double.tryParse(v.replaceAll(',', '.'));
                if (n == null || n <= 0) return 'Valor inválido';
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<PaymentMethod>(
              initialValue: _method,
              decoration: const InputDecoration(labelText: 'Forma de pagamento'),
              items: PaymentMethod.values.map((m) => DropdownMenuItem(
                value: m,
                child: Text(_methodLabel(m)),
              )).toList(),
              onChanged: (m) => setState(() => _method = m!),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Já recebido'),
              value: _isPaid,
              onChanged: (v) => setState(() => _isPaid = v),
              contentPadding: EdgeInsets.zero,
            ),
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
                  : const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  String _methodLabel(PaymentMethod m) => switch (m) {
    PaymentMethod.pix => 'PIX',
    PaymentMethod.creditCard => 'Cartão',
    PaymentMethod.cash => 'Dinheiro',
    PaymentMethod.insurance => 'Plano de saúde',
    PaymentMethod.bankTransfer => 'Transferência',
  };
}

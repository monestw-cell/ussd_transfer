import 'package:flutter/material.dart';
  import 'package:uuid/uuid.dart';
  import '../models/service_model.dart';
  import '../models/transaction_model.dart';
  import '../services/ussd_service.dart';
  import '../services/storage_service.dart';
  import '../parsers/ussd_parser.dart';
  import '../widgets/menu_grid.dart';
  import '../widgets/input_dialog.dart';
  import '../widgets/amount_dialog.dart';
  import '../widgets/confirm_dialog.dart';

  class UssdFlowScreen extends StatefulWidget {
    final TransferService service;
    const UssdFlowScreen({super.key, required this.service});

    @override
    State<UssdFlowScreen> createState() => _UssdFlowScreenState();
  }

  class _UssdFlowScreenState extends State<UssdFlowScreen> {
    ParsedUssd? _current;
    bool _loading = false;
    String? _error;
    final String _operation = 'تحويل';
    String? _recipientLast4;
    double? _amount;

    @override
    void initState() {
      super.initState();
      _start();
    }

    Future<void> _start() async {
      setState(() => _loading = true);
      try {
        final simSlot = await StorageService.getSimSlot(widget.service.id);
        final firstResponse = await UssdService.startSession(widget.service.ussdCode, simSlot);
        if (firstResponse != null) {
          setState(() => _current = UssdParser.parse(firstResponse));
        }
      } catch (e) {
        setState(() => _error = e.toString().replaceAll('Exception: ', ''));
      }
      setState(() => _loading = false);
    }

    Future<void> _send(String value) async {
      setState(() => _loading = true);
      try {
        final response = await UssdService.sendReply(value);
        if (response == null) {
          setState(() { _error = 'لم يتم استلام رد من الخدمة'; _loading = false; });
          return;
        }
        final parsed = UssdParser.parse(response);
        if (_current?.type == UssdType.phoneInput && value.length >= 4) {
          _recipientLast4 = value.substring(value.length - 4);
        }
        if (_current?.type == UssdType.amountInput) {
          _amount = double.tryParse(value);
        }
        if (parsed.type == UssdType.success || parsed.type == UssdType.error) {
          final ref = UssdParser.extractReference(response);
          final tx = TransactionRecord(
            id: const Uuid().v4(),
            serviceName: widget.service.name,
            operationType: _operation,
            amount: _amount,
            recipientLastFour: _recipientLast4,
            status: parsed.type == UssdType.success ? 'ناجحة' : 'فاشلة',
            referenceNumber: ref,
            timestamp: DateTime.now(),
          );
          await StorageService.addTransaction(tx);
        }
        setState(() { _current = parsed; _loading = false; _error = null; });
      } catch (e) {
        setState(() { _error = e.toString().replaceAll('Exception: ', ''); _loading = false; });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: Text(widget.service.name), backgroundColor: const Color(0xFF1A5F7A), foregroundColor: Colors.white),
          body: _buildBody(),
        ),
      );
    }

    Widget _buildBody() {
      if (_loading) {
        return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircularProgressIndicator(color: Color(0xFF1A5F7A)),
          SizedBox(height: 16), Text('جارٍ الاتصال بالخدمة...')
        ]));
      }
      if (_error != null) {
        return Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(_error!, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _start, child: const Text('إعادة المحاولة')),
        ])));
      }
      if (_current == null) return const SizedBox();
      switch (_current!.type) {
        case UssdType.menu:
          return MenuGrid(parsed: _current!, onSelect: (code) => _send(code));
        case UssdType.pinInput:
          return InputDialog(parsed: _current!, isPin: true, serviceId: widget.service.id, onSubmit: (pin) => _send(pin));
        case UssdType.phoneInput:
          return InputDialog(parsed: _current!, isPin: false, showContacts: true, onSubmit: (phone) => _send(phone));
        case UssdType.amountInput:
          return AmountDialog(parsed: _current!, onSubmit: (amt) => _send(amt));
        case UssdType.confirm:
          return ConfirmDialog(parsed: _current!, onConfirm: () => _send('1'), onCancel: () => _send('2'));
        case UssdType.success:
          return _resultWidget(true, _current!.message);
        case UssdType.error:
          return _resultWidget(false, _current!.message);
        default:
          return Center(child: Text('رد غير متوقع: ${_current!.message}'));
      }
    }

    Widget _resultWidget(bool success, String msg) {
      return Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(success ? Icons.check_circle : Icons.cancel, size: 80, color: success ? Colors.green : Colors.red),
        const SizedBox(height: 16),
        Text(success ? 'تمت العملية بنجاح' : 'فشلت العملية', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(msg, textAlign: TextAlign.center),
        const SizedBox(height: 32),
        ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('العودة للرئيسية')),
      ])));
    }

    @override
    void dispose() {
      UssdService.endSession();
      super.dispose();
    }
  }
  
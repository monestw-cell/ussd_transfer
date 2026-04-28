import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import '../parsers/ussd_parser.dart';
  import '../services/storage_service.dart';
  import '../services/auth_service.dart';

  class InputDialog extends StatefulWidget {
    final ParsedUssd parsed;
    final bool isPin;
    final bool showContacts;
    final String? serviceId;
    final Function(String) onSubmit;

    const InputDialog({
      super.key,
      required this.parsed,
      required this.isPin,
      this.showContacts = false,
      this.serviceId,
      required this.onSubmit,
    });

    @override
    State<InputDialog> createState() => _InputDialogState();
  }

  class _InputDialogState extends State<InputDialog> {
    final controller = TextEditingController();
    bool obscure = true;

    @override
    void initState() {
      super.initState();
      if (widget.isPin && widget.serviceId != null) _tryFillSavedPin();
    }

    Future<void> _tryFillSavedPin() async {
      final saved = await StorageService.getPin(widget.serviceId!);
      if (saved != null && mounted) controller.text = saved;
    }

    Future<void> _useBiometric() async {
      final auth = await AuthService.authenticateWithBiometrics();
      if (auth && widget.serviceId != null) {
        final pin = await StorageService.getPin(widget.serviceId!);
        if (pin != null && mounted) widget.onSubmit(pin);
      }
    }

    Future<void> _pickContact() async {
      const platform = MethodChannel('flutter/contacts');
      try {
        final String? number = await platform.invokeMethod('pickContact');
        if (number != null && mounted) controller.text = number;
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لم نتمكن من فتح جهات الاتصال')));
      }
    }

    @override
    Widget build(BuildContext context) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Icon(widget.isPin ? Icons.lock : Icons.contact_phone, size: 48, color: const Color(0xFF1A5F7A)),
                const SizedBox(height: 12),
                Text(widget.parsed.message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  obscureText: widget.isPin && obscure,
                  keyboardType: widget.isPin ? TextInputType.number : TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: widget.parsed.hint,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffixIcon: widget.isPin
                        ? IconButton(
                            icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => obscure = !obscure))
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                if (widget.showContacts) ...[
                  OutlinedButton.icon(onPressed: _pickContact, icon: const Icon(Icons.contacts), label: const Text('اختيار من جهات الاتصال')),
                  const SizedBox(height: 8),
                ],
                if (widget.isPin && widget.serviceId != null) ...[
                  OutlinedButton.icon(onPressed: _useBiometric, icon: const Icon(Icons.fingerprint), label: const Text('بصمة')),
                  const SizedBox(height: 8),
                ],
                ElevatedButton(
                  onPressed: () => widget.onSubmit(controller.text.trim()),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A5F7A), foregroundColor: Colors.white),
                  child: const Text('متابعة'),
                ),
              ]),
            ),
          ),
        ),
      );
    }
  }
  
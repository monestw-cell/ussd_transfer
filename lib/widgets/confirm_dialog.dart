import 'package:flutter/material.dart';
  import '../parsers/ussd_parser.dart';

  class ConfirmDialog extends StatelessWidget {
    final ParsedUssd parsed;
    final VoidCallback onConfirm;
    final VoidCallback onCancel;
    const ConfirmDialog({super.key, required this.parsed, required this.onConfirm, required this.onCancel});

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
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.warning_amber, size: 48, color: Colors.orange),
                const SizedBox(height: 12),
                const Text('تأكيد العملية', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(parsed.message, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                Row(children: [
                  Expanded(child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                      child: const Text('إلغاء'))),
                  const SizedBox(width: 16),
                  Expanded(child: ElevatedButton(
                      onPressed: onConfirm,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('تأكيد'))),
                ]),
              ]),
            ),
          ),
        ),
      );
    }
  }
  
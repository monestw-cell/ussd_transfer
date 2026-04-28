import 'package:flutter/material.dart';
  import '../parsers/ussd_parser.dart';

  class AmountDialog extends StatefulWidget {
    final ParsedUssd parsed;
    final Function(String) onSubmit;
    const AmountDialog({super.key, required this.parsed, required this.onSubmit});

    @override
    State<AmountDialog> createState() => _AmountDialogState();
  }

  class _AmountDialogState extends State<AmountDialog> {
    final controller = TextEditingController();
    final quickAmounts = [10, 20, 50, 100];

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
                const Icon(Icons.attach_money, size: 48, color: Color(0xFF1A5F7A)),
                const SizedBox(height: 12),
                Text(widget.parsed.message, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                TextField(controller: controller, keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'المبلغ', border: OutlineInputBorder())),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: quickAmounts
                      .map((a) => OutlinedButton(onPressed: () => controller.text = a.toString(), child: Text('$a شيكل')))
                      .toList(),
                ),
                const SizedBox(height: 16),
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
  
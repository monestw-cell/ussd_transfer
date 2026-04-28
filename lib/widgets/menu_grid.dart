import 'package:flutter/material.dart';
  import '../parsers/ussd_parser.dart';

  class MenuGrid extends StatelessWidget {
    final ParsedUssd parsed;
    final Function(String) onSelect;
    const MenuGrid({super.key, required this.parsed, required this.onSelect});

    static const colors = [Color(0xFF1A5F7A), Color(0xFF2E7D32), Color(0xFFC62828), Color(0xFF6A1B9A), Color(0xFFF57C00)];
    static const icons = [Icons.account_balance, Icons.send, Icons.history, Icons.credit_card, Icons.more_horiz];

    @override
    Widget build(BuildContext context) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF1A5F7A), borderRadius: BorderRadius.circular(12)),
              child: Text(parsed.message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1.2, crossAxisSpacing: 12, mainAxisSpacing: 12),
              itemCount: parsed.menuItems.length,
              itemBuilder: (ctx, i) {
                final item = parsed.menuItems[i];
                return InkWell(
                  onTap: () => onSelect(item.key),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                        color: colors[i % colors.length],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)]),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(icons[i % icons.length], size: 36, color: Colors.white),
                      const SizedBox(height: 8),
                      Text(item.value,
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center),
                    ]),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  }
  
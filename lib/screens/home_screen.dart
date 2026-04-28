import 'package:flutter/material.dart';
  import '../models/service_model.dart';
  import 'ussd_flow_screen.dart';
  import 'history_screen.dart';
  import 'settings_screen.dart';

  class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F6F9),
          appBar: AppBar(
            title: const Text('USSD TRANSFER', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: const Color(0xFF1A5F7A),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: services.map((s) => _ServiceCard(service: s)).toList(),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.history,
                        label: 'سجل العمليات',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.settings,
                        label: 'الإعدادات',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
    }
  }

  class _ServiceCard extends StatelessWidget {
    final TransferService service;
    const _ServiceCard({required this.service});

    @override
    Widget build(BuildContext context) {
      final isDisabled = service.status == ServiceStatus.disabled;
      return GestureDetector(
        onTap: isDisabled
            ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(service.disabledMessage!)))
            : () => Navigator.push(context, MaterialPageRoute(builder: (_) => UssdFlowScreen(service: service))),
        child: Column(
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: isDisabled ? Colors.grey.shade300 : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: isDisabled
                    ? []
                    : [BoxShadow(color: Colors.blueGrey.shade100, blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Center(child: Text(service.icon, style: const TextStyle(fontSize: 42))),
            ),
            const SizedBox(height: 8),
            Text(service.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }
  }

  class _ActionButton extends StatelessWidget {
    final IconData icon;
    final String label;
    final VoidCallback onTap;
    const _ActionButton({required this.icon, required this.label, required this.onTap});

    @override
    Widget build(BuildContext context) {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A5F7A), foregroundColor: Colors.white),
      );
    }
  }
  
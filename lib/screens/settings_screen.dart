import 'package:flutter/material.dart';
  import '../services/storage_service.dart';

  class SettingsScreen extends StatefulWidget {
    const SettingsScreen({super.key});

    @override
    State<SettingsScreen> createState() => _SettingsScreenState();
  }

  class _SettingsScreenState extends State<SettingsScreen> {
    final simController = TextEditingController();
    final pinController = TextEditingController();
    String? selectedService = 'bank_palestine';

    @override
    Widget build(BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text('الإعدادات'), backgroundColor: const Color(0xFF1A5F7A), foregroundColor: Colors.white),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: selectedService,
                  items: const [
                    DropdownMenuItem(value: 'bank_palestine', child: Text('بنك فلسطين')),
                    DropdownMenuItem(value: 'jawwal_pay', child: Text('جوال باي')),
                  ],
                  onChanged: (v) => setState(() => selectedService = v),
                  decoration: const InputDecoration(labelText: 'الخدمة'),
                ),
                const SizedBox(height: 16),
                TextField(controller: simController, keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'رقم الشريحة (0 أو 1)')),
                const SizedBox(height: 16),
                TextField(controller: pinController, obscureText: true,
                    decoration: const InputDecoration(labelText: 'الرقم السري (اختياري للحفظ)')),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedService != null) {
                      await StorageService.saveSimSlot(selectedService!, int.tryParse(simController.text) ?? 0);
                      if (pinController.text.isNotEmpty) await StorageService.savePin(selectedService!, pinController.text);
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحفظ')));
                    }
                  },
                  child: const Text('حفظ الإعدادات'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
  
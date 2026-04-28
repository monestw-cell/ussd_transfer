import 'package:flutter/material.dart';
  import '../services/storage_service.dart';
  import '../models/transaction_model.dart';

  class HistoryScreen extends StatefulWidget {
    const HistoryScreen({super.key});

    @override
    State<HistoryScreen> createState() => _HistoryScreenState();
  }

  class _HistoryScreenState extends State<HistoryScreen> {
    List<TransactionRecord> records = [];
    bool loading = true;

    @override
    void initState() {
      super.initState();
      _load();
    }

    Future<void> _load() async {
      final list = await StorageService.getTransactions();
      setState(() { records = list; loading = false; });
    }

    Future<void> _clear() async {
      await StorageService.clearTransactions();
      _load();
    }

    @override
    Widget build(BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text('سجل العمليات'), backgroundColor: const Color(0xFF1A5F7A), foregroundColor: Colors.white),
          body: loading
              ? const Center(child: CircularProgressIndicator())
              : records.isEmpty
                  ? const Center(child: Text('لا توجد عمليات مسجلة'))
                  : ListView.builder(
                      itemCount: records.length,
                      itemBuilder: (ctx, i) => ListTile(
                        leading: Icon(records[i].status == 'ناجحة' ? Icons.check_circle : Icons.cancel,
                            color: records[i].status == 'ناجحة' ? Colors.green : Colors.red),
                        title: Text('${records[i].serviceName} - ${records[i].operationType}'),
                        subtitle: Text('${records[i].amount != null ? "${records[i].amount} شيكل " : ""}${records[i].recipientLastFour != null ? "لـ ....${records[i].recipientLastFour}" : ""}'),
                        trailing: Text(records[i].timestamp.toLocal().toString().substring(0, 16)),
                      ),
                    ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _clear, icon: const Icon(Icons.delete), label: const Text('مسح الكل')),
        ),
      );
    }
  }
  
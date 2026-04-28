class TransactionRecord {
    final String id;
    final String serviceName;
    final String operationType;
    final double? amount;
    final String? recipientLastFour;
    final String status;
    final String? referenceNumber;
    final DateTime timestamp;

    TransactionRecord({
      required this.id,
      required this.serviceName,
      required this.operationType,
      this.amount,
      this.recipientLastFour,
      required this.status,
      this.referenceNumber,
      required this.timestamp,
    });

    Map<String, dynamic> toMap() => {
          'id': id,
          'serviceName': serviceName,
          'operationType': operationType,
          'amount': amount,
          'recipientLastFour': recipientLastFour,
          'status': status,
          'referenceNumber': referenceNumber,
          'timestamp': timestamp.toIso8601String(),
        };

    factory TransactionRecord.fromMap(Map<String, dynamic> map) {
      return TransactionRecord(
        id: map['id'],
        serviceName: map['serviceName'],
        operationType: map['operationType'],
        amount: map['amount']?.toDouble(),
        recipientLastFour: map['recipientLastFour'],
        status: map['status'],
        referenceNumber: map['referenceNumber'],
        timestamp: DateTime.parse(map['timestamp']),
      );
    }
  }
  
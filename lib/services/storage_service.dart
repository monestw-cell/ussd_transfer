import 'package:flutter_secure_storage/flutter_secure_storage.dart';
  import 'package:sqflite/sqflite.dart';
  import 'package:path/path.dart';
  import '../models/transaction_model.dart';

  class StorageService {
    static const _storage = FlutterSecureStorage();
    static Database? _db;

    static Future<void> savePin(String serviceId, String pin) async {
      await _storage.write(key: 'pin_$serviceId', value: pin);
    }

    static Future<String?> getPin(String serviceId) async {
      return await _storage.read(key: 'pin_$serviceId');
    }

    static Future<void> deletePin(String serviceId) async {
      await _storage.delete(key: 'pin_$serviceId');
    }

    static Future<void> saveSimSlot(String serviceId, int slot) async {
      await _storage.write(key: 'sim_$serviceId', value: slot.toString());
    }

    static Future<int> getSimSlot(String serviceId) async {
      final val = await _storage.read(key: 'sim_$serviceId');
      return int.tryParse(val ?? '0') ?? 0;
    }

    static Future<Database> get database async {
      _db ??= await _initDb();
      return _db!;
    }

    static Future<Database> _initDb() async {
      final path = join(await getDatabasesPath(), 'ussd_transfer.db');
      return openDatabase(path, version: 1, onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions (
            id TEXT PRIMARY KEY,
            serviceName TEXT,
            operationType TEXT,
            amount REAL,
            recipientLastFour TEXT,
            status TEXT,
            referenceNumber TEXT,
            timestamp TEXT
          )
        ''');
      });
    }

    static Future<void> addTransaction(TransactionRecord record) async {
      final db = await database;
      await db.insert('transactions', record.toMap());
      await db.delete('transactions',
          where: 'id NOT IN (SELECT id FROM transactions ORDER BY timestamp DESC LIMIT 50)');
    }

    static Future<List<TransactionRecord>> getTransactions() async {
      final db = await database;
      final List<Map<String, dynamic>> maps =
          await db.query('transactions', orderBy: 'timestamp DESC');
      return maps.map((m) => TransactionRecord.fromMap(m)).toList();
    }

    static Future<void> clearTransactions() async {
      final db = await database;
      await db.delete('transactions');
    }
  }
  
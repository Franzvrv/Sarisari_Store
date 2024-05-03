import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Debt {
  final int? id;
  final String label;
  final double price;

  Debt({
    this.id,
    required this.label,
    required this.price,
  });

  factory Debt.fromMap(Map<String, dynamic> json) {
    return new Debt(
      id: json['id'],
      label: json['label'].toString(),
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'price': price,
    };
  }
}

class DebtDatabase {
  DebtDatabase._privateConstructor();
  static final DebtDatabase instance = DebtDatabase._privateConstructor();

  static Database ? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'debts.db');
    print('db location : '+path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE debts(
      id INTEGER PRIMARY KEY,
      label STRING,
      price REAL);
      '''
    );
  }

  Future<List<Debt>> getDebts() async {
    Database db = await instance.database;
    var debts = await db.query('debts', orderBy: 'label');
    List<Debt> debtList = debts.isNotEmpty ? debts.map((p) => Debt.fromMap(p)).toList()
        : [];
    return debtList;
  }

  Future<int> add(Debt debt) async {
    Database db = await instance.database;
    return await db.insert('debts', debt.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('debts', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Debt debt) async {
    Database db = await instance.database;
    return await db.update('debts', debt.toMap(), where: 'id = ?', whereArgs: [debt.id]);
  }
}

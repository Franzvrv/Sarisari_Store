import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Transaction {
  final int? id;
  final String dateTime;
  final double total;

  Transaction({
    this.id,
    required this.dateTime,
    required this.total,
  });

factory Transaction.fromMap(Map<String, dynamic> json) => new Transaction(
    id: json['id'],
    dateTime: json['dateTime'].toString(),
    total: json['price'].toDouble(),
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime,
      'price': total,
    };
  }
}

class TransactionDatabase {
  TransactionDatabase._privateConstructor();
  static final TransactionDatabase instance = TransactionDatabase._privateConstructor();

  static Database ? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'transactions.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE transactions(
      id INTEGER PRIMARY KEY,
      dateTime STRING,
      price REAL);
      '''
    );
  }

  Future<List<Transaction>> getTransactions() async {
    Database db = await instance.database;
    var transactions = await db.query('transactions', orderBy: 'dateTime');
    List<Transaction> transactionList = transactions.isNotEmpty ? transactions.map((p) => Transaction.fromMap(p)).toList()
        : [];
    return transactionList;
  }

  Future<int> add(Transaction transaction) async {
    print(transaction.dateTime);
    Database db = await instance.database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<int> removeAll() async {
    Database db = await instance.database;
    return await db.delete('transactions');
  }

  Future<int> update(Transaction transaction) async {
    Database db = await instance.database;
    return await db.update('transactions', transaction.toMap(), where: 'id = ?', whereArgs: [transaction.id]);
  }
}

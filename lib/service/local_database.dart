import 'dart:convert';
import 'dart:math';

import 'package:openfoodfacts/model/Product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/ticket_model.dart';

class LocalDatabases {
  Future<Database> databaseTickets() async {
    return openDatabase(join(await getDatabasesPath(), 'tickets.db'),
        onCreate: (db, version) {
      print(version);
      return db.execute('''
          CREATE TABLE tickets(
            id INTEGER PRIMARY KEY, ticketId TEXT, supermercado TEXT, localidad TEXT, fecha TEXT, sexo INTEGER, numeroProductos INTEGER, edad INTEGER, productos TEXT)
        ''');
    }, onDowngrade: onDatabaseDowngradeDelete, version: 1);
  }

  Future<dynamic> alterTable(String TableName, String ColumneName) async {
    var db = await databaseTickets();
    var count = await db.execute("ALTER TABLE $TableName ADD "
        "COLUMN $ColumneName TEXT;");
    return count;
  }

  Future<void> insertTicket(Ticket ticket) async {
    final Database db = await databaseTickets();
    Map<String, Object?> value = {'id': Random().nextInt(200000000)};

    value.addAll(ticket.toJson());

    await db.insert(
      'tickets',
      value,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Ticket>> tickets() async {
    final Database db = await databaseTickets();

    final List<Map<String, dynamic>> maps = await db.query('tickets');

    // Convierte List<Map<String, dynamic> en List<Ticket>.
    return List.generate(maps.length, (i) {
      return Ticket(
          ticketId: maps[i]['ticketId'],
          supermercado: maps[i]['supermercado'],
          localidad: maps[i]['localidad'],
          fecha: maps[i]['fecha'],
          productos: (jsonDecode(maps[i]['productos']) as List<dynamic>)
              .map<Product>((e) => Product.fromJson(e))
              .toList());
    });
  }
}

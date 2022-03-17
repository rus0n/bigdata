import 'dart:convert';

import 'package:openfoodfacts/model/Product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/ticket_model.dart';

class LocalDatabases {
  Future<Database> databaseTickets() async {
    return openDatabase(join(await getDatabasesPath(), 'tickets.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE tickets(idticket TEXT PRIMARY KEY,supermercado TEXT, localidad TEXT, fecha TEXT, productos TEXT)');
    }, version: 1);
  }

  Future<void> insertTicket(Ticket ticket) async {
    final Database db = await databaseTickets();

    await db.insert(
      'tickets',
      ticket.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Ticket>> tickets() async {
    final Database db = await databaseTickets();

    final List<Map<String, dynamic>> maps = await db.query('tickets');

    // Convierte List<Map<String, dynamic> en List<Dog>.
    return List.generate(maps.length, (i) {
      return Ticket(
          ticketId: maps[i]['idticket'],
          supermercado: maps[i]['supermercado'],
          localidad: maps[i]['localidad'],
          fecha: maps[i]['fecha'],
          productos: (jsonDecode(maps[i]['productos']) as List<dynamic>)
              .map<Product>((e) => Product.fromJson(e))
              .toList());
    });
  }
}

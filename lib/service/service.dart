import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Databases {
  Future<Database> databaseTickets() async {
    return openDatabase(join(await getDatabasesPath(), 'tickets.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE tickets(idticket TEXT PRIMARY KEY,supermercado TEXT, localidad TEXT, fecha TEXT, productos TEXT)');
    }, version: 1);
  }
}

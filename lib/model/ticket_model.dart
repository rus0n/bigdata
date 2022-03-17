import 'dart:convert';

import 'package:bigdata/service/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

class Ticket {
  String ticketId;
  String supermercado;
  String localidad;
  String fecha;
  List<Product> productos;

  Ticket({
    required this.ticketId,
    required this.supermercado,
    required this.localidad,
    required this.fecha,
    required this.productos,
  });

  factory Ticket.fromFireStore(DocumentSnapshot doc) {
    return Ticket(
      ticketId: doc.id,
      supermercado: doc.get('supermercado'),
      localidad: doc.get('localidad'),
      fecha: doc.get('fecha'),
      productos: jsonDecode(doc.get('productos')),
    );
  }

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
        ticketId: json['ticektId'],
        supermercado: json['supermercado'],
        localidad: json['localidad'],
        fecha: json['fecha'],
        productos: jsonDecode(json['productos']));
  }

  Map<String, dynamic> toJson() => {
        "ticketId": ticketId,
        "supermercado": supermercado,
        "localidad": localidad,
        "fecha": fecha,
        "productos": jsonEncode(productos),
      };

  Future<void> insertTicket(Ticket ticket) async {
    final Database db = await Databases().databaseTickets();

    await db.insert('tickets', ticket.toJson());
  }
}

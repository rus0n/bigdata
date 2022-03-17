import 'dart:convert';

import 'package:bigdata/service/local_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

class Ticket {
  String ticketId;
  String supermercado;
  String localidad;
  String fecha;
  List<dynamic> productos;

  Ticket({
    required this.ticketId,
    required this.supermercado,
    required this.localidad,
    required this.fecha,
    required this.productos,
  });

  factory Ticket.fromFireStore(DocumentSnapshot doc) {
    List<dynamic> dyna = jsonDecode(doc.get('productos'));
    return Ticket(
      ticketId: doc.id,
      supermercado: doc.get('supermercado'),
      localidad: doc.get('localidad'),
      fecha: doc.get('fecha'),
      productos: dyna.map<Product>((e) => Product.fromJson(e)).toList(),
    );
  }

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
        ticketId: json['ticektId'],
        supermercado: json['supermercado'],
        localidad: json['localidad'],
        fecha: json['fecha'],
        productos: (jsonDecode(json['productos']) as List<dynamic>)
            .map<Product>((e) => Product.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toJson() => {
        "ticketId": ticketId,
        "supermercado": supermercado,
        "localidad": localidad,
        "fecha": fecha,
        "productos": jsonEncode(productos),
      };
}

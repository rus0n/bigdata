import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:openfoodfacts/model/Product.dart';

class Ticket {
  String ticketId;
  String supermercado;
  String localidad;
  String fecha;
  int? numeroProductos;
  List<Product> productos;
  int? sexo = 0;
  int? edad = 30;

  Ticket(
      {required this.ticketId,
      required this.supermercado,
      required this.localidad,
      required this.fecha,
      required this.productos,
      this.numeroProductos,
      this.edad,
      this.sexo});

  factory Ticket.fromFireStore(DocumentSnapshot doc) {
    List<dynamic> dyna = jsonDecode(doc.get('productos'));
    return Ticket(
      ticketId: doc.id,
      supermercado: doc.get('supermercado'),
      localidad: doc.get('localidad'),
      fecha: doc.get('fecha'),
      numeroProductos: doc.get('numeroProductos'),
      productos: dyna.map<Product>((e) => Product.fromJson(e)).toList(),
    );
  }

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
        ticketId: json['ticektId'],
        supermercado: json['supermercado'],
        localidad: json['localidad'],
        numeroProductos: json['numeroProductos'],
        fecha: json['fecha'],
        productos: (jsonDecode(json['productos']) as List<dynamic>)
            .map<Product>((e) => Product.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toJson() => {
        "ticketId": ticketId,
        "supermercado": supermercado,
        "localidad": localidad,
        "fecha": fecha.substring(0, 10),
        "sexo": sexo ?? 1,
        'numeroProductos': numeroProductos,
        "edad": edad ?? 30,
        "productos": jsonEncode(productos),
      };
}

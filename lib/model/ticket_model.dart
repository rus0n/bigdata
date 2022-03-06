import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  String supermercado;
  String localidad;
  String fecha;
  List<Map<String, int>> productos;
  String precioTotal;

  Ticket(
      {required this.supermercado,
      required this.localidad,
      required this.fecha,
      required this.productos,
      required this.precioTotal});

  factory Ticket.fromFireStore(DocumentSnapshot doc) {
    return Ticket(
        supermercado: doc.get('supermercado'),
        localidad: doc.get('localidad'),
        fecha: doc.get('fecha'),
        productos: doc.get('productos'),
        precioTotal: doc.get('precioTotal'));
  }

  Map<String, dynamic> toJson() => {
        "supermercado": supermercado,
        "localidad": localidad,
        "fecha": fecha,
        "productos": productos,
        "precioTotal": precioTotal
      };
}

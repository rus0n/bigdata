class Ticket {
  String? supermercado;
  String? localidad;
  String? fecha;
  List<Map<String, int>>? productos;
  String? precioTotal;

  Ticket(
      {this.supermercado,
      this.localidad,
      this.fecha,
      this.productos,
      this.precioTotal});

  Map<String, dynamic> toJson() => {
        "supermercado": supermercado,
        "localidad": localidad,
        "fecha": fecha,
        "productos": productos,
        "precioTotal": precioTotal
      };
}

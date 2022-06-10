import 'dart:math';

import 'package:bigdata/service/datos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:uuid/uuid.dart';

import 'model/ticket_model.dart';

class Generar extends StatefulWidget {
  const Generar({Key? key}) : super(key: key);

  @override
  State<Generar> createState() => _GenerarState();
}

class _GenerarState extends State<Generar> {
  TextEditingController numero = TextEditingController();
  double sexo = 50;
  RangeValues edad = RangeValues(20, 50);
  RangeValues productos = RangeValues(5, 30);

  int progreso = 0;

  int sexoTicket() {
    int random = Random().nextInt(100);
    if (random < sexo) {
      return 0;
    }
    return 1;
  }

  String localidad() {
    int localidadRandom = Random().nextInt(8);
    String localidad;

    switch (localidadRandom) {
      case 1:
        localidad = 'Fene';
        break;
      case 2:
        localidad = 'Naron';
        break;
      case 3:
        localidad = 'Neda';
        break;
      default:
        localidad = 'Ferrol';
    }
    return localidad;
  }

  String supermercado() {
    int localidadRandom = Random().nextInt(5);
    String localidad;

    switch (localidadRandom) {
      case 1:
        localidad = 'Alcampo';
        break;
      case 2:
        localidad = 'Lidl';
        break;
      case 3:
        localidad = 'Gadis';
        break;
      case 4:
        localidad = 'Mercadona';
        break;
      default:
        localidad = 'Froiz';
    }
    return localidad;
  }

  Future<void> generarTicket() async {
    List<Product> productosTicket = [];

    for (var i = 0; i < int.parse(numero.text); i++) {
      int productosLongitud = Random().nextInt(productos.end.toInt());

      print('longitud: ' + productosLongitud.toString());

      for (var i = 0; i < productosLongitud; i++) {
        int barcodeRandom = Random().nextInt(12);

        String barcode = Datos().barcodes.elementAt(barcodeRandom);
        print(barcode);

        var productResult = await OpenFoodAPIClient.getProduct(
            ProductQueryConfiguration(barcode));

        productosTicket.add(productResult.product!);
      }
      int edadTicket = Random().nextInt(edad.end.toInt()) + 5;

      var uuid = const Uuid();

      String id = uuid.v1();

      var _ticket = Ticket(
          ticketId: id,
          supermercado: supermercado(),
          localidad: localidad(),
          numeroProductos: productosLongitud,
          fecha: DateTime.now().toString().substring(0, 10),
          edad: edadTicket,
          sexo: sexoTicket(),
          productos: productosTicket);

      print('productos lengh' + productosTicket.length.toString());
      await FirebaseFirestore.instance
          .collection('tickets')
          .doc(id)
          .set(_ticket.toJson())
          .timeout(Duration(seconds: 4));

      productosTicket.clear();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar usuario'),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: numero,
            decoration: const InputDecoration(
                labelText: 'Numero de tickets', hintText: 'Introduce numero'),
            keyboardType: const TextInputType.numberWithOptions(),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Porcentaje de hombres'),
        ),
        Slider(
            value: sexo,
            min: 10,
            max: 90,
            divisions: 10,
            label: sexo.toInt().toString(),
            onChanged: (newValue) {
              setState(() {
                sexo = newValue;
              });
            }),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Franga de Edad'),
        ),
        RangeSlider(
            min: 10,
            max: 90,
            divisions: 40,
            labels: RangeLabels(
                edad.start.toInt().toString(), edad.end.toInt().toString()),
            values: edad,
            onChanged: (newValue) {
              setState(() {
                edad = newValue;
              });
            }),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Numero de productos'),
        ),
        RangeSlider(
            min: 2,
            max: 40,
            divisions: 122,
            labels: RangeLabels(productos.start.toInt().toString(),
                productos.end.toInt().toString()),
            values: productos,
            onChanged: (newValue) {
              setState(() {
                productos = newValue;
              });
            }),
        const Spacer(),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) => const SimpleDialog(
                            title: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                            ),
                          ),
                      barrierDismissible: false);
                  generarTicket();
                },
                child: const Text('Generar'))
          ],
        )
      ]),
    );
  }
}

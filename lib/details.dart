import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'package:path_provider/path_provider.dart';

import 'model/ticket_model.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.ticket}) : super(key: key);

  final Ticket ticket;
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del ticket'),
      ),
      body: Column(
        children: [
          Container(
              color: Colors.purpleAccent,
              height: 40,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.ticket.supermercado,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              )),
          Expanded(
            child: ListView.builder(
                itemCount: widget.ticket.productos.length,
                itemBuilder: (context, index) {
                  Product _producto = widget.ticket.productos[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Row(
                        children: [
                          Flexible(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _producto.imageFrontUrl == null
                                ? Container()
                                : Image.network(
                                    _producto.imageFrontUrl!,
                                    fit: BoxFit.fitWidth,
                                  ),
                          )),
                          Flexible(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          _producto.productName!,
                                          softWrap: false,
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(_producto.barcode!)
                                    ],
                                  ),
                                ),
                                SvgPicture.network(
                                  'https://static.openfoodfacts.org/images/attributes/nutriscore-${_producto.ecoscoreGrade}.svg',
                                  semanticsLabel: 'A shark?!',
                                  height: 40,
                                  placeholderBuilder: (BuildContext context) =>
                                      Container(
                                          padding: const EdgeInsets.all(20.0),
                                          child:
                                              const CircularProgressIndicator()),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

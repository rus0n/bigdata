import 'dart:convert';
import 'dart:math';

import 'package:bigdata/model/ticket_model.dart';
import 'package:bigdata/service/datos.dart';
import 'package:bigdata/service/local_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:openfoodfacts/model/parameter/TagFilter.dart';

import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:openfoodfacts/utils/CountryHelper.dart';
import 'package:openfoodfacts/utils/TagType.dart';
import 'package:uuid/uuid.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  List<Product> productos = [];

  String? supermercado;

  bool persistenciaLocal = false;

  Map<int, bool> opcionesDatabase = {0: true, 1: false};

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Añadir ticket'),
          actions: [
            IconButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Product? producto = await showSearch<Product?>(
                        context: context,
                        delegate: Search(supermercado: supermercado!));
                    setState(() {});
                    if (producto != null) {
                      setState(() {
                        productos.add(producto);
                      });
                    }
                  }
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.local_mall),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) =>
                        value == null ? 'Campo requerido' : null,
                    hint: const Text('Selecciona Supermercado'),
                    items: List.generate(
                        Datos().supermercados.length,
                        (index) => DropdownMenuItem(
                            value: Datos().supermercados.elementAt(index),
                            child:
                                Text(Datos().supermercados.elementAt(index)))),
                    value: supermercado,
                    onChanged: (value) async {
                      setState(() {
                        supermercado = value!;
                      });
                    }),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                      color: Colors.purple[100],
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8)),
                  child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: productos.isEmpty ? 1 : productos.length,
                      itemBuilder: (context, index) {
                        if (productos.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'No hay Productos añadidos',
                              ),
                            ),
                          );
                        }
                        Product producto = productos.elementAt(index);

                        return Dismissible(
                          key: Key(producto.barcode!),
                          onDismissed: (direction) {
                            setState(() {
                              productos.removeAt(index);
                            });

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('${producto.productName} eliminado')));
                          },
                          background: Container(
                            color: Colors.red,
                          ),
                          child: ListTile(
                              leading: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child:
                                    Image.network(producto.imageFrontSmallUrl!),
                              ),
                              title: Text(producto.productName!),
                              trailing: SvgPicture.network(
                                'https://static.openfoodfacts.org/images/attributes/nutriscore-${producto.ecoscoreGrade}.svg',
                                width: 70,
                                placeholderBuilder: (BuildContext context) =>
                                    Container(
                                        padding: const EdgeInsets.all(30.0),
                                        child:
                                            const CircularProgressIndicator()),
                              )),
                        );
                      }),
                ),
              ),
              Column(
                children: List.generate(
                    opcionesDatabase.length,
                    (index) => CheckboxListTile(
                        title: Text(index == 0
                            ? 'Subir a la base de datos remota'
                            : 'Guardar de manera local'),
                        subtitle: Text(index == 0
                            ? 'Guarda los datos en los servidores, hace falta conexion a internet'
                            : 'Se escribiran los datos en el almacenamiento del dispositivo sin necesidad de conexion'),
                        value: opcionesDatabase.values.elementAt(index),
                        onChanged: (db) {
                          setState(() {
                            opcionesDatabase[index] = db!;
                          });
                        })),
              ),
              ButtonBar(
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
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
                        var uuid = Uuid();

                        String id = uuid.v1();

                        Ticket _ticket = Ticket(
                            ticketId: id,
                            supermercado: supermercado!,
                            localidad: localidad,
                            fecha: DateTime.now().toString(),
                            productos: productos);
                        if (opcionesDatabase[0]!) {
                          FirebaseFirestore.instance
                              .collection('tickets')
                              .doc(id)
                              .set(_ticket.toJson());
                          Navigator.pop(context);
                        }

                        if (opcionesDatabase[1]!) {
                          LocalDatabases().insertTicket(_ticket);
                          Navigator.pop(context);
                        }

                        if (!opcionesDatabase[0]! && !opcionesDatabase[1]!) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'No has seleccinoado ninguna base de datos')));
                        }
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Añadir ticket')),
                  ElevatedButton.icon(
                      onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 400,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView(
                                          children: List.generate(
                                              productos.length,
                                              (index) => Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(productos
                                                        .elementAt(index)
                                                        .toJson()
                                                        .toString()),
                                                  ))),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                      icon: const Icon(Icons.javascript_outlined),
                      label: const Text('Ver json'))
                ],
              ),
            ],
          ),
        ));
  }
}

class Search extends SearchDelegate<Product?> {
  Search({Key? key, required this.supermercado}) : super();

  final String supermercado;

  @override
  String get searchFieldLabel => 'Buscar';
  final User _user =
      const User(userId: 'devinfojob@gmail.com', password: 'F37nKeFasRULadf');

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    if (query.isNotEmpty) {
      return [
        IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
      ];
    }
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final parameters = <Parameter>[
      const PageSize(size: 25),
      const SortBy(option: SortOption.POPULARITY),
      TagFilter.fromType(
          tagFilterType: TagFilterType.LANGUAGES, tagName: 'Spanish'),
      TagFilter.fromType(
          tagFilterType: TagFilterType.BRANDS, tagName: supermercado),
      TagFilter.fromType(
          tagFilterType: TagFilterType.CATEGORIES, tagName: query),
    ];

    final ProductSearchQueryConfiguration _configuration =
        ProductSearchQueryConfiguration(
      parametersList: parameters,
      language: OpenFoodFactsLanguage.SPANISH,
      country: OpenFoodFactsCountry.SPAIN,
    );

    return FutureBuilder<SearchResult>(
      future: OpenFoodAPIClient.searchProducts(_user, _configuration),
      builder: (context, result) {
        if (result.connectionState == ConnectionState.done) {
          if (result.hasData) {
            List<Product>? productos = result.data!.products;

            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 0.7),
                itemCount: productos!.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  Product _producto = productos.elementAt(index);

                  return GestureDetector(
                    onTap: () => close(context, _producto),
                    child: Card(
                      child: Column(
                        children: [
                          _producto.imageFrontSmallUrl != null
                              ? Image.network(
                                  _producto.imageFrontSmallUrl!,
                                  errorBuilder: ((context, error, stackTrace) =>
                                      const Icon(Icons.no_photography)),
                                  height: 60,
                                  fit: BoxFit.contain,
                                )
                              : const Icon(Icons.no_photography),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                height: 35,
                                child: Text(
                                  _producto.productName!,
                                  overflow: TextOverflow.fade,
                                  softWrap: true,
                                )),
                          ),
                          const Divider(),
                          SvgPicture.network(
                            'https://static.openfoodfacts.org/images/attributes/nutriscore-${_producto.ecoscoreGrade}.svg',
                            semanticsLabel: 'A shark?!',
                            height: 40,
                            placeholderBuilder: (BuildContext context) =>
                                Container(
                                    padding: const EdgeInsets.all(20.0),
                                    child: const CircularProgressIndicator()),
                          )
                        ],
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: Text('No hay productos'),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      return FutureBuilder<List<dynamic>>(
        future: OpenFoodAPIClient.getAutocompletedSuggestions(
          TagType.CATEGORIES,
          input: query,
          language: OpenFoodFactsLanguage.SPANISH,
        ),
        builder: (context, list) {
          if (list.connectionState == ConnectionState.done) {
            if (list.hasData) {
              return ListView.builder(
                  itemCount: list.data!.length,
                  itemBuilder: (context, index) {
                    String item = list.data!.elementAt(index).toString();

                    return ListTile(
                        title: Text(item),
                        onTap: () {
                          query = item;
                          showResults(context);
                        });
                  });
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }
    return Container();
  }
}

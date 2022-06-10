import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:bigdata/add.dart';
import 'package:bigdata/analiticas.dart';
import 'package:bigdata/details.dart';
import 'package:bigdata/generar.dart';
import 'package:bigdata/service/local_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'model/ticket_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Ticket> tickets = [];

  bool localData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Big Data Project'),
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SwitchListTile(
                    title: const Text(
                      'Cambiar a base de datos local',
                      style: TextStyle(color: Colors.white),
                    ),
                    activeColor: Colors.white,
                    activeTrackColor: Colors.green,
                    value: localData,
                    onChanged: (value) => setState(() {
                          localData = value;
                        })),
              )),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const Analiticas()),
                    ),
                child: const Text(
                  'Analiticas',
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
                onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Generar()),
                    ),
                child: const Text(
                  'Generar',
                  style: TextStyle(color: Colors.white),
                )),
            IconButton(
              icon: const Icon(Icons.javascript),
              iconSize: 30,
              onPressed: () => showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  backgroundColor: Colors.white,
                  builder: (context) {
                    return Column(
                      children: [
                        Expanded(
                          child: SizedBox(
                              height: 400,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(jsonEncode(tickets)),
                                  )
                                ]),
                              )),
                        ),
                      ],
                    );
                  }),
            )
          ]),
      body: Column(
        children: [
          localData
              ? Expanded(
                  child: FutureBuilder<List<Ticket>>(
                      future: LocalDatabases().tickets(),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          if (snap.data!.isEmpty) {
                            return const Center(
                              child: Text('No hay tickets disponibles'),
                            );
                          }
                          return ListView.builder(
                              itemCount: snap.data!.length,
                              itemBuilder: (context, index) {
                                Ticket _ticket = snap.data![index];

                                tickets.add(_ticket);

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: OpenContainer(
                                      closedBuilder: (context, action) {
                                        return ListTile(
                                          title: Text(_ticket.supermercado +
                                              ' | ' +
                                              _ticket.localidad),
                                          subtitle: Text(_ticket.fecha),
                                          trailing: Text(
                                              '${_ticket.productos.length} producto/s'),
                                        );
                                      },
                                      openElevation: 1,
                                      closedShape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: const BorderSide(
                                              color: Colors.white, width: 1)),
                                      transitionDuration:
                                          const Duration(seconds: 1),
                                      openBuilder: (context, action) =>
                                          DetailScreen(
                                            ticket: _ticket,
                                          )),
                                );
                              });
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                )
              : Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('tickets')
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Ticket _ticket = Ticket.fromFireStore(
                                    snapshot.data!.docs[index]);

                                tickets.add(_ticket);

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Dismissible(
                                    key: Key(_ticket.ticketId),
                                    onDismissed: (direction) {
                                      FirebaseFirestore.instance
                                          .collection('tickets')
                                          .doc(_ticket.ticketId)
                                          .delete();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Ticket Eliminado')));
                                    },
                                    background: Container(
                                      color: Colors.red,
                                      child: const Icon(Icons.delete),
                                    ),
                                    child: OpenContainer(
                                        closedBuilder: (context, action) {
                                          return ListTile(
                                            title: Text(_ticket.supermercado +
                                                ' | ' +
                                                _ticket.localidad),
                                            subtitle: Text(_ticket.fecha),
                                            trailing: Text(
                                                '${_ticket.numeroProductos} producto/s'),
                                          );
                                        },
                                        openElevation: 1,
                                        closedShape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: const BorderSide(
                                                color: Colors.white, width: 1)),
                                        transitionDuration:
                                            const Duration(seconds: 1),
                                        openBuilder: (context, action) =>
                                            DetailScreen(
                                              ticket: _ticket,
                                            )),
                                  ),
                                );
                              });
                        } else {
                          return const Center(
                            child: Text('No hay tickets disponibles'),
                          );
                        }
                      } else {
                        return const Center(
                            child: SizedBox(
                          height: 80,
                          width: 80,
                          child: CircularProgressIndicator(),
                        ));
                      }
                    },
                  ),
                )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Add())),
          label: const Text('Ticket'),
          icon: const Icon(Icons.add)),
    );
  }
}

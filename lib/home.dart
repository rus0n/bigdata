import 'dart:convert';

import 'package:bigdata/add.dart';
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
                      }))),
          actions: [
            IconButton(
              icon: const Icon(Icons.javascript),
              iconSize: 30,
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      children: [
                        Expanded(
                          child: SizedBox(
                              height: 400,
                              child: ListView(
                                  children: [Text(jsonEncode(tickets))])),
                        ),
                      ],
                    );
                  }),
            )
          ]),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('tickets').snapshots(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Ticket _ticket =
                              Ticket.fromFireStore(snapshot.data!.docs[index]);

                          return ListTile(
                            title: Text(_ticket.supermercado +
                                ' | ' +
                                _ticket.localidad),
                            subtitle: Text(_ticket.fecha),
                            trailing:
                                Text('${_ticket.productos.length} producto/s'),
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
              context, MaterialPageRoute(builder: (context) => Add())),
          label: const Text('Ticket'),
          icon: const Icon(Icons.add)),
    );
  }
}

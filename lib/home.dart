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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Big Data Project'),
      ),
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
                          return Card(
                            child: Column(
                              children: [
                                Center(child: Text(_ticket.supermercado))
                              ],
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
              context, MaterialPageRoute(builder: (context) => Add())),
          label: const Text('Ticket'),
          icon: const Icon(Icons.add)),
    );
  }
}

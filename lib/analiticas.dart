import 'dart:math';

import 'package:bigdata/service/datos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Analiticas extends StatefulWidget {
  const Analiticas({Key? key}) : super(key: key);

  @override
  State<Analiticas> createState() => _AnaliticasState();
}

class _AnaliticasState extends State<Analiticas> {
  Future<List<PieChartSectionData>> showingSectionsLocalidad() async {
    List<int> localidadCantidad = [0, 0, 0, 0];
    int total = 0;
    for (var i = 0; i < Datos().localidad.length; i++) {
      await FirebaseFirestore.instance
          .collection('tickets')
          .where('localidad', isEqualTo: Datos().localidad.elementAt(i))
          .limit(50)
          .get()
          .then((value) {
        total = value.docs.length + total;
        localidadCantidad[i] = value.docs.length;
      });
    }

    return List.generate(Datos().localidad.length, (i) {
      final fontSize = 16.0;
      final radius = 60.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: localidadCantidad.elementAt(i) / total,
            title: Datos().localidad.elementAt(i),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: localidadCantidad.elementAt(i) / total,
            title: Datos().localidad.elementAt(i),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: localidadCantidad.elementAt(i) / total,
            title: Datos().localidad.elementAt(i),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: localidadCantidad.elementAt(i) / total,
            title: Datos().localidad.elementAt(i),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return PieChartSectionData(
            color: Color.fromARGB(255, 157, 19, 211),
            value: localidadCantidad.elementAt(i) / total,
            title: Datos().localidad.elementAt(i),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
      }
    });
  }

  Future<List<PieChartSectionData>> showingSectionsSupermercados() async {
    List<int> localidadCantidad = [];
    int total = 0;
    for (var i = 0; i < Datos().supermercados.length; i++) {
      await FirebaseFirestore.instance
          .collection('tickets')
          .where('supermercado', isEqualTo: Datos().supermercados.elementAt(i))
          .limit(20)
          .get()
          .then((value) {
        total = value.docs.length + total;
        localidadCantidad.add(value.docs.length);
      });
    }

    return List.generate(Datos().supermercados.length, (i) {
      final fontSize = 16.0;
      final radius = 60.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: localidadCantidad.elementAt(i) / total,
            title: Datos().supermercados.elementAt(i),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: localidadCantidad.elementAt(i) / total,
            title: Datos().supermercados.elementAt(i),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: localidadCantidad.elementAt(i) / total,
            title: Datos().supermercados.elementAt(i),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: localidadCantidad.elementAt(i) / total,
            title: Datos().supermercados.elementAt(i),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return PieChartSectionData(
            color: Color.fromARGB(255, 157, 19, 211),
            value: localidadCantidad.elementAt(i) / total,
            title: Datos().supermercados.elementAt(i),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
      }
    });
  }

  Future<List<BarChartGroupData>> ticket_sexo() async {
    List<String> fechaList = [];
    List<int> productos = [];
    List<int> mujeresList = [];
    for (var i = 0; i < 15; i++) {
      String fecha = DateTime.now()
          .subtract(Duration(days: i))
          .toString()
          .substring(0, 10);
      await FirebaseFirestore.instance
          .collection('tickets')
          .where('fecha', isEqualTo: fecha)
          .get()
          .then((value) {
        fechaList.add(fecha);
        int productosaux = 0;
        int mujeres = 0;
        for (var doc in value.docs) {
          productosaux = productosaux + 1;
          mujeres = mujeres + (doc.get('sexo') as int);
        }
        mujeresList.add(mujeres);
        productos.add(productosaux);
      });
    }

    return List.generate(fechaList.length, (index) {
      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(toY: mujeresList.elementAt(index).toDouble()),
        BarChartRodData(
            toY: productos.elementAt(index).toDouble(), color: Colors.purple)
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analiticas'),
      ),
      body: ListView(children: [
        const Padding(
          padding: EdgeInsets.all(14.0),
          child: Text('Localidades'),
        ),
        SizedBox(
          height: 250,
          child: FutureBuilder<List<PieChartSectionData>>(
            future: showingSectionsLocalidad(),
            builder: (context, snap) =>
                snap.connectionState == ConnectionState.done
                    ? PieChart(
                        PieChartData(
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 30,
                            sections: snap.data),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(14.0),
          child: Text('Supermercados'),
        ),
        SizedBox(
          height: 250,
          child: FutureBuilder<List<PieChartSectionData>>(
              future: showingSectionsSupermercados(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.done) {
                  print(snap.data);
                  return PieChart(
                    PieChartData(
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 2,
                        centerSpaceRadius: 60,
                        sections: snap.data),
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
            height: 600,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<BarChartGroupData>>(
                  future: ticket_sexo(),
                  builder: (ctx, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return BarChart(BarChartData(
                        titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                                axisNameWidget: const Text('Tickets')),
                            bottomTitles: AxisTitles(
                                axisNameWidget: const Text('Fecha'))),
                        barGroups: snap.data));
                  }),
            )),
        SizedBox(
          height: 10,
        )
      ]),
    );
  }
}

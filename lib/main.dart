import 'package:bigdata/home.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Big Data Project',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const Home(),
    );
  }
}

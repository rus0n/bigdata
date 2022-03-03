import 'dart:io';

import 'package:flutter/material.dart';

class ImageRect extends StatelessWidget {
  const ImageRect({Key? key, required this.imagePath}) : super(key: key);

  final String imagePath;
  @override
  Widget build(BuildContext context) {
    //Implementar rectangulos en el texto detectado para ver mejor la funcion
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Image.file(File(imagePath))),
    );
  }
}

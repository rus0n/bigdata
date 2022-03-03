import 'package:bigdata/image_rect.dart';
import 'package:bigdata/service.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String text = 'Sin escanear';
  String imagePath = '...';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Big Data Project'),
        actions: [
          text != 'Sin escanear'
              ? TextButton.icon(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ImageRect(imagePath: imagePath),
                      )),
                  icon: const Icon(Icons.image),
                  label: const Text(
                    'Monstrar imagen',
                    style: TextStyle(color: Colors.white),
                  ))
              : Container()
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(text),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final String? filePath = await ServiceScan().hacerFoto();

          if (filePath != null) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('Procesando foto...'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ],
                      ),
                    ));

            final RecognisedText recognisedText =
                await ServiceScan().scan(filePath);

            setState(() {
              text = recognisedText.text;
              imagePath = filePath;
            });

            for (TextBlock block in recognisedText.blocks) {
              final List<String> languages = block.recognizedLanguages;
              debugPrint(block.text);

              // for (TextLine line in block.lines) {
              //   //debugPrint(line.text);
              //   for (TextElement element in line.elements) {
              //     //debugPrint(element.text);
              //   }
              // }
            }

            Navigator.pop(context);
          }
        },
        label: const Text('Escanear'),
        icon: const Icon(Icons.document_scanner_outlined),
      ),
    );
  }
}

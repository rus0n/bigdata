import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ServiceScan {
  String sinEspacios(String text) {
    String trimmed = text.trim();

    String sinEspacios = trimmed.replaceAll(' ', '');
    return sinEspacios;
  }

  Future<String?> hacerFoto() async {
    final XFile? foto =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (foto != null) {
      return foto.path;
    } else {
      return null;
    }
  }

  Future<RecognisedText> scan(String filePath) async {
    final inputImage = InputImage.fromFilePath(filePath);

    final textDetector = GoogleMlKit.vision.textDetector();

    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);

    return recognisedText;
  }
}

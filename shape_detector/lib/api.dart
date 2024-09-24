import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String?> sendImageAndReceiveGLB(String imagePath) async {
  final url = Uri.parse('https://lascade-task.onrender.com/process-image/');

  try {
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      imagePath,
      filename: 'image.png',
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      Uint8List bytes = await response.stream.toBytes();
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/received_model.glb'; // Change extension to .glb
      File glbFile = File(filePath);
      await glbFile.writeAsBytes(bytes);

      print('GLB file saved at: $filePath');
      return filePath; // Return the path to the saved GLB file
    } else {
      print(
          'Error: Failed to get the GLB file. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

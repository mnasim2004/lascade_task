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

      // Check if the response is a PNG or a GLB
      String filePath;
      if (isGlbFile(bytes)) {
        filePath = '${directory.path}/received_model.glb'; // Save as GLB
        await File(filePath).writeAsBytes(bytes);
      } else {
        filePath = '${directory.path}/received_image.png'; // Save as PNG
        await File(filePath).writeAsBytes(bytes);
      }

      print('File saved at: $filePath');
      return filePath; // Return the path to the saved file
    } else {
      print(
          'Error: Failed to get the file. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

// Function to determine if the file is a GLB based on its bytes
bool isGlbFile(Uint8List bytes) {
  // Check the magic number for GLB files
  // GLB files should start with 'glTF' (0x67, 0x6c, 0x54, 0x20)
  if (bytes.length >= 4) {
    return bytes[0] == 0x67 &&
        bytes[1] == 0x6c &&
        bytes[2] == 0x54 &&
        bytes[3] == 0x20;
  }
  return false;
}

// import 'dart:io';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart'; // For saving the STL file

// Future<void> sendImageAndReceiveSTL(String imagePath) async {
//   final url = Uri.parse('https://lascade-task.onrender.com/process-image/');

//   try {
//     // Create the multipart request
//     var request = http.MultipartRequest('POST', url);

//     // Add the image file using the image path
//     request.files.add(await http.MultipartFile.fromPath(
//       'file',
//       imagePath,
//       filename: 'image.png', // You can set a custom filename if needed
//     ));

//     // Send the request
//     var response = await request.send();

//     // Check for success
//     if (response.statusCode == 200) {
//       // Get the response as bytes
//       Uint8List bytes = await response.stream.toBytes();

//       // Save the STL file to local storage
//       final directory = await getApplicationDocumentsDirectory();
//       final filePath = '${directory.path}/filename.stl';
//       File stlFile = File(filePath);
//       await stlFile.writeAsBytes(bytes);

//       print('STL file saved at: $filePath');
//     } else {
//       print(
//           'Error: Failed to get the STL file. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
// }

// import 'dart:io';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';

// Future<String?> sendImageAndReceiveSTL(String imagePath) async {
//   final url = Uri.parse('https://lascade-task.onrender.com/process-image/');

//   try {
//     var request = http.MultipartRequest('POST', url);
//     request.files.add(await http.MultipartFile.fromPath(
//       'file',
//       imagePath,
//       filename: 'image.png',
//     ));

//     var response = await request.send();

//     if (response.statusCode == 200) {
//       Uint8List bytes = await response.stream.toBytes();
//       final directory = await getApplicationDocumentsDirectory();
//       final filePath = '${directory.path}/received_model.glb';
//       File stlFile = File(filePath);
//       await stlFile.writeAsBytes(bytes);

//       print('STL file saved at: $filePath');
//       return filePath; // Return the path to the saved STL file
//     } else {
//       print(
//           'Error: Failed to get the STL file. Status code: ${response.statusCode}');
//       return null;
//     }
//   } catch (e) {
//     print('Error: $e');
//     return null;
//   }
// }
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String?> sendImageAndReceiveOBJ(String imagePath) async {
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
          '${directory.path}/received_model.obj'; // Change extension to .obj
      File objFile = File(filePath);
      await objFile.writeAsBytes(bytes);

      print('OBJ file saved at: $filePath');
      return filePath; // Return the path to the saved OBJ file
    } else {
      print(
          'Error: Failed to get the OBJ file. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

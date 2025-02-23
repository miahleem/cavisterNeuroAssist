import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';

class ApiService {
  static const String apiUrl = "http://10.0.2.2:8000/api/analyze/";

  static Future<List<Map<String, dynamic>>> uploadMRIs(
      List<File> images) async {
    var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

    for (var image in images) {
      var mimeType = lookupMimeType(image.path);
      if (mimeType == null) throw Exception("Invalid file format");

      request.files.add(await http.MultipartFile.fromPath(
        'images',
        image.path,
        contentType: MediaType.parse(mimeType),
      ));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception("Unexpected response format.");
      }
    } else {
      throw Exception("Failed to analyze MRI scans: ${response.body}");
    }
  }
}

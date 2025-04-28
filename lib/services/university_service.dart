import 'package:http/http.dart' as http;
import 'package:tyba_test/models/university.dart';
import 'dart:convert';

class UniversityService {
  static Future<List<University>> fetchUniversities(int page) async {
    final url =
        'https://tyba-assets.s3.amazonaws.com/FE-Engineer-test/universities.json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .skip(page * 20)
          .take(20)
          .map((json) => University.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load universities');
    }
  }
}

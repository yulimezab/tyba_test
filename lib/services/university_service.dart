import 'package:http/http.dart' as http;
import 'package:tyba_test/models/university.dart';
import 'dart:convert';

class UniversityService {
  static Future<List<University>> fetchUniversities() async {
    final response = await http.get(Uri.parse('https://tyba-assets.s3.amazonaws.com/FE-Engineer-test/universities.json'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((u) => University.fromJson(u)).toList();
    } else {
      throw Exception('Failed to load universities');
    }
  }
}

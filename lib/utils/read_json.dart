import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<String> _loadJSONData(String path) async {
  return await rootBundle.loadString(path);
}

Future<dynamic> loadJson(String path) async {
  String jsonString = await _loadJSONData(path);
  final jsonResponse = json.decode(jsonString);
  return jsonResponse;
}

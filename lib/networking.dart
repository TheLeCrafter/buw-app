import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<http.Response> fetchData() async {
  return await http.get(Uri.https("buw-api.thelecrafter.dev", "data"));
}
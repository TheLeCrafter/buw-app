import 'package:http/http.dart' as http;

Future<http.Response> fetchData() async {
  return await http.get(Uri.https("raw.githubusercontent.com", "TheLeCrafter/buw-app-data/main/data/app_posts.json"));
}
import 'dart:convert';
import 'package:http/http.dart' as http;

class TodoService {
  static Future<http.Response> deleteById(String id) async {
    final url = 'http://10.0.2.2:3000/task/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    return response;
  }

  static Future<List?> fetchTodo() async {
    const url = 'http://10.0.2.2:3000/task';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = ((json['tasks'] ?? []) as List);

      return result;
    } else {
      return null;
    }
  }

  static Future<http.Response> submitData(Map body) async {
    const url = 'http://10.0.2.2:3000/task/';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    return response;
  }

  static Future<http.Response> updateData(String id, Map body) async {
    final url = 'http://10.0.2.2:3000/task/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    return response;
  }
}

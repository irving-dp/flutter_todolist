import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_list/core/environment.dart';

class TodoService {
  static Future<http.Response> deleteById(String id) async {
    String endpoint = '/task/$id';
    final url = '${Environtment.apiUrl}$endpoint';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    return response;
  }

  static Future<List?> fetchTodo() async {
    String endpoint = '/task';
    final uri = Uri.parse('${Environtment.apiUrl}$endpoint');
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
    String endpoint = '/task';
    final uri = Uri.parse('${Environtment.apiUrl}$endpoint');
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    return response;
  }

  static Future<http.Response> updateData(String id, Map body) async {
    String endpoint = '/task/$id';
    final uri = Uri.parse('${Environtment.apiUrl}$endpoint');
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    return response;
  }
}

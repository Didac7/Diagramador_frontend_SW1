import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Servicio HTTP para comunicación con el backend REST
class HttpService {
  final String _baseUrl = ApiConfig.baseUrl;

  /// GET request
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl$endpoint'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en GET: $e');
    }
  }

  /// POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(data),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en POST: $e');
    }
  }

  /// PUT request
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_baseUrl$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(data),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en PUT: $e');
    }
  }

  /// DELETE request
  Future<void> delete(String endpoint) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$_baseUrl$endpoint'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en DELETE: $e');
    }
  }
}

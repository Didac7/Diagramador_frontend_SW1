import 'package:flutter/foundation.dart';
import '../models/persona.dart';
import '../services/http_service.dart';

/// Controlador para la entidad Persona
class PersonaController extends ChangeNotifier {
  final HttpService _httpService = HttpService();
  List<Persona> _items = [];
  bool _isLoading = false;
  String? _error;

  List<Persona> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// GET: Obtener todos los elementos
  Future<void> getAll() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _httpService.get('/Persona');
      _items = (response as List).map((json) => Persona.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// GET by ID: Obtener elemento por ID
  Future<Persona?> getById(int id) async {
    try {
      final response = await _httpService.get('/Persona/$id');
      return Persona.fromJson(response);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// POST: Crear nuevo elemento
  Future<bool> create(Persona persona) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _httpService.post('/Persona', persona.toJson());
      await getAll();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// PUT: Actualizar elemento existente
  Future<bool> update(int id, Persona persona) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _httpService.put('/Persona/$id', persona.toJson());
      await getAll();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// DELETE: Eliminar elemento
  Future<bool> delete(int id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _httpService.delete('/Persona/$id');
      await getAll();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

import 'package:flutter/foundation.dart';
import '../models/membresia.dart';
import '../services/http_service.dart';

/// Controlador para la entidad Membresia
class MembresiaController extends ChangeNotifier {
  final HttpService _httpService = HttpService();
  List<Membresia> _items = [];
  bool _isLoading = false;
  String? _error;

  List<Membresia> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// GET: Obtener todos los elementos
  Future<void> getAll() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _httpService.get('/Membresia');
      _items = (response as List).map((json) => Membresia.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// GET by ID: Obtener elemento por ID
  Future<Membresia?> getById(int id) async {
    try {
      final response = await _httpService.get('/Membresia/$id');
      return Membresia.fromJson(response);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// POST: Crear nuevo elemento
  Future<bool> create(Membresia membresia) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _httpService.post('/Membresia', membresia.toJson());
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
  Future<bool> update(int id, Membresia membresia) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _httpService.put('/Membresia/$id', membresia.toJson());
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

      await _httpService.delete('/Membresia/$id');
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

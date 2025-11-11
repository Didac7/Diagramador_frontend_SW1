import 'package:flutter/foundation.dart';
import '../models/inventario.dart';
import '../services/http_service.dart';

/// Controlador para la entidad Inventario
class InventarioController extends ChangeNotifier {
  final HttpService _httpService = HttpService();
  List<Inventario> _items = [];
  bool _isLoading = false;
  String? _error;

  List<Inventario> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// GET: Obtener todos los elementos
  Future<void> getAll() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _httpService.get('/Inventario');
      _items = (response as List).map((json) => Inventario.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// GET by ID: Obtener elemento por ID
  Future<Inventario?> getById(int id) async {
    try {
      final response = await _httpService.get('/Inventario/$id');
      return Inventario.fromJson(response);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// POST: Crear nuevo elemento
  Future<bool> create(Inventario inventario) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _httpService.post('/Inventario', inventario.toJson());
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
  Future<bool> update(int id, Inventario inventario) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _httpService.put('/Inventario/$id', inventario.toJson());
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

      await _httpService.delete('/Inventario/$id');
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

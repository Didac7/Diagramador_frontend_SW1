import 'package:flutter/foundation.dart';
import '../models/almacen.dart';
import '../services/http_service.dart';

/// Controlador para la entidad Almacen
class AlmacenController extends ChangeNotifier {
  final HttpService _httpService = HttpService();
  List<Almacen> _items = [];
  bool _isLoading = false;
  String? _error;

  List<Almacen> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// GET: Obtener todos los elementos
  Future<void> getAll() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _httpService.get('/Almacen');
      _items = (response as List).map((json) => Almacen.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// GET by ID: Obtener elemento por ID
  Future<Almacen?> getById(int id) async {
    try {
      final response = await _httpService.get('/Almacen/$id');
      return Almacen.fromJson(response);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// POST: Crear nuevo elemento
  Future<bool> create(Almacen almacen) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _httpService.post('/Almacen', almacen.toJson());
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
  Future<bool> update(int id, Almacen almacen) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _httpService.put('/Almacen/$id', almacen.toJson());
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

      await _httpService.delete('/Almacen/$id');
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

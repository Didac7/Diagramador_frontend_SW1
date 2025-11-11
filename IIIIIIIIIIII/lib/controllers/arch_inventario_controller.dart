import 'package:flutter/foundation.dart';
import '../models/arch_inventario.dart';
import '../services/http_service.dart';

/// Controlador para la entidad ArchInventario
class ArchInventarioController extends ChangeNotifier {
  final HttpService _httpService = HttpService();
  List<ArchInventario> _items = [];
  bool _isLoading = false;
  String? _error;

  List<ArchInventario> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// GET: Obtener todos los elementos
  Future<void> getAll() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _httpService.get('/ArchInventario');
      _items = (response as List).map((json) => ArchInventario.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// GET by ID: Obtener elemento por ID
  Future<ArchInventario?> getById(int id) async {
    try {
      final response = await _httpService.get('/ArchInventario/$id');
      return ArchInventario.fromJson(response);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// POST: Crear nuevo elemento
  Future<bool> create(ArchInventario archInventario) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _httpService.post('/ArchInventario', archInventario.toJson());
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
  Future<bool> update(int id, ArchInventario archInventario) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _httpService.put('/ArchInventario/$id', archInventario.toJson());
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

      await _httpService.delete('/ArchInventario/$id');
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

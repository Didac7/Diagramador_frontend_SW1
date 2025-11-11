import 'package:flutter/foundation.dart';
import '../models/ventaproducto.dart';
import '../services/http_service.dart';

/// Controlador para la entidad Ventaproducto
class VentaproductoController extends ChangeNotifier {
  final HttpService _httpService = HttpService();
  List<Ventaproducto> _items = [];
  bool _isLoading = false;
  String? _error;

  List<Ventaproducto> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// GET: Obtener todos los elementos
  Future<void> getAll() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _httpService.get('/Ventaproducto');
      _items = (response as List).map((json) => Ventaproducto.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// GET by ID: Obtener elemento por ID
  Future<Ventaproducto?> getById(int id) async {
    try {
      final response = await _httpService.get('/Ventaproducto/$id');
      return Ventaproducto.fromJson(response);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// POST: Crear nuevo elemento
  Future<bool> create(Ventaproducto ventaproducto) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _httpService.post('/Ventaproducto', ventaproducto.toJson());
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
  Future<bool> update(int id, Ventaproducto ventaproducto) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _httpService.put('/Ventaproducto/$id', ventaproducto.toJson());
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

      await _httpService.delete('/Ventaproducto/$id');
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

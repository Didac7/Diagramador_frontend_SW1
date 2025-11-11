import 'package:flutter/foundation.dart';
import '../models/entity_model.dart';
import '../models/project_config.dart';
import '../services/input_interpreter_service.dart';
import '../services/code_generator_service.dart';

class GeneratorController extends ChangeNotifier {
  final InputInterpreterService _interpreterService = InputInterpreterService();
  final CodeGeneratorService _codeGeneratorService = CodeGeneratorService();

  bool _isProcessing = false;
  String _statusMessage = 'Esperando entrada...';
  double _progress = 0.0;
  ProjectConfig? _currentProject;
  List<EntityModel> _entities = [];

  bool get isProcessing => _isProcessing;
  String get statusMessage => _statusMessage;
  double get progress => _progress;
  ProjectConfig? get currentProject => _currentProject;
  List<EntityModel> get entities => _entities;

  /// Procesa una imagen (diagrama de clases o entidad)
  Future<void> processImage(String imagePath) async {
    try {
      _setProcessing(true, 'Analizando imagen...');
      _updateProgress(0.2);

      final entities = await _interpreterService.interpretImage(imagePath);
      
      _updateProgress(0.5);
      _entities = entities;
      _setProcessing(false, 'Imagen procesada: ${entities.length} entidades encontradas');
      
      notifyListeners();
    } catch (e) {
      _setProcessing(false, 'Error al procesar imagen: $e');
    }
  }

  /// Procesa un prompt de texto
  Future<void> processTextPrompt(String prompt) async {
    try {
      _setProcessing(true, 'Interpretando prompt...');
      _updateProgress(0.2);

      final entities = await _interpreterService.interpretTextPrompt(prompt);
      
      _updateProgress(0.5);
      _entities = entities;
      _setProcessing(false, 'Prompt procesado: ${entities.length} entidades encontradas');
      
      notifyListeners();
    } catch (e) {
      _setProcessing(false, 'Error al procesar prompt: $e');
    }
  }

  /// Procesa audio
  Future<void> processAudio(String audioPath) async {
    try {
      _setProcessing(true, 'Transcribiendo audio...');
      _updateProgress(0.2);

      final text = await _interpreterService.transcribeAudio(audioPath);
      
      _updateProgress(0.4);
      _updateStatus('Interpretando transcripción...');
      
      final entities = await _interpreterService.interpretTextPrompt(text);
      
      _updateProgress(0.6);
      _entities = entities;
      _setProcessing(false, 'Audio procesado: ${entities.length} entidades encontradas');
      
      notifyListeners();
    } catch (e) {
      _setProcessing(false, 'Error al procesar audio: $e');
    }
  }

  /// Procesa un archivo SQL
  Future<void> processSqlFile(String sqlFilePath) async {
    try {
      _setProcessing(true, 'Parseando archivo SQL...');
      _updateProgress(0.2);

      final entities = await _interpreterService.interpretSqlFile(sqlFilePath);
      
      _updateProgress(0.5);
      _entities = entities;
      _setProcessing(false, 'SQL procesado: ${entities.length} entidades encontradas');
      
      notifyListeners();
    } catch (e) {
      _setProcessing(false, 'Error al procesar SQL: $e');
    }
  }

  /// Procesa contenido SQL directo (para web)
  Future<void> processSqlContent(String sqlContent) async {
    try {
      _setProcessing(true, 'Parseando SQL...');
      _updateProgress(0.2);

      final entities = await _interpreterService.interpretSqlContent(sqlContent);
      
      _updateProgress(0.5);
      _entities = entities;
      _setProcessing(false, 'SQL procesado: ${entities.length} entidades encontradas');
      
      notifyListeners();
    } catch (e) {
      _setProcessing(false, 'Error al procesar SQL: $e');
    }
  }

  /// Genera el código del proyecto Flutter
  Future<void> generateProject({
    required String projectName,
    required String baseUrl,
    required String outputPath,
  }) async {
    try {
      _setProcessing(true, 'Generando proyecto Flutter...');
      _updateProgress(0.1);

      // Crear subcarpeta con el nombre del proyecto
      final projectPath = '$outputPath${outputPath.endsWith('\\') || outputPath.endsWith('/') ? '' : '\\'}$projectName';

      final config = ProjectConfig(
        projectName: projectName,
        baseUrl: baseUrl,
        entities: _entities,
        outputPath: projectPath,
      );

      _currentProject = config;
      
      _updateProgress(0.3);
      _updateStatus('Generando modelos...');
      await _codeGeneratorService.generateModels(config);
      
      _updateProgress(0.5);
      _updateStatus('Generando controladores...');
      await _codeGeneratorService.generateControllers(config);
      
      _updateProgress(0.7);
      _updateStatus('Generando vistas...');
      await _codeGeneratorService.generateViews(config);
      
      _updateProgress(0.9);
      _updateStatus('Configurando proyecto...');
      await _codeGeneratorService.generateProjectStructure(config);
      
      _updateProgress(1.0);
      _setProcessing(false, '✅ Proyecto generado exitosamente en: $projectPath');
      
      notifyListeners();
    } catch (e) {
      _setProcessing(false, '❌ Error: La generación de archivos no funciona en navegadores web.\n\n'
          'Para generar archivos reales necesitas:\n'
          '1. Instalar Visual Studio (con C++ desktop development)\n'
          '2. Ejecutar: flutter run -d windows\n\n'
          'Detalles del error: $e');
    }
  }

  void _setProcessing(bool value, String message) {
    _isProcessing = value;
    _statusMessage = message;
    if (!value) _progress = 0.0;
    notifyListeners();
  }

  void _updateProgress(double value) {
    _progress = value;
    notifyListeners();
  }

  void _updateStatus(String message) {
    _statusMessage = message;
    notifyListeners();
  }

  void reset() {
    _entities = [];
    _currentProject = null;
    _progress = 0.0;
    _statusMessage = 'Esperando entrada...';
    notifyListeners();
  }
}

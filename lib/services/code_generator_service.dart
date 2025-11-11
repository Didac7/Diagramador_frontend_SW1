import 'dart:io';
import '../models/project_config.dart';
import '../models/entity_model.dart';
import 'package:path/path.dart' as path;

/// Servicio para generar el código del proyecto Flutter
class CodeGeneratorService {
  /// Genera los modelos Dart para cada entidad
  Future<void> generateModels(ProjectConfig config) async {
    final modelsDir = Directory(path.join(config.outputPath, 'lib', 'models'));
    await modelsDir.create(recursive: true);

    for (var entity in config.entities) {
      final modelCode = _generateModelCode(entity);
      final modelFile = File(path.join(modelsDir.path, '${_toSnakeCase(entity.name)}.dart'));
      await modelFile.writeAsString(modelCode);
    }
  }

  /// Genera los controladores para cada entidad
  Future<void> generateControllers(ProjectConfig config) async {
    final controllersDir = Directory(path.join(config.outputPath, 'lib', 'controllers'));
    await controllersDir.create(recursive: true);

    for (var entity in config.entities) {
      final controllerCode = _generateControllerCode(entity, config.baseUrl);
      final controllerFile = File(path.join(controllersDir.path, '${_toSnakeCase(entity.name)}_controller.dart'));
      await controllerFile.writeAsString(controllerCode);
    }
  }

  /// Genera las vistas para cada entidad
  Future<void> generateViews(ProjectConfig config) async {
    final viewsDir = Directory(path.join(config.outputPath, 'lib', 'views'));
    await viewsDir.create(recursive: true);

    for (var entity in config.entities) {
      // Vista de lista
      final listViewCode = _generateListViewCode(entity);
      final listViewFile = File(path.join(viewsDir.path, '${_toSnakeCase(entity.name)}_list_view.dart'));
      await listViewFile.writeAsString(listViewCode);

      // Vista de formulario
      final formViewCode = _generateFormViewCode(entity);
      final formViewFile = File(path.join(viewsDir.path, '${_toSnakeCase(entity.name)}_form_view.dart'));
      await formViewFile.writeAsString(formViewCode);
    }
  }

  /// Genera la estructura completa del proyecto
  Future<void> generateProjectStructure(ProjectConfig config) async {
    // Crear pubspec.yaml
    await _generatePubspec(config);

    // Crear main.dart
    await _generateMain(config);

    // Crear configuración de API
    await _generateApiConfig(config);

    // Crear servicio HTTP
    await _generateHttpService(config);

    // Crear README
    await _generateReadme(config);

    // Agregar soporte de Windows automáticamente
    await _addWindowsSupport(config);
  }

  Future<void> _addWindowsSupport(ProjectConfig config) async {
    try {
      print('Agregando soporte de Windows al proyecto...');
      final result = await Process.run(
        'flutter',
        ['create', '--platforms=windows', '.'],
        workingDirectory: config.outputPath,
        runInShell: true,
      );
      
      if (result.exitCode == 0) {
        print('✓ Soporte de Windows agregado exitosamente');
      } else {
        print('⚠ Advertencia al agregar soporte de Windows: ${result.stderr}');
      }
    } catch (e) {
      print('⚠ No se pudo agregar soporte de Windows automáticamente: $e');
      print('  Puedes agregarlo manualmente con: flutter create --platforms=windows .');
    }
  }

  String _generateModelCode(EntityModel entity) {
    final buffer = StringBuffer();
    
    buffer.writeln("/// Modelo para la entidad ${entity.className}");
    buffer.writeln("class ${entity.className} {");

    // Atributos con camelCase
    for (var attr in entity.attributes) {
      final nullable = attr.isNullable ? '?' : '';
      final camelCaseName = _toCamelCase(attr.name);
      buffer.writeln("  final ${attr.dartType}$nullable $camelCaseName;");
    }

    buffer.writeln();

    // Constructor
    buffer.writeln("  ${entity.className}({");
    for (var attr in entity.attributes) {
      final required = !attr.isNullable ? 'required ' : '';
      final camelCaseName = _toCamelCase(attr.name);
      buffer.writeln("    ${required}this.$camelCaseName,");
    }
    buffer.writeln("  });");

    buffer.writeln();

    // fromJson con manejo robusto de tipos
    buffer.writeln("  factory ${entity.className}.fromJson(Map<String, dynamic> json) {");
    buffer.writeln("    return ${entity.className}(");
    for (var attr in entity.attributes) {
      final camelCaseName = _toCamelCase(attr.name);
      String conversion;
      if (attr.dartType == 'int') {
        if (attr.isNullable) {
          conversion = "json['$camelCaseName'] != null ? int.tryParse(json['$camelCaseName'].toString()) : null";
        } else {
          conversion = "int.tryParse(json['$camelCaseName']?.toString() ?? '') ?? 0";
        }
      } else if (attr.dartType == 'double') {
        if (attr.isNullable) {
          conversion = "json['$camelCaseName'] != null ? double.tryParse(json['$camelCaseName'].toString()) : null";
        } else {
          conversion = "double.tryParse(json['$camelCaseName']?.toString() ?? '') ?? 0.0";
        }
      } else if (attr.dartType == 'DateTime') {
        // Para DateTime, manejamos nullable y non-nullable
        if (attr.isNullable) {
          conversion = "json['$camelCaseName'] != null ? DateTime.tryParse(json['$camelCaseName'].toString()) : null";
        } else {
          conversion = "DateTime.tryParse(json['$camelCaseName']?.toString() ?? '') ?? DateTime.now()";
        }
      } else if (attr.dartType == 'String') {
        // Para String, aseguramos que no sea null si no es nullable
        if (attr.isNullable) {
          conversion = "json['$camelCaseName']?.toString()";
        } else {
          conversion = "json['$camelCaseName']?.toString() ?? ''";
        }
      } else {
        conversion = "json['$camelCaseName']?.toString()";
      }
      buffer.writeln("      $camelCaseName: $conversion,");
    }
    buffer.writeln("    );");
    buffer.writeln("  }");

    buffer.writeln();

    // toJson
    buffer.writeln("  Map<String, dynamic> toJson() {");
    buffer.writeln("    return {");
    for (var attr in entity.attributes) {
      final camelCaseName = _toCamelCase(attr.name);
      if (attr.dartType == 'DateTime') {
        if (attr.isNullable) {
          buffer.writeln("      '$camelCaseName': $camelCaseName?.toIso8601String(),");
        } else {
          buffer.writeln("      '$camelCaseName': $camelCaseName.toIso8601String(),");
        }
      } else {
        buffer.writeln("      '$camelCaseName': $camelCaseName,");
      }
    }
    buffer.writeln("    };");
    buffer.writeln("  }");

    buffer.writeln("}");

    return buffer.toString();
  }

  String _generateControllerCode(EntityModel entity, String baseUrl) {
    final buffer = StringBuffer();
    final className = entity.className;
    final variableName = entity.variableName;
    // Usar className (singular) con mayúscula inicial como en Spring Boot
    final apiPath = className;

    buffer.writeln("import 'package:flutter/foundation.dart';");
    buffer.writeln("import '../models/${_toSnakeCase(entity.name)}.dart';");
    buffer.writeln("import '../services/http_service.dart';");
    buffer.writeln();
    buffer.writeln("/// Controlador para la entidad $className");
    buffer.writeln("class ${className}Controller extends ChangeNotifier {");
    buffer.writeln("  final HttpService _httpService = HttpService();");
    buffer.writeln("  List<$className> _items = [];");
    buffer.writeln("  bool _isLoading = false;");
    buffer.writeln("  String? _error;");
    buffer.writeln();
    buffer.writeln("  List<$className> get items => _items;");
    buffer.writeln("  bool get isLoading => _isLoading;");
    buffer.writeln("  String? get error => _error;");
    buffer.writeln();
    buffer.writeln("  /// GET: Obtener todos los elementos");
    buffer.writeln("  Future<void> getAll() async {");
    buffer.writeln("    try {");
    buffer.writeln("      _isLoading = true;");
    buffer.writeln("      _error = null;");
    buffer.writeln("      notifyListeners();");
    buffer.writeln();
    buffer.writeln("      final response = await _httpService.get('/$apiPath');");
    buffer.writeln("      _items = (response as List).map((json) => $className.fromJson(json)).toList();");
    buffer.writeln("    } catch (e) {");
    buffer.writeln("      _error = e.toString();");
    buffer.writeln("    } finally {");
    buffer.writeln("      _isLoading = false;");
    buffer.writeln("      notifyListeners();");
    buffer.writeln("    }");
    buffer.writeln("  }");
    buffer.writeln();
    buffer.writeln("  /// GET by ID: Obtener elemento por ID");
    buffer.writeln("  Future<$className?> getById(int id) async {");
    buffer.writeln("    try {");
    buffer.writeln("      final response = await _httpService.get('/$apiPath/\$id');");
    buffer.writeln("      return $className.fromJson(response);");
    buffer.writeln("    } catch (e) {");
    buffer.writeln("      _error = e.toString();");
    buffer.writeln("      notifyListeners();");
    buffer.writeln("      return null;");
    buffer.writeln("    }");
    buffer.writeln("  }");
    buffer.writeln();
    buffer.writeln("  /// POST: Crear nuevo elemento");
    buffer.writeln("  Future<bool> create($className $variableName) async {");
    buffer.writeln("    try {");
    buffer.writeln("      _isLoading = true;");
    buffer.writeln("      _error = null;");
    buffer.writeln("      notifyListeners();");
    buffer.writeln();
    buffer.writeln("      await _httpService.post('/$apiPath', $variableName.toJson());");
    buffer.writeln("      await getAll();");
    buffer.writeln("      return true;");
    buffer.writeln("    } catch (e) {");
    buffer.writeln("      _error = e.toString();");
    buffer.writeln("      notifyListeners();");
    buffer.writeln("      return false;");
    buffer.writeln("    } finally {");
    buffer.writeln("      _isLoading = false;");
    buffer.writeln("      notifyListeners();");
    buffer.writeln("    }");
    buffer.writeln("  }");
    buffer.writeln();
    buffer.writeln("  /// PUT: Actualizar elemento existente");
    buffer.writeln("  Future<bool> update(int id, $className $variableName) async {");
    buffer.writeln("    try {");
    buffer.writeln("      _isLoading = true;");
    buffer.writeln("      _error = null;");
    buffer.writeln("      notifyListeners();");
    buffer.writeln();
    buffer.writeln("      await _httpService.put('/$apiPath/\$id', $variableName.toJson());");
    buffer.writeln("      await getAll();");
    buffer.writeln("      return true;");
    buffer.writeln("    } catch (e) {");
    buffer.writeln("      _error = e.toString();");
    buffer.writeln("      notifyListeners();");
    buffer.writeln("      return false;");
    buffer.writeln("    } finally {");
    buffer.writeln("      _isLoading = false;");
    buffer.writeln("      notifyListeners();");
    buffer.writeln("    }");
    buffer.writeln("  }");
    buffer.writeln();
    buffer.writeln("  /// DELETE: Eliminar elemento");
    buffer.writeln("  Future<bool> delete(int id) async {");
    buffer.writeln("    try {");
    buffer.writeln("      _isLoading = true;");
    buffer.writeln("      _error = null;");
    buffer.writeln("      notifyListeners();");
    buffer.writeln();
    buffer.writeln("      await _httpService.delete('/$apiPath/\$id');");
    buffer.writeln("      await getAll();");
    buffer.writeln("      return true;");
    buffer.writeln("    } catch (e) {");
    buffer.writeln("      _error = e.toString();");
    buffer.writeln("      notifyListeners();");
    buffer.writeln("      return false;");
    buffer.writeln("    } finally {");
    buffer.writeln("      _isLoading = false;");
    buffer.writeln("      notifyListeners();");
    buffer.writeln("    }");
    buffer.writeln("  }");
    buffer.writeln("}");

    return buffer.toString();
  }

  String _generateListViewCode(EntityModel entity) {
    final buffer = StringBuffer();
    final className = entity.className;
    final snakeName = _toSnakeCase(entity.name);

    buffer.writeln("import 'package:flutter/material.dart';");
    buffer.writeln("import 'package:provider/provider.dart';");
    buffer.writeln("import '../controllers/${snakeName}_controller.dart';");
    buffer.writeln("import '${snakeName}_form_view.dart';");
    buffer.writeln();
    buffer.writeln("class ${className}ListView extends StatefulWidget {");
    buffer.writeln("  const ${className}ListView({super.key});");
    buffer.writeln();
    buffer.writeln("  @override");
    buffer.writeln("  State<${className}ListView> createState() => _${className}ListViewState();");
    buffer.writeln("}");
    buffer.writeln();
    buffer.writeln("class _${className}ListViewState extends State<${className}ListView> {");
    buffer.writeln("  @override");
    buffer.writeln("  void initState() {");
    buffer.writeln("    super.initState();");
    buffer.writeln("    WidgetsBinding.instance.addPostFrameCallback((_) {");
    buffer.writeln("      context.read<${className}Controller>().getAll();");
    buffer.writeln("    });");
    buffer.writeln("  }");
    buffer.writeln();
    buffer.writeln("  @override");
    buffer.writeln("  Widget build(BuildContext context) {");
    buffer.writeln("    return Scaffold(");
    buffer.writeln("      appBar: AppBar(");
    buffer.writeln("        title: const Text('$className'),");
    buffer.writeln("      ),");
    buffer.writeln("      body: Consumer<${className}Controller>(");
    buffer.writeln("        builder: (context, controller, child) {");
    buffer.writeln("          if (controller.isLoading) {");
    buffer.writeln("            return const Center(child: CircularProgressIndicator());");
    buffer.writeln("          }");
    buffer.writeln();
    buffer.writeln("          if (controller.error != null) {");
    buffer.writeln("            return Center(child: Text('Error: \${controller.error}'));");
    buffer.writeln("          }");
    buffer.writeln();
    buffer.writeln("          return ListView.builder(");
    buffer.writeln("            itemCount: controller.items.length,");
    buffer.writeln("            itemBuilder: (context, index) {");
    buffer.writeln("              final item = controller.items[index];");
    buffer.writeln("              return ListTile(");
    
    // Usar el primer atributo no-ID como título
    final titleAttr = entity.attributes.firstWhere(
      (a) => !a.isPrimaryKey,
      orElse: () => entity.attributes.first,
    );
    final titleCamelCase = _toCamelCase(titleAttr.name);
    
    buffer.writeln("                title: Text(item.$titleCamelCase?.toString() ?? 'Sin nombre'),");
    buffer.writeln("                trailing: Row(");
    buffer.writeln("                  mainAxisSize: MainAxisSize.min,");
    buffer.writeln("                  children: [");
    buffer.writeln("                    IconButton(");
    buffer.writeln("                      icon: const Icon(Icons.edit),");
    buffer.writeln("                      onPressed: () {");
    buffer.writeln("                        Navigator.push(");
    buffer.writeln("                          context,");
    buffer.writeln("                          MaterialPageRoute(");
    buffer.writeln("                            builder: (_) => ${className}FormView(item: item),");
    buffer.writeln("                          ),");
    buffer.writeln("                        );");
    buffer.writeln("                      },");
    buffer.writeln("                    ),");
    buffer.writeln("                    IconButton(");
    buffer.writeln("                      icon: const Icon(Icons.delete),");
    buffer.writeln("                      onPressed: () async {");
    
    // Obtener ID
    final idAttr = entity.attributes.firstWhere(
      (a) => a.isPrimaryKey,
      orElse: () => entity.attributes.first,
    );
    final idCamelCase = _toCamelCase(idAttr.name);
    
    buffer.writeln("                        if (item.$idCamelCase != null) {");
    buffer.writeln("                          await controller.delete(item.$idCamelCase!);");
    buffer.writeln("                        }");
    buffer.writeln("                      },");
    buffer.writeln("                    ),");
    buffer.writeln("                  ],");
    buffer.writeln("                ),");
    buffer.writeln("              );");
    buffer.writeln("            },");
    buffer.writeln("          );");
    buffer.writeln("        },");
    buffer.writeln("      ),");
    buffer.writeln("      floatingActionButton: FloatingActionButton(");
    buffer.writeln("        onPressed: () {");
    buffer.writeln("          Navigator.push(");
    buffer.writeln("            context,");
    buffer.writeln("            MaterialPageRoute(builder: (_) => const ${className}FormView()),");
    buffer.writeln("          );");
    buffer.writeln("        },");
    buffer.writeln("        child: const Icon(Icons.add),");
    buffer.writeln("      ),");
    buffer.writeln("    );");
    buffer.writeln("  }");
    buffer.writeln("}");

    return buffer.toString();
  }

  String _generateFormViewCode(EntityModel entity) {
    final buffer = StringBuffer();
    final className = entity.className;
    final snakeName = _toSnakeCase(entity.name);

    buffer.writeln("import 'package:flutter/material.dart';");
    buffer.writeln("import 'package:provider/provider.dart';");
    buffer.writeln("import '../models/$snakeName.dart';");
    buffer.writeln("import '../controllers/${snakeName}_controller.dart';");
    buffer.writeln();
    buffer.writeln("class ${className}FormView extends StatefulWidget {");
    buffer.writeln("  final $className? item;");
    buffer.writeln();
    buffer.writeln("  const ${className}FormView({super.key, this.item});");
    buffer.writeln();
    buffer.writeln("  @override");
    buffer.writeln("  State<${className}FormView> createState() => _${className}FormViewState();");
    buffer.writeln("}");
    buffer.writeln();
    buffer.writeln("class _${className}FormViewState extends State<${className}FormView> {");
    buffer.writeln("  final _formKey = GlobalKey<FormState>();");

    // Controladores para cada campo (con camelCase)
    for (var attr in entity.attributes) {
      if (!attr.isPrimaryKey) {
        final camelCaseName = _toCamelCase(attr.name);
        buffer.writeln("  final _${camelCaseName}Controller = TextEditingController();");
      }
    }

    buffer.writeln();
    buffer.writeln("  @override");
    buffer.writeln("  void initState() {");
    buffer.writeln("    super.initState();");
    buffer.writeln("    if (widget.item != null) {");
    
    for (var attr in entity.attributes) {
      if (!attr.isPrimaryKey) {
        final camelCaseName = _toCamelCase(attr.name);
        buffer.writeln("      _${camelCaseName}Controller.text = widget.item!.$camelCaseName?.toString() ?? '';");
      }
    }
    
    buffer.writeln("    }");
    buffer.writeln("  }");
    buffer.writeln();
    buffer.writeln("  @override");
    buffer.writeln("  Widget build(BuildContext context) {");
    buffer.writeln("    return Scaffold(");
    buffer.writeln("      appBar: AppBar(");
    buffer.writeln("        title: Text(widget.item == null ? 'Nuevo $className' : 'Editar $className'),");
    buffer.writeln("      ),");
    buffer.writeln("      body: Padding(");
    buffer.writeln("        padding: const EdgeInsets.all(16.0),");
    buffer.writeln("        child: Form(");
    buffer.writeln("          key: _formKey,");
    buffer.writeln("          child: ListView(");
    buffer.writeln("            children: [");

    // Generar campos del formulario
    for (var attr in entity.attributes) {
      if (!attr.isPrimaryKey) {
        final camelCaseName = _toCamelCase(attr.name);
        buffer.writeln("              TextFormField(");
        buffer.writeln("                controller: _${camelCaseName}Controller,");
        buffer.writeln("                decoration: const InputDecoration(labelText: '${attr.name}'),");
        
        if (_isNumericType(attr.dartType)) {
          buffer.writeln("                keyboardType: TextInputType.number,");
        }
        
        if (!attr.isNullable) {
          buffer.writeln("                validator: (value) {");
          buffer.writeln("                  if (value == null || value.isEmpty) {");
          buffer.writeln("                    return 'Este campo es requerido';");
          buffer.writeln("                  }");
          buffer.writeln("                  return null;");
          buffer.writeln("                },");
        }
        
        buffer.writeln("              ),");
        buffer.writeln("              const SizedBox(height: 16),");
      }
    }

    buffer.writeln("              ElevatedButton(");
    buffer.writeln("                onPressed: () async {");
    buffer.writeln("                  if (_formKey.currentState!.validate()) {");
    buffer.writeln("                    final controller = context.read<${className}Controller>();");
    buffer.writeln();
    
    // Crear objeto con camelCase
    buffer.writeln("                    final item = $className(");
    
    for (var attr in entity.attributes) {
      final camelCaseName = _toCamelCase(attr.name);
      if (attr.isPrimaryKey) {
        // Para primary key, usar ?? 0 si es required
        if (attr.isNullable) {
          buffer.writeln("                      $camelCaseName: widget.item?.$camelCaseName,");
        } else {
          buffer.writeln("                      $camelCaseName: widget.item?.$camelCaseName ?? 0,");
        }
      } else {
        String conversion;
        if (attr.dartType == 'int') {
          if (attr.isNullable) {
            conversion = "int.tryParse(_${camelCaseName}Controller.text)";
          } else {
            conversion = "int.tryParse(_${camelCaseName}Controller.text) ?? 0";
          }
        } else if (attr.dartType == 'double') {
          if (attr.isNullable) {
            conversion = "double.tryParse(_${camelCaseName}Controller.text)";
          } else {
            conversion = "double.tryParse(_${camelCaseName}Controller.text) ?? 0.0";
          }
        } else if (attr.dartType == 'DateTime') {
          if (attr.isNullable) {
            conversion = "DateTime.tryParse(_${camelCaseName}Controller.text)";
          } else {
            conversion = "DateTime.tryParse(_${camelCaseName}Controller.text) ?? DateTime.now()";
          }
        } else {
          // String
          if (attr.isNullable) {
            conversion = "_${camelCaseName}Controller.text.isEmpty ? null : _${camelCaseName}Controller.text";
          } else {
            conversion = "_${camelCaseName}Controller.text";
          }
        }
        buffer.writeln("                      $camelCaseName: $conversion,");
      }
    }
    
    buffer.writeln("                    );");
    buffer.writeln();
    
    // Guardar
    final idAttr = entity.attributes.firstWhere((a) => a.isPrimaryKey, orElse: () => entity.attributes.first);
    final idCamelCase = _toCamelCase(idAttr.name);
    
    buffer.writeln("                    bool success;");
    buffer.writeln("                    if (widget.item == null) {");
    buffer.writeln("                      success = await controller.create(item);");
    buffer.writeln("                    } else {");
    buffer.writeln("                      success = await controller.update(widget.item!.$idCamelCase ?? 0, item);");
    buffer.writeln("                    }");
    buffer.writeln();
    buffer.writeln("                    if (success && mounted) {");
    buffer.writeln("                      Navigator.pop(context);");
    buffer.writeln("                    }");
    buffer.writeln("                  }");
    buffer.writeln("                },");
    buffer.writeln("                child: const Text('Guardar'),");
    buffer.writeln("              ),");
    buffer.writeln("            ],");
    buffer.writeln("          ),");
    buffer.writeln("        ),");
    buffer.writeln("      ),");
    buffer.writeln("    );");
    buffer.writeln("  }");
    buffer.writeln("}");

    return buffer.toString();
  }

  Future<void> _generatePubspec(ProjectConfig config) async {
    final content = '''
name: ${_toSnakeCase(config.projectName)}
description: Generated Flutter MVC project
version: 1.0.0
publish_to: 'none'

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  provider: ^6.1.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
''';

    final file = File(path.join(config.outputPath, 'pubspec.yaml'));
    await file.writeAsString(content);
  }

  Future<void> _generateMain(ProjectConfig config) async {
    final buffer = StringBuffer();
    
    buffer.writeln("import 'package:flutter/material.dart';");
    buffer.writeln("import 'package:provider/provider.dart';");
    
    for (var entity in config.entities) {
      final snakeName = _toSnakeCase(entity.name);
      buffer.writeln("import 'controllers/${snakeName}_controller.dart';");
    }
    
    buffer.writeln();
    buffer.writeln("void main() {");
    buffer.writeln("  runApp(const MyApp());");
    buffer.writeln("}");
    buffer.writeln();
    buffer.writeln("class MyApp extends StatelessWidget {");
    buffer.writeln("  const MyApp({super.key});");
    buffer.writeln();
    buffer.writeln("  @override");
    buffer.writeln("  Widget build(BuildContext context) {");
    buffer.writeln("    return MultiProvider(");
    buffer.writeln("      providers: [");
    
    for (var entity in config.entities) {
      buffer.writeln("        ChangeNotifierProvider(create: (_) => ${entity.className}Controller()),");
    }
    
    buffer.writeln("      ],");
    buffer.writeln("      child: MaterialApp(");
    buffer.writeln("        title: '${config.projectName}',");
    buffer.writeln("        theme: ThemeData(");
    buffer.writeln("          primarySwatch: Colors.blue,");
    buffer.writeln("          useMaterial3: true,");
    buffer.writeln("        ),");
    buffer.writeln("        home: const HomePage(),");
    buffer.writeln("      ),");
    buffer.writeln("    );");
    buffer.writeln("  }");
    buffer.writeln("}");
    buffer.writeln();
    buffer.writeln("class HomePage extends StatelessWidget {");
    buffer.writeln("  const HomePage({super.key});");
    buffer.writeln();
    buffer.writeln("  @override");
    buffer.writeln("  Widget build(BuildContext context) {");
    buffer.writeln("    return Scaffold(");
    buffer.writeln("      appBar: AppBar(title: const Text('${config.projectName}')),");
    buffer.writeln("      body: ListView(");
    buffer.writeln("        children: [");
    
    for (var entity in config.entities) {
      buffer.writeln("          ListTile(");
      buffer.writeln("            title: Text('${entity.className}'),");
      buffer.writeln("            trailing: const Icon(Icons.arrow_forward),");
      buffer.writeln("            onTap: () {");
      buffer.writeln("              Navigator.push(");
      buffer.writeln("                context,");
      buffer.writeln("                MaterialPageRoute(");
      buffer.writeln("                  builder: (_) => const ${entity.className}ListView(),");
      buffer.writeln("                ),");
      buffer.writeln("              );");
      buffer.writeln("            },");
      buffer.writeln("          ),");
    }
    
    buffer.writeln("        ],");
    buffer.writeln("      ),");
    buffer.writeln("    );");
    buffer.writeln("  }");
    buffer.writeln("}");
    
    // Preparar imports de vistas
    final viewImports = StringBuffer();
    for (var entity in config.entities) {
      viewImports.writeln("import 'views/${_toSnakeCase(entity.name)}_list_view.dart';");
    }
    
    // Combinar todo
    final finalContent = viewImports.toString() + buffer.toString();

    final file = File(path.join(config.outputPath, 'lib', 'main.dart'));
    await file.create(recursive: true);
    await file.writeAsString(finalContent);
  }

  Future<void> _generateApiConfig(ProjectConfig config) async {
    final content = '''
/// Configuración de la API REST
class ApiConfig {
  static const String baseUrl = '${config.baseUrl}';
  static const Duration timeout = Duration(seconds: 30);
}
''';

    final file = File(path.join(config.outputPath, 'lib', 'config', 'api_config.dart'));
    await file.create(recursive: true);
    await file.writeAsString(content);
  }

  Future<void> _generateHttpService(ProjectConfig config) async {
    final content = '''
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
            Uri.parse('\$_baseUrl\$endpoint'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error: \${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en GET: \$e');
    }
  }

  /// POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse('\$_baseUrl\$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(data),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Error: \${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en POST: \$e');
    }
  }

  /// PUT request
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http
          .put(
            Uri.parse('\$_baseUrl\$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(data),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error: \${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en PUT: \$e');
    }
  }

  /// DELETE request
  Future<void> delete(String endpoint) async {
    try {
      final response = await http
          .delete(
            Uri.parse('\$_baseUrl\$endpoint'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error: \${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en DELETE: \$e');
    }
  }
}
''';

    final file = File(path.join(config.outputPath, 'lib', 'services', 'http_service.dart'));
    await file.create(recursive: true);
    await file.writeAsString(content);
  }

  Future<void> _generateReadme(ProjectConfig config) async {
    final content = '''
# ${config.projectName}

Proyecto Flutter generado automáticamente con arquitectura MVC.

## 🚀 Características

- ✅ Arquitectura MVC (Modelo-Vista-Controlador)
- ✅ Conexión REST API con Spring Boot
- ✅ CRUD completo para todas las entidades
- ✅ State management con Provider
- ✅ Interfaz de usuario Material Design

## 📋 Entidades

${config.entities.map((e) => '- ${e.className}').join('\n')}

## ⚙️ Configuración

### URL del Backend

Editar `lib/config/api_config.dart`:

```dart
static const String baseUrl = '${config.baseUrl}';
```

## 🏃‍♂️ Ejecutar

```bash
flutter pub get
flutter run
```

## 📁 Estructura del Proyecto

```
lib/
├── config/           # Configuración de la API
├── controllers/      # Controladores MVC
├── models/          # Modelos de datos
├── services/        # Servicios HTTP
└── views/           # Vistas y formularios
```

## 🔌 Endpoints del Backend

Cada entidad tiene los siguientes endpoints:

- GET    /api/{entity}       - Listar todos
- GET    /api/{entity}/{id}  - Obtener por ID
- POST   /api/{entity}       - Crear nuevo
- PUT    /api/{entity}/{id}  - Actualizar
- DELETE /api/{entity}/{id}  - Eliminar

---
Generado automáticamente por Flutter MVC Generator
''';

    final file = File(path.join(config.outputPath, 'README.md'));
    await file.writeAsString(content);
  }

  bool _isNumericType(String type) {
    return type == 'int' || type == 'double' || type == 'num';
  }

  String _toSnakeCase(String text) {
    return text
        .replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)}')
        .toLowerCase()
        .replaceAll(RegExp(r'^_'), '');
  }

  String _toCamelCase(String text) {
    if (text.isEmpty) return text;
    
    // Convertir snake_case a camelCase primero
    if (text.contains('_')) {
      text = text.split('_').asMap().entries.map((entry) {
        if (entry.key == 0) {
          return entry.value.toLowerCase();
        }
        return entry.value[0].toUpperCase() + entry.value.substring(1).toLowerCase();
      }).join('');
    }
    
    // Detectar palabras compuestas en PascalCase y convertir a camelCase
    // Ejemplos: Idcliente → idCliente, IdCliente → idCliente, Fechainicio → fechaInicio
    final patterns = {
      r'^Id([a-z])': (Match m) => 'id${m.group(1)!.toUpperCase()}', // Idcliente → idCliente
      r'^Fecha([a-z])': (Match m) => 'fecha${m.group(1)!.toUpperCase()}', // Fechainicio → fechaInicio
      r'^Nombre([a-z])': (Match m) => 'nombre${m.group(1)!.toUpperCase()}',
      r'^Codigo([a-z])': (Match m) => 'codigo${m.group(1)!.toUpperCase()}',
      r'^Precio([a-z])': (Match m) => 'precio${m.group(1)!.toUpperCase()}',
      r'^Tipo([a-z])': (Match m) => 'tipo${m.group(1)!.toUpperCase()}',
    };
    
    for (var pattern in patterns.entries) {
      final regex = RegExp(pattern.key);
      final match = regex.firstMatch(text);
      if (match != null) {
        final prefix = pattern.value(match);
        final rest = text.substring(match.end);
        return prefix + rest;
      }
    }
    
    // Por defecto, solo convertir primera letra a minúscula
    return text[0].toLowerCase() + text.substring(1);
  }
}

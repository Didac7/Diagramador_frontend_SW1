import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/entity_model.dart';
import 'sql_parser_service.dart';
import 'image_ocr_service.dart';

/// Servicio para interpretar diferentes tipos de entrada
class InputInterpreterService {
  final SqlParserService _sqlParser = SqlParserService();
  final ImageOcrService _imageOcr = ImageOcrService();

  /// Interpreta una imagen (diagrama de clases)
  Future<List<EntityModel>> interpretImage(String imagePath) async {
    try {
      // Usar OCR para extraer texto de la imagen
      final extractedText = await _imageOcr.extractText(imagePath);
      
      debugPrint('=== OCR TEXTO EXTRAÍDO ===');
      debugPrint(extractedText);
      debugPrint('=== FIN TEXTO OCR (${extractedText.length} caracteres) ===');
      
      // Intentar interpretar el texto extraído
      final entities = await _parseExtractedText(extractedText);
      
      debugPrint('=== ENTIDADES ENCONTRADAS: ${entities.length} ===');
      for (var entity in entities) {
        debugPrint('- ${entity.name} con ${entity.attributes.length} atributos');
        for (var attr in entity.attributes) {
          debugPrint('  * ${attr.name}: ${attr.type}');
        }
      }
      
      return entities;
    } catch (e) {
      debugPrint('Error interpretando imagen: $e');
      return [];
    }
  }

  /// Interpreta un prompt de texto
  Future<List<EntityModel>> interpretTextPrompt(String prompt) async {
    try {
      return await _parseNaturalLanguage(prompt);
    } catch (e) {
      debugPrint('Error interpretando prompt: $e');
      return [];
    }
  }

  /// Transcribe y procesa audio
  Future<String> transcribeAudio(String audioPath) async {
    // Simulación - en producción usar speech_to_text
    // Por ahora retornamos un ejemplo
    return 'Sistema de gestión con entidades: Usuario, Producto, Pedido';
  }

  /// Interpreta un archivo SQL
  Future<List<EntityModel>> interpretSqlFile(String sqlFilePath) async {
    try {
      final file = File(sqlFilePath);
      final sqlContent = await file.readAsString();
      return await _sqlParser.parseSql(sqlContent);
    } catch (e) {
      debugPrint('Error leyendo archivo SQL: $e');
      return [];
    }
  }

  /// Interpreta contenido SQL directo (para web)
  Future<List<EntityModel>> interpretSqlContent(String sqlContent) async {
    try {
      return await _sqlParser.parseSql(sqlContent);
    } catch (e) {
      debugPrint('Error parseando SQL: $e');
      return [];
    }
  }

  /// Parsea texto extraído de imagen (OCR)
  /// Mejorado para reconocer diagramas UML con clases y atributos
  Future<List<EntityModel>> _parseExtractedText(String text) async {
    final entities = <EntityModel>[];
    
    debugPrint('>>> Iniciando parseo de texto...');
    
    // Buscar patrones comunes de diagramas de clases UML
    final lines = text.split('\n');
    debugPrint('>>> Total de líneas: ${lines.length}');
    
    String? currentEntity;
    List<AttributeModel> currentAttributes = [];
    
    // Regex para detectar nombres de clases (palabras capitalizadas)
    final classNameRegex = RegExp(r'^[+\-#~]?\s*([A-Z][a-zA-Z0-9_]*)\s*$');
    // Regex para atributos: nombre: tipo o +nombre: tipo
    final attributeRegex1 = RegExp(r'^[+\-#~]?\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*[:]\s*([a-zA-Z_][a-zA-Z0-9_<>\[\]]*)', caseSensitive: false);
    // Regex para atributos: tipo nombre
    final attributeRegex2 = RegExp(r'^[+\-#~]?\s*([a-zA-Z_][a-zA-Z0-9_<>\[\]]*)\s+([a-zA-Z_][a-zA-Z0-9_]*)', caseSensitive: false);
    
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i].trim();
      
      debugPrint('>>> Línea $i: "$line"');
      
      if (line.isEmpty) {
        debugPrint('    -> Línea vacía, saltando');
        continue;
      }
      
      // Ignorar líneas de separación UML (---, ___, |)
      if (line.startsWith('---') || line.startsWith('___') || line == '|' || line.startsWith('===')) {
        debugPrint('    -> Separador UML, saltando');
        continue;
      }
      
      // Detectar "class Nombre", "Class Nombre", "entity Nombre", etc.
      if (line.toLowerCase().contains(RegExp(r'\b(class|entity|table)\s+[A-Z]'))) {
        debugPrint('    -> Detectada clase con keyword');
        if (currentEntity != null && currentAttributes.isNotEmpty) {
          entities.add(EntityModel(
            name: currentEntity,
            attributes: List.from(currentAttributes),
          ));
          debugPrint('    -> Guardada entidad anterior: $currentEntity con ${currentAttributes.length} atributos');
        }
        
        // Extraer el nombre de la clase
        final match = RegExp(r'\b(?:class|entity|table)\s+([A-Z][a-zA-Z0-9_]*)', caseSensitive: false).firstMatch(line);
        if (match != null) {
          currentEntity = match.group(1)!;
          currentAttributes = [];
          debugPrint('    -> Nueva entidad: $currentEntity');
        }
        continue;
      }
      
      // Detectar nombres de clase UML (palabra capitalizada sola en una línea)
      final classMatch = classNameRegex.firstMatch(line);
      if (classMatch != null) {
        final possibleClassName = classMatch.group(1)!;
        
        // Verificar que no sea un tipo común de datos
        if (!_isCommonType(possibleClassName)) {
          if (currentEntity != null && currentAttributes.isNotEmpty) {
            entities.add(EntityModel(
              name: currentEntity,
              attributes: List.from(currentAttributes),
            ));
          }
          
          currentEntity = possibleClassName;
          currentAttributes = [];
          continue;
        }
      }
      
      // Si estamos dentro de una clase, buscar atributos
      if (currentEntity != null) {
        // Formato 1: "nombre: String", "+id: int", "- precio: double"
        final attrMatch1 = attributeRegex1.firstMatch(line);
        if (attrMatch1 != null) {
          final attrName = attrMatch1.group(1)!.trim();
          final attrType = attrMatch1.group(2)!.trim();
          
          if (!_isCommonType(attrName)) { // El nombre no debe ser un tipo
            currentAttributes.add(AttributeModel(
              name: attrName,
              type: _normalizeType(attrType),
              isNullable: false,
            ));
            continue;
          }
        }
        
        // Formato 2: "String nombre", "int id", "+ double precio"
        final attrMatch2 = attributeRegex2.firstMatch(line);
        if (attrMatch2 != null) {
          final firstWord = attrMatch2.group(1)!.trim();
          final secondWord = attrMatch2.group(2)!.trim();
          
          String attrName, attrType;
          
          // Determinar cuál es el tipo y cuál el nombre
          if (_isCommonType(firstWord)) {
            attrType = firstWord;
            attrName = secondWord;
          } else if (_isCommonType(secondWord)) {
            attrName = firstWord;
            attrType = secondWord;
          } else {
            // Si ninguno es tipo conocido, asumir que primero es tipo
            attrType = firstWord;
            attrName = secondWord;
          }
          
          currentAttributes.add(AttributeModel(
            name: attrName,
            type: _normalizeType(attrType),
            isNullable: false,
          ));
          continue;
        }
        
        // Detectar fin de clase (}, hereda, extends, etc.)
        if (line.startsWith('}') || 
            line.toLowerCase().contains('hereda') || 
            line.toLowerCase().contains('extends') ||
            line.toLowerCase().contains('implements')) {
          if (currentAttributes.isNotEmpty) {
            entities.add(EntityModel(
              name: currentEntity,
              attributes: List.from(currentAttributes),
            ));
            currentEntity = null;
            currentAttributes = [];
          }
        }
      }
    }
    
    // Agregar última entidad si existe
    if (currentEntity != null && currentAttributes.isNotEmpty) {
      entities.add(EntityModel(
        name: currentEntity,
        attributes: currentAttributes,
      ));
    }
    
    return entities;
  }
  
  /// Verifica si una palabra es un tipo de datos común
  bool _isCommonType(String word) {
    final commonTypes = {
      'string', 'int', 'integer', 'double', 'float', 'bool', 'boolean',
      'date', 'datetime', 'timestamp', 'long', 'short', 'byte', 'char',
      'varchar', 'text', 'decimal', 'numeric', 'real', 'list', 'array',
      'map', 'object', 'void', 'any', 'bigint', 'number'
    };
    return commonTypes.contains(word.toLowerCase());
  }
  
  /// Normaliza tipos de datos a tipos Dart
  String _normalizeType(String type) {
    final lowerType = type.toLowerCase();
    
    // Mapeo de tipos comunes a tipos Dart
    if (lowerType.contains('string') || lowerType.contains('text') || 
        lowerType.contains('varchar') || lowerType.contains('char')) {
      return 'String';
    }
    if (lowerType.contains('int') || lowerType.contains('integer') || 
        lowerType.contains('serial') || lowerType.contains('bigint')) {
      return 'int';
    }
    if (lowerType.contains('double') || lowerType.contains('float') || 
        lowerType.contains('decimal') || lowerType.contains('numeric') || 
        lowerType.contains('real') || lowerType.contains('number')) {
      return 'double';
    }
    if (lowerType.contains('bool') || lowerType.contains('boolean')) {
      return 'bool';
    }
    if (lowerType.contains('date') || lowerType.contains('time')) {
      return 'DateTime';
    }
    
    // Si ya es un tipo Dart válido, retornarlo capitalizado
    if (['String', 'int', 'double', 'bool', 'DateTime'].contains(type)) {
      return type;
    }
    
    // Por defecto, asumir String
    return 'String';
  }

  /// Parsea lenguaje natural para extraer entidades
  /// Formatos soportados:
  /// - "Persona con nombre tipo String, ci tipo int"
  /// - "Proveedor hereda de Persona con nit tipo int"
  /// - "Usuario (nombre, email, password)"
  Future<List<EntityModel>> _parseNaturalLanguage(String prompt) async {
    final entities = <EntityModel>[];
    
    debugPrint('>>> Parseando lenguaje natural...');
    
    // Dividir por líneas o puntos
    final lines = prompt.split(RegExp(r'\n|\.(?=\s*[A-Z])'));
    
    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;
      
      debugPrint('>>> Procesando línea: "$line"');
      
      // Formato: "NombreEntidad con attr1 tipo Type1, attr2 tipo Type2"
      // o "NombreEntidad hereda de Padre con attr1 tipo Type1"
      final entity = _parseEntityLine(line);
      if (entity != null) {
        entities.add(entity);
        debugPrint('    -> Entidad agregada: ${entity.name} con ${entity.attributes.length} atributos');
      }
    }
    
    debugPrint('>>> Total entidades parseadas: ${entities.length}');
    return entities;
  }

  EntityModel? _parseEntityLine(String line) {
    // Regex para capturar: NombreEntidad [hereda de Padre] con attr1 tipo Type1, attr2 tipo Type2
    final regex = RegExp(
      r'^([A-Z][a-zA-Z0-9_]*)\s*(?:hereda de ([A-Z][a-zA-Z0-9_]*))?\s*con\s+(.+)$',
      caseSensitive: false
    );
    
    final match = regex.firstMatch(line);
    if (match != null) {
      final entityName = match.group(1)!;
      final parentName = match.group(2); // puede ser null
      final attributesText = match.group(3)!;
      
      debugPrint('    -> Entidad: $entityName${parentName != null ? ' (hereda de $parentName)' : ''}');
      
      // Parsear atributos: "nombre tipo String, ci tipo int"
      final attributes = _parseAttributes(attributesText);
      
      // Agregar ID si no existe
      if (!attributes.any((a) => a.name.toLowerCase() == 'id')) {
        attributes.insert(0, AttributeModel(
          name: 'id',
          type: 'int',
          isPrimaryKey: true,
          isNullable: false,
        ));
      }
      
      return EntityModel(
        name: entityName,
        attributes: attributes,
      );
    }
    
    // Formato alternativo: "NombreEntidad (attr1, attr2, attr3)"
    final regex2 = RegExp(r'^([A-Z][a-zA-Z0-9_]*)\s*\(([^)]+)\)$');
    final match2 = regex2.firstMatch(line);
    if (match2 != null) {
      final entityName = match2.group(1)!;
      final attributesText = match2.group(2)!;
      
      final attrNames = attributesText.split(',').map((e) => e.trim()).toList();
      final attributes = <AttributeModel>[
        AttributeModel(name: 'id', type: 'int', isPrimaryKey: true, isNullable: false),
      ];
      
      for (var attrName in attrNames) {
        if (attrName.isNotEmpty) {
          attributes.add(AttributeModel(
            name: attrName,
            type: 'String',
            isNullable: false,
          ));
        }
      }
      
      return EntityModel(name: entityName, attributes: attributes);
    }
    
    return null;
  }

  List<AttributeModel> _parseAttributes(String attributesText) {
    final attributes = <AttributeModel>[];
    
    // Dividir por comas
    final attrParts = attributesText.split(',');
    
    for (var part in attrParts) {
      part = part.trim();
      if (part.isEmpty) continue;
      
      // Formato: "nombre tipo String" o "ci tipo int"
      final attrMatch = RegExp(r'^([a-zA-Z_][a-zA-Z0-9_]*)\s+tipo\s+([a-zA-Z_][a-zA-Z0-9_]*)', caseSensitive: false).firstMatch(part);
      
      if (attrMatch != null) {
        final attrName = attrMatch.group(1)!;
        final attrType = attrMatch.group(2)!;
        
        debugPrint('      * $attrName: ${_normalizeType(attrType)}');
        
        attributes.add(AttributeModel(
          name: attrName,
          type: _normalizeType(attrType),
          isNullable: false,
        ));
      } else {
        // Formato simple: solo nombre (sin "tipo")
        final simpleName = part.replaceAll(RegExp(r'\s+tipo\s+'), ' ').trim().split(' ')[0];
        if (simpleName.isNotEmpty && !_isCommonType(simpleName)) {
          attributes.add(AttributeModel(
            name: simpleName,
            type: 'String',
            isNullable: false,
          ));
        }
      }
    }
    
    return attributes;
  }
}

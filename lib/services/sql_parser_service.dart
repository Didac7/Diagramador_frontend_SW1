import '../models/entity_model.dart';
import 'package:flutter/foundation.dart';

/// Servicio para parsear archivos SQL y extraer entidades
class SqlParserService {
  /// Parsea un archivo SQL y extrae las entidades
  Future<List<EntityModel>> parseSql(String sqlContent) async {
    final entities = <EntityModel>[];
    
    try {
      // Separar por CREATE TABLE
      final tables = _extractCreateTableStatements(sqlContent);
      
      for (var tableStatement in tables) {
        final entity = _parseCreateTable(tableStatement);
        if (entity != null) {
          entities.add(entity);
        }
      }
    } catch (e) {
      debugPrint('Error parseando SQL: $e');
    }
    
    return entities;
  }

  List<String> _extractCreateTableStatements(String sql) {
    final statements = <String>[];
    final regex = RegExp(
      r'CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?(\w+)\s*\((.*?)\);',
      caseSensitive: false,
      multiLine: true,
      dotAll: true,
    );
    
    final matches = regex.allMatches(sql);
    for (var match in matches) {
      statements.add(match.group(0)!);
    }
    
    return statements;
  }

  EntityModel? _parseCreateTable(String statement) {
    try {
      // Extraer nombre de tabla
      final nameRegex = RegExp(
        r'CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?`?(\w+)`?',
        caseSensitive: false,
      );
      final nameMatch = nameRegex.firstMatch(statement);
      
      if (nameMatch == null) return null;
      
      final tableName = nameMatch.group(1)!;
      
      // Extraer columnas
      final columnsRegex = RegExp(
        r'\((.*)\)',
        multiLine: true,
        dotAll: true,
      );
      final columnsMatch = columnsRegex.firstMatch(statement);
      
      if (columnsMatch == null) return null;
      
      final columnsSection = columnsMatch.group(1)!;
      final attributes = _parseColumns(columnsSection);
      
      // Extraer relaciones (FOREIGN KEY)
      final relationships = _parseRelationships(columnsSection);
      
      return EntityModel(
        name: _toCamelCase(tableName),
        attributes: attributes,
        relationships: relationships,
      );
    } catch (e) {
      debugPrint('Error parseando tabla: $e');
      return null;
    }
  }

  List<AttributeModel> _parseColumns(String columnsSection) {
    final attributes = <AttributeModel>[];
    
    // Dividir por comas (cuidado con los paréntesis)
    final lines = _splitColumns(columnsSection);
    
    for (var line in lines) {
      line = line.trim();
      
      // Ignorar constraints que no son columnas
      if (line.toUpperCase().startsWith('PRIMARY KEY') ||
          line.toUpperCase().startsWith('FOREIGN KEY') ||
          line.toUpperCase().startsWith('CONSTRAINT') ||
          line.toUpperCase().startsWith('UNIQUE') ||
          line.toUpperCase().startsWith('INDEX') ||
          line.toUpperCase().startsWith('KEY')) {
        continue;
      }
      
      final attribute = _parseColumn(line);
      if (attribute != null) {
        attributes.add(attribute);
      }
    }
    
    return attributes;
  }

  List<String> _splitColumns(String columnsSection) {
    final columns = <String>[];
    final buffer = StringBuffer();
    int parenthesisLevel = 0;
    
    for (var i = 0; i < columnsSection.length; i++) {
      final char = columnsSection[i];
      
      if (char == '(') {
        parenthesisLevel++;
      } else if (char == ')') {
        parenthesisLevel--;
      } else if (char == ',' && parenthesisLevel == 0) {
        columns.add(buffer.toString().trim());
        buffer.clear();
        continue;
      }
      
      buffer.write(char);
    }
    
    if (buffer.isNotEmpty) {
      columns.add(buffer.toString().trim());
    }
    
    return columns;
  }

  AttributeModel? _parseColumn(String columnDef) {
    try {
      final parts = columnDef.trim().split(RegExp(r'\s+'));
      
      if (parts.length < 2) return null;
      
      final columnName = parts[0].replaceAll('`', '');
      final columnType = parts[1].toUpperCase();
      
      // Determinar si es nullable
      final isNullable = !columnDef.toUpperCase().contains('NOT NULL');
      
      // Determinar si es primary key
      final isPrimaryKey = columnDef.toUpperCase().contains('PRIMARY KEY') ||
          columnDef.toUpperCase().contains('AUTO_INCREMENT');
      
      // Obtener valor por defecto
      String? defaultValue;
      final defaultPattern = r'DEFAULT\s+(\S+)';
      final defaultRegex = RegExp(defaultPattern, caseSensitive: false);
      final defaultMatch = defaultRegex.firstMatch(columnDef);
      if (defaultMatch != null) {
        defaultValue = defaultMatch.group(1);
      }
      
      return AttributeModel(
        name: _toCamelCase(columnName),
        type: columnType,
        isNullable: isNullable,
        isPrimaryKey: isPrimaryKey,
        defaultValue: defaultValue,
      );
    } catch (e) {
      debugPrint('Error parseando columna: $e');
      return null;
    }
  }

  List<RelationshipModel> _parseRelationships(String columnsSection) {
    final relationships = <RelationshipModel>[];
    
    final fkRegex = RegExp(
      r'FOREIGN\s+KEY\s*\(`?(\w+)`?\)\s*REFERENCES\s+`?(\w+)`?',
      caseSensitive: false,
    );
    
    final matches = fkRegex.allMatches(columnsSection);
    for (var match in matches) {
      final foreignKey = match.group(1)!;
      final referencedTable = match.group(2)!;
      
      relationships.add(RelationshipModel(
        targetEntity: _toCamelCase(referencedTable),
        type: RelationType.manyToOne,
        foreignKey: foreignKey,
      ));
    }
    
    return relationships;
  }

  String _toCamelCase(String text) {
    // Convertir snake_case a CamelCase
    final parts = text.split('_');
    return parts
        .map((part) => part.isEmpty ? '' : part[0].toUpperCase() + part.substring(1).toLowerCase())
        .join('');
  }
}

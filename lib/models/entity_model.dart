/// Modelo que representa una entidad del sistema
class EntityModel {
  final String name;
  final List<AttributeModel> attributes;
  final List<RelationshipModel> relationships;
  final bool hasId;

  EntityModel({
    required this.name,
    required this.attributes,
    this.relationships = const [],
    this.hasId = true,
  });

  factory EntityModel.fromJson(Map<String, dynamic> json) {
    return EntityModel(
      name: json['name'] as String,
      attributes: (json['attributes'] as List)
          .map((attr) => AttributeModel.fromJson(attr))
          .toList(),
      relationships: (json['relationships'] as List? ?? [])
          .map((rel) => RelationshipModel.fromJson(rel))
          .toList(),
      hasId: json['hasId'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'attributes': attributes.map((a) => a.toJson()).toList(),
      'relationships': relationships.map((r) => r.toJson()).toList(),
      'hasId': hasId,
    };
  }

  String get className => _capitalize(name);
  String get variableName => _uncapitalize(name);
  String get pluralName => '${name}s';

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _uncapitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toLowerCase() + text.substring(1);
  }
}

/// Modelo que representa un atributo de una entidad
class AttributeModel {
  final String name;
  final String type;
  final bool isNullable;
  final bool isPrimaryKey;
  final String? defaultValue;

  AttributeModel({
    required this.name,
    required this.type,
    this.isNullable = false,
    this.isPrimaryKey = false,
    this.defaultValue,
  });

  factory AttributeModel.fromJson(Map<String, dynamic> json) {
    return AttributeModel(
      name: json['name'] as String,
      type: json['type'] as String,
      isNullable: json['isNullable'] as bool? ?? false,
      isPrimaryKey: json['isPrimaryKey'] as bool? ?? false,
      defaultValue: json['defaultValue'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'isNullable': isNullable,
      'isPrimaryKey': isPrimaryKey,
      'defaultValue': defaultValue,
    };
  }

  String get dartType => _sqlTypeToDartType(type);

  String _sqlTypeToDartType(String sqlType) {
    final upperType = sqlType.toUpperCase();
    if (upperType.contains('SERIAL')) return 'int'; // PostgreSQL auto-increment
    if (upperType.contains('INT')) return 'int';
    if (upperType.contains('BIGINT')) return 'int';
    if (upperType.contains('DECIMAL') || upperType.contains('NUMERIC') || upperType.contains('FLOAT') || upperType.contains('DOUBLE')) {
      return 'double';
    }
    if (upperType.contains('BOOL')) return 'bool';
    if (upperType.contains('DATE') || upperType.contains('TIME')) return 'DateTime';
    return 'String';
  }
}

/// Modelo que representa una relación entre entidades
class RelationshipModel {
  final String targetEntity;
  final RelationType type;
  final String? foreignKey;

  RelationshipModel({
    required this.targetEntity,
    required this.type,
    this.foreignKey,
  });

  factory RelationshipModel.fromJson(Map<String, dynamic> json) {
    return RelationshipModel(
      targetEntity: json['targetEntity'] as String,
      type: RelationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => RelationType.oneToMany,
      ),
      foreignKey: json['foreignKey'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targetEntity': targetEntity,
      'type': type.name,
      'foreignKey': foreignKey,
    };
  }
}

enum RelationType {
  oneToOne,
  oneToMany,
  manyToOne,
  manyToMany,
}

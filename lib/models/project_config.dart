import 'entity_model.dart';

/// Configuración del proyecto generado
class ProjectConfig {
  final String projectName;
  final String baseUrl;
  final List<EntityModel> entities;
  final String outputPath;

  ProjectConfig({
    required this.projectName,
    required this.baseUrl,
    required this.entities,
    required this.outputPath,
  });

  factory ProjectConfig.fromJson(Map<String, dynamic> json) {
    return ProjectConfig(
      projectName: json['projectName'] as String,
      baseUrl: json['baseUrl'] as String,
      entities: (json['entities'] as List)
          .map((e) => EntityModel.fromJson(e))
          .toList(),
      outputPath: json['outputPath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectName': projectName,
      'baseUrl': baseUrl,
      'entities': entities.map((e) => e.toJson()).toList(),
      'outputPath': outputPath,
    };
  }
}

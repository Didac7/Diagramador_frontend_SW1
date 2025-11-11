/// Modelo para la entidad ArchInventario
class ArchInventario {
  final int id;
  final String descripcion;
  final DateTime fecha;

  ArchInventario({
    required this.id,
    required this.descripcion,
    required this.fecha,
  });

  factory ArchInventario.fromJson(Map<String, dynamic> json) {
    return ArchInventario(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      descripcion: json['descripcion']?.toString() ?? '',
      fecha: DateTime.tryParse(json['fecha']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(),
    };
  }
}

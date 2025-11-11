/// Modelo para la entidad Inventario
class Inventario {
  final int id;
  final int cantidad;
  final DateTime fechaIngreso;

  Inventario({
    required this.id,
    required this.cantidad,
    required this.fechaIngreso,
  });

  factory Inventario.fromJson(Map<String, dynamic> json) {
    return Inventario(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      cantidad: int.tryParse(json['cantidad']?.toString() ?? '') ?? 0,
      fechaIngreso: DateTime.tryParse(json['fechaIngreso']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cantidad': cantidad,
      'fechaIngreso': fechaIngreso.toIso8601String(),
    };
  }
}

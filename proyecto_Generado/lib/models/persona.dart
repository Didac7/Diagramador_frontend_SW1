/// Modelo para la entidad Persona
class Persona {
  final int id;
  final String nombre;
  final int ci;

  Persona({
    required this.id,
    required this.nombre,
    required this.ci,
  });

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      nombre: json['nombre']?.toString() ?? '',
      ci: int.tryParse(json['ci']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'ci': ci,
    };
  }
}

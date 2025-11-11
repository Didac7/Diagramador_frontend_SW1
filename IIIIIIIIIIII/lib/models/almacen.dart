/// Modelo para la entidad Almacen
class Almacen {
  final int id;
  final String nombre;
  final String ubicacion;

  Almacen({
    required this.id,
    required this.nombre,
    required this.ubicacion,
  });

  factory Almacen.fromJson(Map<String, dynamic> json) {
    return Almacen(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      nombre: json['nombre']?.toString() ?? '',
      ubicacion: json['ubicacion']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'ubicacion': ubicacion,
    };
  }
}

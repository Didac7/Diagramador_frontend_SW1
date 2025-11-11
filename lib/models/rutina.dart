/// Modelo para la entidad Rutina
class Rutina {
  final String? Idrutina;
  final String Nombre;
  final String? Descripcion;
  final String? Duracion;
  final int? Identrenador;

  Rutina({
    this.Idrutina,
    required this.Nombre,
    this.Descripcion,
    this.Duracion,
    this.Identrenador,
  });

  factory Rutina.fromJson(Map<String, dynamic> json) {
    return Rutina(
      Idrutina: json['Idrutina']?.toString(),
      Nombre: json['Nombre']?.toString() ?? '',
      Descripcion: json['Descripcion']?.toString(),
      Duracion: json['Duracion']?.toString(),
      Identrenador: json['Identrenador'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Idrutina': Idrutina,
      'Nombre': Nombre,
      'Descripcion': Descripcion,
      'Duracion': Duracion,
      'Identrenador': Identrenador,
    };
  }
}

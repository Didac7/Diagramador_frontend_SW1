/// Modelo para la entidad Entrenador
class Entrenador {
  final String? Identrenador;
  final String Nombre;
  final int? Edad;
  final String? Genero;
  final String? Especialidad;

  Entrenador({
    this.Identrenador,
    required this.Nombre,
    this.Edad,
    this.Genero,
    this.Especialidad,
  });

  factory Entrenador.fromJson(Map<String, dynamic> json) {
    return Entrenador(
      Identrenador: json['Identrenador']?.toString(),
      Nombre: json['Nombre']?.toString() ?? '',
      Edad: json['Edad'] as int?,
      Genero: json['Genero']?.toString(),
      Especialidad: json['Especialidad']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Identrenador': Identrenador,
      'Nombre': Nombre,
      'Edad': Edad,
      'Genero': Genero,
      'Especialidad': Especialidad,
    };
  }
}

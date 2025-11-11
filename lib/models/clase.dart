/// Modelo para la entidad Clase
class Clase {
  final String? Idclase;
  final String Nombre;
  final DateTime? HoraInicio;
  final DateTime? HoraFin;
  final String? DiasSemana;
  final int? Identrenador;

  Clase({
    this.Idclase,
    required this.Nombre,
    this.HoraInicio,
    this.HoraFin,
    this.DiasSemana,
    this.Identrenador,
  });

  factory Clase.fromJson(Map<String, dynamic> json) {
    return Clase(
      Idclase: json['Idclase']?.toString(),
      Nombre: json['Nombre']?.toString() ?? '',
      HoraInicio: json['HoraInicio'] != null ? DateTime.tryParse(json['HoraInicio'].toString()) : null,
      HoraFin: json['HoraFin'] != null ? DateTime.tryParse(json['HoraFin'].toString()) : null,
      DiasSemana: json['DiasSemana']?.toString(),
      Identrenador: json['Identrenador'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Idclase': Idclase,
      'Nombre': Nombre,
      'HoraInicio': HoraInicio,
      'HoraFin': HoraFin,
      'DiasSemana': DiasSemana,
      'Identrenador': Identrenador,
    };
  }
}

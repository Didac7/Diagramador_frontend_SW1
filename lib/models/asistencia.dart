/// Modelo para la entidad Asistencia
class Asistencia {
  final String? Idasistencia;
  final DateTime Fecha;
  final String? Estado;
  final int? Idcliente;

  Asistencia({
    this.Idasistencia,
    required this.Fecha,
    this.Estado,
    this.Idcliente,
  });

  factory Asistencia.fromJson(Map<String, dynamic> json) {
    return Asistencia(
      Idasistencia: json['Idasistencia']?.toString(),
      Fecha: json['Fecha'] != null ? DateTime.tryParse(json['Fecha'].toString()) ?? DateTime.now() : DateTime.now(),
      Estado: json['Estado']?.toString(),
      Idcliente: json['Idcliente'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Idasistencia': Idasistencia,
      'Fecha': Fecha,
      'Estado': Estado,
      'Idcliente': Idcliente,
    };
  }
}

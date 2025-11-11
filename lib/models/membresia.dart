/// Modelo para la entidad Membresia
class Membresia {
  final String? Idmembresia;
  final String? Tipo;
  final double? Monto;
  final String? Duracion;
  final int? Idcliente;

  Membresia({
    this.Idmembresia,
    this.Tipo,
    this.Monto,
    this.Duracion,
    this.Idcliente,
  });

  factory Membresia.fromJson(Map<String, dynamic> json) {
    return Membresia(
      Idmembresia: json['Idmembresia']?.toString(),
      Tipo: json['Tipo']?.toString(),
      Monto: json['Monto'] != null ? (json['Monto'] as num).toDouble() : null,
      Duracion: json['Duracion']?.toString(),
      Idcliente: json['Idcliente'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Idmembresia': Idmembresia,
      'Tipo': Tipo,
      'Monto': Monto,
      'Duracion': Duracion,
      'Idcliente': Idcliente,
    };
  }
}

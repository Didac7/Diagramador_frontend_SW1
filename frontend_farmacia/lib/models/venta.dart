/// Modelo para la entidad Venta
class Venta {
  final int? idVenta;
  final DateTime fecha;
  final double total;
  final int? clienteId;

  Venta({
    this.idVenta,
    required this.fecha,
    required this.total,
    this.clienteId,
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      idVenta: json['idVenta'] != null ? int.tryParse(json['idVenta'].toString()) : null,
      fecha: DateTime.tryParse(json['fecha']?.toString() ?? '') ?? DateTime.now(),
      total: double.tryParse(json['total']?.toString() ?? '') ?? 0.0,
      clienteId: json['clienteId'] != null ? int.tryParse(json['clienteId'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idVenta': idVenta,
      'fecha': fecha.toIso8601String(),
      'total': total,
      'clienteId': clienteId,
    };
  }
}

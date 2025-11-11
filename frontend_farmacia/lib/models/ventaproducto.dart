/// Modelo para la entidad Ventaproducto
class Ventaproducto {
  final int? ventaId;
  final int? productoId;
  final int cantidad;
  final double subtotal;

  Ventaproducto({
    this.ventaId,
    this.productoId,
    required this.cantidad,
    required this.subtotal,
  });

  factory Ventaproducto.fromJson(Map<String, dynamic> json) {
    return Ventaproducto(
      ventaId: json['ventaId'] != null ? int.tryParse(json['ventaId'].toString()) : null,
      productoId: json['productoId'] != null ? int.tryParse(json['productoId'].toString()) : null,
      cantidad: int.tryParse(json['cantidad']?.toString() ?? '') ?? 0,
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ventaId': ventaId,
      'productoId': productoId,
      'cantidad': cantidad,
      'subtotal': subtotal,
    };
  }
}

/// Modelo para la entidad Producto
class Producto {
  final int? idProducto;
  final String nombre;
  final double precio;
  final int stock;
  final int? proveedorId;

  Producto({
    this.idProducto,
    required this.nombre,
    required this.precio,
    required this.stock,
    this.proveedorId,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['idProducto'] != null ? int.tryParse(json['idProducto'].toString()) : null,
      nombre: json['nombre']?.toString() ?? '',
      precio: double.tryParse(json['precio']?.toString() ?? '') ?? 0.0,
      stock: int.tryParse(json['stock']?.toString() ?? '') ?? 0,
      proveedorId: json['proveedorId'] != null ? int.tryParse(json['proveedorId'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProducto': idProducto,
      'nombre': nombre,
      'precio': precio,
      'stock': stock,
      'proveedorId': proveedorId,
    };
  }
}

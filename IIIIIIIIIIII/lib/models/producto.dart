/// Modelo para la entidad Producto
class Producto {
  final int id;
  final String nombre;
  final double precio;
  final int stock;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      nombre: json['nombre']?.toString() ?? '',
      precio: double.tryParse(json['precio']?.toString() ?? '') ?? 0.0,
      stock: int.tryParse(json['stock']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'stock': stock,
    };
  }
}

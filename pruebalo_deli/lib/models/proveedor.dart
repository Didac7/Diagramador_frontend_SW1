/// Modelo para la entidad Proveedor
class Proveedor {
  final int? idProveedor;
  final String nombre;
  final String? telefono;
  final String? email;

  Proveedor({
    this.idProveedor,
    required this.nombre,
    this.telefono,
    this.email,
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      idProveedor: json['idProveedor'] != null ? int.tryParse(json['idProveedor'].toString()) : null,
      nombre: json['nombre']?.toString() ?? '',
      telefono: json['telefono']?.toString(),
      email: json['email']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProveedor': idProveedor,
      'nombre': nombre,
      'telefono': telefono,
      'email': email,
    };
  }
}

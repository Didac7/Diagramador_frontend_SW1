/// Modelo para la entidad Proveedor
class Proveedor {
  final int id;
  final int nit;
  final String direccion;
  final int nrotelefono;

  Proveedor({
    required this.id,
    required this.nit,
    required this.direccion,
    required this.nrotelefono,
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      nit: int.tryParse(json['nit']?.toString() ?? '') ?? 0,
      direccion: json['direccion']?.toString() ?? '',
      nrotelefono: int.tryParse(json['nrotelefono']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nit': nit,
      'direccion': direccion,
      'nrotelefono': nrotelefono,
    };
  }
}

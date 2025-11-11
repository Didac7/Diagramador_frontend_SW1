/// Modelo para la entidad Cliente
class Cliente {
  final int? idCliente;
  final String nombre;
  final String? telefono;
  final String? direccion;

  Cliente({
    this.idCliente,
    required this.nombre,
    this.telefono,
    this.direccion,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      idCliente: json['idCliente'] != null ? int.tryParse(json['idCliente'].toString()) : null,
      nombre: json['nombre']?.toString() ?? '',
      telefono: json['telefono']?.toString(),
      direccion: json['direccion']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCliente': idCliente,
      'nombre': nombre,
      'telefono': telefono,
      'direccion': direccion,
    };
  }
}

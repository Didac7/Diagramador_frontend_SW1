/// Modelo para la entidad Cliente
class Cliente {
  final int? idCliente;
  final String? nombre;
  final int? edad;
  final String? genero;
  final String? telefono;
  final String? email;

  Cliente({
    this.idCliente,
    this.nombre,
    this.edad,
    this.genero,
    this.telefono,
    this.email,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      idCliente: json['idCliente'] as int?,
      nombre: json['nombre']?.toString(),
      edad: json['edad'] != null ? (json['edad'] as num).toInt() : null,
      genero: json['genero']?.toString(),
      telefono: json['telefono']?.toString(),
      email: json['email']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCliente': idCliente,
      'nombre': nombre,
      'edad': edad,
      'genero': genero,
      'telefono': telefono,
      'email': email,
    };
  }
}

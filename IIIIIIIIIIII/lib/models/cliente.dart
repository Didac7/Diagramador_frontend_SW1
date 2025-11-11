/// Modelo para la entidad Cliente
class Cliente {
  final int id;
  final String email;

  Cliente({
    required this.id,
    required this.email,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      email: json['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
    };
  }
}

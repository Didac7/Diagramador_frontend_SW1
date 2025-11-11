/// Modelo para la entidad Vendedor
class Vendedor {
  final int id;
  final double salario;

  Vendedor({
    required this.id,
    required this.salario,
  });

  factory Vendedor.fromJson(Map<String, dynamic> json) {
    return Vendedor(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      salario: double.tryParse(json['salario']?.toString() ?? '') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salario': salario,
    };
  }
}

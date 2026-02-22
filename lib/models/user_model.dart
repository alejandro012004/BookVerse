class Usuario {
  final String nombre;
  final String email;
  final String rol;
  final DateTime createdAt;

  Usuario({
    required this.nombre,
    required this.email,
    required this.rol,
    required this.createdAt,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    nombre: json["nombre"] ?? '',
    email: json["email"] ?? '',
    rol: json["rol"] ?? 'user',
    createdAt: DateTime.parse(json["createdAt"] ?? DateTime.now().toString()),
  );
}

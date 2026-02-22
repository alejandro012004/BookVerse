import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _miFormularioKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  bool _estaCargando = false;

  void _hacerRegistro() async {
    if (_miFormularioKey.currentState!.validate()) {
      setState(() {
        _estaCargando = true;
      });

      ApiService servicio = ApiService();
      bool respuesta = await servicio.registrar(
        _nombreController.text,
        _emailController.text,
        _passController.text,
      );

      setState(() {
        _estaCargando = false;
      });

      if (respuesta == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Usuario creado correctamente!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hubo un error al registrarse')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
        backgroundColor: const Color(0xFF2C3E50),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _miFormularioKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Únete a BookVerse',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre y apellidos',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty)
                    return 'Escribe tu nombre';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty)
                    return 'Escribe un correo';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo para la contraseña
              TextFormField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña nueva',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (valor) {
                  if (valor == null || valor.length < 3) {
                    return 'La clave debe tener al menos 3 letras';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Si está cargando muestra la rueda, si no muestra el botón
              _estaCargando
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _hacerRegistro,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: const Color(0xFF2C3E50),
                      ),
                      child: const Text(
                        'Registrar mi cuenta',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

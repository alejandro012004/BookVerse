import 'package:flutter/material.dart';
import 'package:po_t5/screens/home_screen.dart';
import 'package:po_t5/screens/registro_screen.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Las llaves y controladores para el formulario
  final _formularioKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  // Variable para saber si estamos esperando al servidor
  bool _estaCargando = false;

  // Función para cuando pulsamos el botón
  void _entrar() async {
    // 1. Validar que los campos no estén vacíos
    if (_formularioKey.currentState!.validate()) {
      // 2. Mostrar la ruedita de carga
      setState(() {
        _estaCargando = true;
      });

      // 3. Llamar al servicio que hicimos
      ApiService servicio = ApiService();
      Usuario? user = await servicio.login(
        _emailController.text,
        _passController.text,
      );

      // 4. Quitar la ruedita de carga
      setState(() {
        _estaCargando = false;
      });

      // 5. Ver si nos dejó entrar o no
      if (user != null) {
        // Todo bien, vamos al inicio
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Algo salió mal, mostramos un aviso abajo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email o contraseña incorrectos')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formularioKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'BookVerse',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Campo para el Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty)
                    return 'Escribe tu correo';
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Campo para la Contraseña
              TextFormField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty)
                    return 'Escribe tu contraseña';
                  return null;
                },
              ),
              const SizedBox(height: 25),

              // Botón que cambia si está cargando
              _estaCargando
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _entrar,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: const Color(0xFF2C3E50),
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistroScreen(),
                    ),
                  );
                },
                child: const Text('Crear una cuenta nueva'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:po_t5/provider/config_provider.dart';
import 'package:po_t5/provider/libro_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Variables para guardar el nombre y el correo que sacaremos del móvil
  String nombre = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    _cargarUsuario(); // Nada más entrar, buscamos los datos guardados
  }

  // Función para leer los datos del disco duro (SharedPreferences)
  _cargarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Si no hay nada guardado, ponemos "Usuario" por defecto
      nombre = prefs.getString('nombre') ?? "Usuario";
      email = prefs.getString('email') ?? "usuario@ejemplo.com";
    });
  }

  @override
  Widget build(BuildContext context) {
    // Nos conectamos a los Providers para usar el tema oscuro y los favoritos
    final config = Provider.of<ConfigProvider>(context);
    final librosProv = Provider.of<LibrosProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Mi Perfil"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // El círculo con la inicial del nombre del usuario
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFF2C3E50),
              child: Text(
                nombre.isNotEmpty ? nombre[0].toUpperCase() : "U",
                style: const TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            const SizedBox(height: 15),
            // Mostramos el nombre y el correo debajo de la foto
            Text(
              nombre,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(email, style: const TextStyle(color: Colors.grey)),

            const Divider(height: 40),

            // Interruptor para activar o desactivar el modo oscuro
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: const Text("Modo Oscuro"),
              value: config.temaOscuro,
              onChanged: (value) {
                config.setTemaOscuro(
                  value,
                ); // Le decimos al provider que cambie el tema
              },
            ),

            const Divider(height: 20),

            // Título de la sección de favoritos
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Mis Favoritos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Lista horizontal con los libros que el usuario marcó como favoritos
            SizedBox(
              height: 200,
              child: librosProv.cargando
                  ? const Center(
                      child: CircularProgressIndicator(),
                    ) // Si está cargando, sale el circulito
                  : librosProv.misFavoritos.isEmpty
                  ? const Center(child: Text("Aún no tienes favoritos"))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: librosProv.misFavoritos.length,
                      itemBuilder: (context, index) {
                        final libro = librosProv.misFavoritos[index];
                        return Container(
                          width: 120,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    libro.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                libro.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 20),

            // Opción para resetear el Onboarding (tutorial de bienvenida)
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text("Ver bienvenida de nuevo"),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('onboarding_done', true);
                if (mounted)
                  Navigator.pushReplacementNamed(context, 'onboarding');
              },
            ),

            // Botón rojo para borrar todo y salir al Login
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear(); // Borramos el token y el nombre
                  if (mounted) Navigator.pushReplacementNamed(context, 'login');
                },
                child: const Text("Cerrar Sesión"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

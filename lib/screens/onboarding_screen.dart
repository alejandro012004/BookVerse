import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:po_t5/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // El controlador que maneja el movimiento de las páginas
  final PageController _pageController = PageController();
  int _currentPage = 0; // Para saber en qué página estamos (0, 1 o 2)

  // Los datos que se van a mostrar en cada pantalla del carrusel
  final List<Map<String, String>> _data = [
    {
      'title': 'Descubre Libros',
      'desc':
          'Explora una biblioteca infinita y encuentra tu lectura favorita.',
      'icon': '📚',
    },
    {
      'title': 'Escribe Reseñas',
      'desc': 'Comparte tus opiniones y puntúa los libros que has leído.',
      'icon': '✍️',
    },
    {
      'title': 'Comunidad',
      'desc': 'Guarda tus favoritos y comparte hallazgos con amigos.',
      'icon': '🌟',
    },
  ];

  // Esta función guarda que el usuario ya vio la bienvenida y lo manda al Login
  void finalizarOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    // Guardamos un "check" para que la próxima vez la app sepa que ya vimos esto
    await prefs.setBool('onboarding_done', true);

    if (mounted) {
      Navigator.pushReplacement(
        // Usamos Replacement para que no pueda volver atrás
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            // El PageView es lo que permite deslizar las pantallas hacia los lados
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage =
                      index; // Actualizamos el número de página actual
                });
              },
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _data[index]['icon']!,
                      style: const TextStyle(fontSize: 80),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _data[index]['title']!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        _data[index]['desc']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Parte de abajo: Indicadores (puntitos) y el botón
          Padding(
            padding: const EdgeInsets.all(40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dibujamos los puntitos de abajo
                Row(
                  children: List.generate(
                    _data.length,
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 5),
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.blue
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                // El botón para pasar de página o para terminar
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _data.length - 1) {
                      finalizarOnboarding(); // Si es la última, terminamos
                    } else {
                      _pageController.nextPage(
                        // Si no, pasamos a la siguiente
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  child: Text(
                    _currentPage == _data.length - 1 ? 'Empezar' : 'Siguiente',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

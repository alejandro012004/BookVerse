import 'package:flutter/material.dart';
import 'package:po_t5/provider/config_provider.dart';
import 'package:po_t5/provider/libro_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:po_t5/services/api_service.dart';
import 'package:po_t5/screens/home_screen.dart';
import 'package:po_t5/screens/libro_detalle_screen.dart';
import 'package:po_t5/screens/onboarding_screen.dart';
import 'package:po_t5/screens/login_screen.dart';
import 'package:po_t5/screens/profile_screen.dart';

void main() async {
  // Esto es necesario para poder usar SharedPreferences antes del runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Cargamos las preferencias grabadas en disco
  final prefs = await SharedPreferences.getInstance();

  //cargamos el token si ya existe
  final apiService = ApiService();
  await apiService.cargarToken();

  // Comprobamos estados guardado
  final bool isLoggedIn = (prefs.getString('token') ?? '').isNotEmpty;
  final bool showOnboarding = prefs.getBool('onboarding_done') ?? true;
  final bool modoOscuro = prefs.getBool('darkMode') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          //provider para la configuracion
          create: (_) => ConfigProvider(
            temaOscuro: modoOscuro,
            showOnboarding: showOnboarding,
            isLoggedIn: isLoggedIn,
          ),
        ),
        // provider de los libros, carga los datos nada más empezar
        ChangeNotifierProvider(create: (_) => LibrosProvider()..cargarTodo()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //donde tenemos la configuracion de la aplicacion
    final config = Provider.of<ConfigProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookVerse',

      // Configuramos el cambio de tema automáticamente
      themeMode: config.temaOscuro ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2C3E50),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2C3E50),
        brightness: Brightness.dark,
      ),

      // Lógica para decidir qué pantalla mostrar al abrir la app
      initialRoute: config.showOnboarding
          ? 'onboarding'
          : (config.isLoggedIn ? 'home' : 'login'),

      routes: {
        'onboarding': (context) => const OnboardingScreen(),
        'login': (context) => const LoginScreen(),
        'home': (context) => const HomeScreen(),
        'detalle': (context) => const LibroDetalleScreen(),
        'perfil': (context) => const ProfileScreen(),
      },
    );
  }
}

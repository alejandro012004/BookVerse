import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigProvider extends ChangeNotifier {
  // Variables
  bool _temaOscuro;
  bool _showOnboarding;
  bool _isLoggedIn;

  // constructor
  ConfigProvider({
    required bool temaOscuro,
    required bool showOnboarding,
    required bool isLoggedIn,
  }) : _temaOscuro = temaOscuro,
       _showOnboarding = showOnboarding,
       _isLoggedIn = isLoggedIn;

  // Getters
  bool get temaOscuro => _temaOscuro;
  bool get showOnboarding => _showOnboarding;
  bool get isLoggedIn => _isLoggedIn;

  // Función para cambiar el tema y guardarlo en el disco
  void setTemaOscuro(bool valor) async {
    _temaOscuro = valor;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', valor);
  }

  // Función para marcar que el tutorial ya se vio
  void completarOnboarding() async {
    _showOnboarding = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', false);
  }

  // Función extra para el login/cerrar sesion
  void setLoggedIn(bool valor) {
    _isLoggedIn = valor;
    notifyListeners();
  }
}

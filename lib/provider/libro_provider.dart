import 'package:flutter/material.dart';
import '../models/libro_model.dart';
import '../services/api_service.dart';

class LibrosProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Libro> librosPopulares = [];
  List<Libro> librosRecientes = [];
  List<Libro> misFavoritos = [];
  bool cargando = false;

  Future<void> cargarTodo() async {
    cargando = true;
    notifyListeners();
    try {
      librosPopulares = await _apiService.getLibrosPopulares();
      librosRecientes = await _apiService.getLibrosPorFecha();
      misFavoritos = await _apiService.getMisFavoritos();
    } catch (e) {
      debugPrint(e.toString());
    }
    cargando = false;
    notifyListeners();
  }

  void actualizarPopulares(List<Libro> nuevosLibros) {
    librosPopulares = nuevosLibros;
    notifyListeners();
  }

  void setCargando(bool valor) {
    cargando = valor;
    notifyListeners();
  }

  Future<void> toggleFavorito(Libro libro) async {
    final ok = await _apiService.postFavorito(libro);
    if (ok) {
      final exists = misFavoritos.any((l) => l.id == libro.id);
      if (exists) {
        misFavoritos.removeWhere((l) => l.id == libro.id);
      } else {
        misFavoritos.add(libro);
      }
      notifyListeners();
    }
  }
}

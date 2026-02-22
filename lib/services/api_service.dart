import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/libro_model.dart';
import '../models/user_model.dart';

class ApiService {
  final String _baseUrl = 'https://backendlibros.onrender.com/api/v1';
  static String _token = '';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_token',
  };

  Future<void> cargarToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
  }

  Future<List<Libro>> getLibrosPopulares() async {
    try {
      final uri = Uri.parse('$_baseUrl/libros/populares');
      final response = await get(uri);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        final List<dynamic> listData = decodedData['data'];
        return listData.map((item) => Libro.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error en populares: $e');
    }
    return [];
  }

  Future<List<Libro>> getLibrosPorFecha() async {
    try {
      final uri = Uri.parse('$_baseUrl/libros?sortDate=desc');
      final response = await get(uri);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        final List<dynamic> listData = decodedData['data'];
        return listData.map((item) => Libro.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error en recientes: $e');
    }
    return [];
  }

  Future<List<Libro>> getLibrosPorGenero(String genero) async {
    try {
      final uri = Uri.parse('$_baseUrl/libros');
      final response = await get(uri);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        final List<dynamic> listData = decodedData['data'];
        final libros = listData.map((item) => Libro.fromJson(item)).toList();

        if (genero == 'Todos') return libros;
        return libros
            .where((l) => l.genre.toLowerCase() == genero.toLowerCase())
            .toList();
      }
    } catch (e) {
      print('Error en géneros: $e');
    }
    return [];
  }

  Future<List<Libro>> buscarLibro(String query) async {
    try {
      final uri = Uri.parse('$_baseUrl/libros');
      final response = await get(uri);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        final List<dynamic> listData = decodedData['data'];
        return listData
            .map((item) => Libro.fromJson(item))
            .where(
              (libro) =>
                  libro.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    } catch (e) {
      print('Error en búsqueda: $e');
    }
    return [];
  }

  Future<List<Libro>> getMisFavoritos() async {
    try {
      final uri = Uri.parse('$_baseUrl/libros/mis-favoritos');
      final response = await get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        final List<dynamic> listData = decodedData['data'];
        return listData.map((item) => Libro.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error en favoritos: $e');
    }
    return [];
  }

  Future<bool> postFavorito(Libro libro) async {
    try {
      final uri = Uri.parse('$_baseUrl/libros/favoritos');
      final response = await post(
        uri,
        headers: _headers,
        body: jsonEncode({'libroId': libro.id}),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Usuario?> login(String email, String password) async {
    try {
      final uri = Uri.parse('$_baseUrl/auth/login');
      final response = await post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        _token = decodedData['data']['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token);
        await prefs.setString(
          'nombre',
          decodedData['data']['usuario']['nombre'],
        );
        await prefs.setString('email', decodedData['data']['usuario']['email']);

        return Usuario.fromJson(decodedData['data']['usuario']);
      }
    } catch (e) {
      print('Error login: $e');
    }
    return null;
  }

  Future<bool> registrar(String nombre, String email, String password) async {
    try {
      final uri = Uri.parse('$_baseUrl/auth/registrar');
      final response = await post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'email': email,
          'password': password,
        }),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

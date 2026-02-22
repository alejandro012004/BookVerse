import 'package:flutter/material.dart';
import '../models/libro_model.dart';
import '../services/api_service.dart';

// Esta clase especial crea la pantalla de búsqueda con buscador arriba
class LibroSearchDelegate extends SearchDelegate {
  final ApiService apiService = ApiService();

  // Cambia el texto que sale flojito en el buscador
  @override
  String? get searchFieldLabel => 'Buscar libro...';

  // Los botones de la derecha (la X para borrar el texto)
  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
  ];

  // El botón de la izquierda (la flecha para volver atrás)
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, null),
    icon: const Icon(Icons.arrow_back),
  );

  // Lo que sale cuando le das a "Buscar" en el teclado
  @override
  Widget buildResults(BuildContext context) => _construirResultados();

  // Lo que sale mientras vas escribiendo (Sugerencias)
  @override
  Widget buildSuggestions(BuildContext context) => query.isEmpty
      ? const Center(
          child: Icon(Icons.book_outlined, size: 100, color: Colors.grey),
        )
      : _construirResultados();

  // Función común para dibujar la lista de libros encontrados
  Widget _construirResultados() {
    return FutureBuilder<List<Libro>>(
      // Llamamos a la API usando lo que el usuario ha escrito (query)
      future: apiService.buscarLibro(query),
      builder: (context, snapshot) {
        // Mientras carga, sale el circulito de espera
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Si no hay datos o la lista viene vacía, ponemos un aviso
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No se han encontrado libros'));
        }

        final libros = snapshot.data!;

        // Dibujamos la lista de resultados
        return ListView.builder(
          itemCount: libros.length,
          itemBuilder: (context, index) {
            final libro = libros[index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(libro.image, width: 50, fit: BoxFit.cover),
              ),
              title: Text(libro.title),
              subtitle: Text(libro.authors.join(', ')),
              onTap: () {
                // Al pulsar un libro, cerramos el buscador y vamos al detalle
                close(context, null);
                Navigator.pushNamed(context, 'detalle', arguments: libro);
              },
            );
          },
        );
      },
    );
  }
}

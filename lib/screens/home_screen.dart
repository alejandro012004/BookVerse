import 'package:flutter/material.dart';
import 'package:po_t5/provider/libro_provider.dart';
import 'package:provider/provider.dart';
import '../models/libro_model.dart';
import '../search/libro_search_delegate.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Guardamos qué categoría está marcada y llamamos a la API
  String categoriaSeleccionada = 'Todos';
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    // Conectamos con el provider de los libros
    final librosProv = Provider.of<LibrosProvider>(context);

    // Miramos el ancho de la pantalla para saber si es PC o Móvil
    final double anchoPantalla = MediaQuery.of(context).size.width;
    final bool esEscritorio = anchoPantalla > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BookVerse',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Botón para ir a mi perfil
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, 'perfil'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            // Si es PC, el contenido no se estira infinito, se queda en 1200px
            constraints: BoxConstraints(
              maxWidth: esEscritorio ? 1200 : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBuscador(), // El buscador de arriba
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Categorías',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildBarraCategorias(librosProv), // Los botones de filtros
                // Título dinámico según la categoría elegida
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    categoriaSeleccionada == 'Todos'
                        ? 'Libros Populares'
                        : 'Libros de $categoriaSeleccionada',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Lista de libros que cambian con el filtro
                _crearListaLibros(
                  librosProv.cargando,
                  librosProv.librosPopulares,
                ),

                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Añadidos recientemente',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                // Lista de libros nuevos (esta no cambia con el filtro)
                _crearListaLibros(
                  librosProv.cargando,
                  librosProv.librosRecientes,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget para el buscador
  Widget _buildBuscador() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
        onTap: () =>
            showSearch(context: context, delegate: LibroSearchDelegate()),
        child: AbsorbPointer(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar libros...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Fila horizontal con los botones de categorías
  Widget _buildBarraCategorias(LibrosProvider prov) {
    final categorias = [
      'Todos',
      'Cómic',
      'Fantasía',
      'Thriller',
      'Ciencia Ficción',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        children: categorias
            .map(
              (cat) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _miBotonFiltro(cat, prov),
              ),
            )
            .toList(),
      ),
    );
  }

  // El botón individual de cada categoría
  Widget _miBotonFiltro(String texto, LibrosProvider prov) {
    bool activo = (categoriaSeleccionada == texto);
    return ElevatedButton(
      onPressed: () async {
        setState(() => categoriaSeleccionada = texto);
        prov.setCargando(true); // Ponemos la carga
        final filtrados = await _apiService.getLibrosPorGenero(
          texto,
        ); // Pedimos a la API
        prov.actualizarPopulares(
          filtrados,
        ); // Actualizamos la lista del Provider
        prov.setCargando(false); // Quitamos la carga
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: activo
            ? const Color.fromARGB(255, 255, 98, 0)
            : Colors.grey[200],
        foregroundColor: activo ? Colors.white : Colors.black,
      ),
      child: Text(texto),
    );
  }

  // Crea la lista horizontal de tarjetas de libros
  Widget _crearListaLibros(bool cargando, List<Libro> libros) {
    if (cargando) return const Center(child: CircularProgressIndicator());
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: libros.length,
        itemBuilder: (context, index) => _tarjetaSencilla(libros[index]),
      ),
    );
  }

  // La tarjeta visual de cada libro
  Widget _tarjetaSencilla(Libro libro) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'detalle', arguments: libro),
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(left: 15),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                libro.image,
                height: 180,
                width: 130,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              libro.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              libro.authors[0],
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

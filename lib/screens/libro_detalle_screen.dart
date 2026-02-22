import 'package:flutter/material.dart';
import 'package:po_t5/provider/libro_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart'; // Para compartir en WhatsApp/Redes
import '../models/libro_model.dart';

class LibroDetalleScreen extends StatelessWidget {
  const LibroDetalleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Recogemos el libro que nos pasan por el Navigator desde la Home
    final Libro libro = ModalRoute.of(context)!.settings.arguments as Libro;

    // Conectamos con el provider para manejar los favoritos
    final librosProv = Provider.of<LibrosProvider>(context);

    // Comprobamos si este libro ya está en nuestra lista de favoritos
    final bool esFav = librosProv.misFavoritos.any((l) => l.id == libro.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DETALLES DEL LIBRO',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // Botón de compartir (Usa el paquete share_plus)
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => Share.share(
              '¡Mira este libro: ${libro.title} de ${libro.authors.join(", ")}!',
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // PARTE SUPERIOR: Imagen y botón de Favorito
            SizedBox(
              height: 350,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Portada del libro con bordes redondeados
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      libro.image,
                      height: 280,
                      width: 190,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Botón flotante para añadir/quitar favorito
                  Positioned(
                    bottom: 20,
                    right: 15,
                    child: Container(
                      decoration: BoxDecoration(
                        color: esFav ? Colors.red : const Color(0xFFE65100),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          esFav ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          // Llamamos a la lógica del provider
                          await librosProv.toggleFavorito(libro);

                          // Mostramos un mensajito abajo (SnackBar)
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  esFav
                                      ? 'Quitado de favoritos'
                                      : 'Añadido a favoritos',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // PARTE INFERIOR: Información del libro
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    libro.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${libro.authors.join(", ")}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  // Barra de estrellas
                  _ratingBar(libro.appRating),
                  const SizedBox(height: 25),
                  // Iconos rápidos (Género, Páginas, Idioma)
                  _filaChips(libro),
                  const SizedBox(height: 30),
                  // Texto de la sinopsis
                  _seccionSinopsis(libro.description),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para dibujar las estrellas según la puntuación
  Widget _ratingBar(double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
          5,
          (index) => Icon(
            Icons.star,
            color: index < rating.floor() ? Colors.orange : Colors.grey[300],
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          rating.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  // Fila con iconos informativos
  Widget _filaChips(Libro libro) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildChip(Icons.menu_book, libro.genre),
        _buildChip(Icons.access_time, '${libro.pageCount} pag'),
        _buildChip(Icons.language, 'Español'),
      ],
    );
  }

  // Diseño de cada icono informativo
  Widget _buildChip(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFFE65100)),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // Sección de la descripción o sinopsis
  Widget _seccionSinopsis(String sinopsis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sinopsis',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(sinopsis, style: const TextStyle(height: 1.6, fontSize: 15)),
      ],
    );
  }
}

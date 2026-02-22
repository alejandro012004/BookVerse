import 'dart:convert';

class Libro {
  final String id;
  final String googleId;
  final String title;
  final List<String> authors;
  final DateTime publishedDate;
  final String shortDescription;
  final String description;
  final String isbn;
  final String genre;
  final List<String> tags;
  final int pageCount;
  final String language;
  final bool featured;
  final String image;
  final double appRating;
  final int appReviewsCount;

  Libro({
    required this.id,
    required this.googleId,
    required this.title,
    required this.authors,
    required this.publishedDate,
    required this.shortDescription,
    required this.description,
    required this.isbn,
    required this.genre,
    required this.tags,
    required this.pageCount,
    required this.language,
    required this.featured,
    required this.image,
    required this.appRating,
    required this.appReviewsCount,
  });

  factory Libro.fromJson(Map<String, dynamic> json) => Libro(
    id: json["id"] ?? '',
    googleId: json["googleId"] ?? '',
    title: json["title"] ?? '',
    authors: List<String>.from(json["authors"]?.map((x) => x) ?? []),
    publishedDate: DateTime.parse(
      json["publishedDate"] ?? DateTime.now().toString(),
    ),
    shortDescription: json["shortDescription"] ?? '',
    description: json["description"] ?? '',
    isbn: json["isbn"] ?? '',
    genre: json["genre"] ?? '',
    tags: List<String>.from(json["tags"]?.map((x) => x) ?? []),
    pageCount: json["pageCount"] ?? 0,
    language: json["language"] ?? 'es',
    featured: json["featured"] ?? false,
    image: json["image"] ?? '',
    appRating: (json["appRating"] ?? 0).toDouble(),
    appReviewsCount: json["appReviewsCount"] ?? 0,
  );
}

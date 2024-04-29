import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String name;
  final String cuisine;
  final String durations;
  final String imageUrl;
  final String description;
  final double ratings;
  final bool isFavorite;
  final List<String> stepTitle;
  final List<String> ingredients;
  final List<String> instructions;

  Recipe({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.durations,
    required this.imageUrl,
    required this.description,
    required this.ratings,
    required this.isFavorite,
    required this.stepTitle,
    required this.ingredients,
    required this.instructions,
  });

  // factory Recipe.fromFirestore(DocumentSnapshot doc) {
  //   Map data = doc.data() as Map<String, dynamic>;
  //   return Recipe(
  //     id: doc.id,
  //     name: data['name'] ?? '',
  //     cuisine: data['cuisine'] ?? '',
  //     durations: data['durations'] ?? '',
  //     imageUrl: data['imageUrl'] ?? '',
  //     description: data['description'] ?? '',
  //     ratings: (data['ratings'] ?? 0).toDouble(),
  //     isFavorite: data['isFavorite'] ?? '',
  //     stepTitle: data['stepTitle'] ?? '',
  //     ingredients: List<String>.from(data['ingredients'] ?? []),
  //     instructions: List<String>.from(data['instructions'] ?? []),
  //   );
  // }
}

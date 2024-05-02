import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/recipe.dart';

class FirestoreServices {
  //Get reference to the users collection
  final CollectionReference users =
  FirebaseFirestore.instance.collection('users');
  //Get reference to the recipes collection
  final CollectionReference recipes =
  FirebaseFirestore.instance.collection('recipes');

  //Save user to Firestore
  static Future<void> saveUser(String name, String email, String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'name': name,
    });
  }

  //Add recipe to user's wishlist
  static Future<void> addToWishlist({
    required String userId,
    required Recipe recipe,
    required bool update,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(recipe.id)
        .set({
      'id': recipe.id,
      'name': recipe.name,
      'cuisine': recipe.cuisine,
      'durations': recipe.durations,
      'imageUrl': recipe.imageUrl,
      'ratings' : recipe.ratings,
      'isFavorite' : update,
      'description' : recipe.description,
      'ingredients' : recipe.ingredients,
      'stepTitle' : recipe.stepTitle,
      'instructions' : recipe.instructions,
      'timestamp' : Timestamp.now()
    });
  }

  //Remove recipe from user's wishlist
  static Future<void> removeFromWishlist({
    required String userId,
    required String recipeId,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(recipeId)
        .delete();
  }

  //Get user's wishlist
  static Stream<QuerySnapshot> getUserWishlist(String userId) {
    final wishlistStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .orderBy('timestamp',descending: true).snapshots();
    //show all user's wishlist in descending
    return wishlistStream;
  }

  //Get all recipes from database
  Stream<QuerySnapshot> getAllRecipes() {
    final recipesStream =
    recipes.orderBy('averageRating', descending: true).snapshots();
    return recipesStream;
  }

  //Update the ratings of a specific recipe
  static Future<void> updateRecipeRatings({
    required String recipeId,
    required int newRating,
  }) async {
    //Get reference to the specific recipe document
    final recipeRef = FirebaseFirestore.instance.collection('recipes').doc(recipeId);

    //Get the current ratings data
    final currentData = await recipeRef.get();

    //Get the current total ratings count and sum of ratings
    final int currentTotalRatings = currentData.data()?['ratings'] ?? 0;
    final int currentSumRatings = currentData.data()?['sumRatings'] ?? 0;

    //Calculate the new total ratings count and sum of ratings
    final int newTotalRatings = currentTotalRatings + 1;
    final int newSumRatings = currentSumRatings + newRating;

    //Calculate the new average rating
    final double newAverageRating = newSumRatings / newTotalRatings;

    //Update the recipe document with the new ratings
    await recipeRef.update({
      'ratings': newTotalRatings,
      'sumRatings': newSumRatings,
      'averageRating': newAverageRating,
    });
  }
}

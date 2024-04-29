import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/favorite_state.dart';
import '../model/recipe.dart';
import '../auth/firebaseFunctions.dart';

class FavoriteButton extends StatefulWidget {
  final String userId;
  final Recipe recipe;
  final FavoriteState favoriteState;

  const FavoriteButton({
    required this.userId,
    required this.recipe,
    required this.favoriteState,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false; // Track if the recipe is in the user's wishlist

  @override
  void initState() {
    super.initState();
    // Check if the recipe is in the user's wishlist when the widget initializes
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    // Query the user's wishlist to see if the recipe exists there
    final querySnapshot =
    await FirestoreServices.getUserWishlist(widget.userId).first;
    final recipes = querySnapshot.docs;
    final isFavorite = recipes.any((doc) => doc.id == widget.recipe.id);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          _isFavorite = !_isFavorite;
        });
        if (_isFavorite) {
          FirestoreServices.addToWishlist(
            userId: widget.userId,
            recipe: widget.recipe,
            update: _isFavorite,
          );
        } else {
          FirestoreServices.removeFromWishlist(
            userId: widget.userId,
            recipeId: widget.recipe.id,
          );
        }
      },
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? Colors.red : null,
      ),
    );
  }
}

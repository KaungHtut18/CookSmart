import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookbook/components/FavoriteButton.dart';
import 'package:cookbook/model/recipe.dart';
import 'package:cookbook/screens/recipePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/favorite_state.dart';

class RecipeList extends StatefulWidget {
  final String name;
  final String cuisine;
  final String durations;
  final double ratings;
  final String docID;
  final String imageUrl;
  final instructions;
  final ingredients;
  final description;
  final isFavorite;
  final stepTitle;

  const RecipeList({
    required this.name,
    required this.cuisine,
    required this.durations,
    required this.ratings,
    required this.docID,
    required this.imageUrl,
    required this.instructions,
    required this.ingredients,
    required this.description,
    required this.stepTitle,
    required this.isFavorite,
    Key? key,
  }) : super(key: key);

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  late FavoriteState favoriteState; // Create FavoriteState instance

  @override
  void initState() {
    super.initState();
    // Initialize favoriteState
    favoriteState = FavoriteState();
  }

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        //navigate to recipe detail page based on recipe id
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RecipeDetailPage(index: widget.docID),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(2, 4), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: Container(
                  color: Colors.grey[200],
                  child: widget.imageUrl.isNotEmpty
                      ? Center(
                    //cached image
                        child: CachedNetworkImage(
                            imageUrl: widget.imageUrl, fit: BoxFit.fill,
                            placeholder: (context, url) => CircularProgressIndicator(color: Colors.white,),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      )
                      : const Center(
                    child: Text(
                      'No Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),

              // Name
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 10.0, right: 8.0),
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              // Duration
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 20),
                        const SizedBox(width: 3),
                        // Duration
                        Text(
                          widget.durations,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    FavoriteButton(
                        userId: user.uid,
                        recipe: Recipe(
                        id: widget.docID,
                        name: widget.name,
                        cuisine: widget.cuisine,
                        durations: widget.durations,
                        imageUrl: widget.imageUrl,
                        description: widget.description,
                        ratings: widget.ratings,
                        isFavorite: widget.isFavorite,
                        stepTitle: widget.stepTitle,
                        ingredients: widget.ingredients,
                        instructions: widget.instructions),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 5),
                    Text(widget.ratings.toString())
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

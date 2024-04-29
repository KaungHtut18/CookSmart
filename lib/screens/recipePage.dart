import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook/auth/firebaseFunctions.dart';
import 'package:cookbook/components/FavoriteButton.dart';
import 'package:cookbook/model/recipe.dart';
import 'package:cookbook/screens/Instruction.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../model/favorite_state.dart';

class RecipeDetailPage extends StatefulWidget {
  final index;
  RecipeDetailPage({
    required this.index,
    super.key});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final FirestoreServices fireStoreService = FirestoreServices();
  late DocumentSnapshot document;
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Description",
          style: TextStyle(
              fontSize: 20,
              color: Color.fromRGBO(238, 90, 37, 1),
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromRGBO(255, 238, 232, 1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStoreService.getAllRecipes(),
        builder: (context, snapshot){
          //if we have data, get all the docs
          if(snapshot.hasData){
            List<QueryDocumentSnapshot> recipesList = snapshot.data!.docs.cast<QueryDocumentSnapshot>();
            // Find the recipe document with matching docID
            document = recipesList.firstWhere((doc) => doc.id == widget.index);
            String docID = document.id;

            Map<String, dynamic> data =
            document.data() as Map<String, dynamic>;
            String recipeName = data['name'];
            String recipeCuisine = data['cuisine'];
            String recipeDuration = data['durations'];
            double recipeRatings = (data['averageRating'] ?? 0).toDouble();
            double formattedRating = double.parse(recipeRatings.toStringAsFixed(1));
            List<String> ingredients = List<String>.from(data['ingredients']);
            String description = data['description'];
            String imageUrl = data['imageUrl'];
            List<String> instructions =
            List<String>.from(data['instructions']);
            List<String> stepTitle = List<String>.from(data['stepTitle']);
            bool isFavorite = data['isFavorite'];

            return Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Inside the Container where you display the recipe image
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0), // Set the border radius here
                          child: Container(
                            height: 300,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                            child: imageUrl.isNotEmpty
                                ? Center(
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,fit: BoxFit.fill, width: double.infinity,
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
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 3, left: 24, right: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                //name
                                Text(
                                  recipeName,
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                //type
                                Text("($recipeCuisine)")
                              ],
                            ),
                            //fav button
                            FavoriteButton(
                                userId: user.uid,
                                recipe: Recipe(
                                    id: docID,
                                    name: recipeName,
                                    cuisine: recipeCuisine,
                                    durations: recipeDuration,
                                    imageUrl: imageUrl,
                                    description: description,
                                    ratings: formattedRating,
                                    ingredients: ingredients,
                                    instructions: instructions,
                                    isFavorite : isFavorite,
                                    stepTitle: stepTitle),
                                favoriteState: favoriteState)
                          ],
                        ),
                      ),
                      //ratings
                      Padding(
                        padding: const EdgeInsets.only(left: 24, bottom: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow[700],
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(formattedRating.toString()),
                            const SizedBox(
                              width: 20,
                            ),
                            const Icon(
                              Icons.timer_outlined,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(recipeDuration)
                          ],
                        ),
                      ),
                      //description
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 3),
                        child: Text(
                          description,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                      //line
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Divider(),
                      ),
                      //ingrediants
                      const Padding(
                        padding: EdgeInsets.only(top: 6, left: 24),
                        child: Text("Ingredients",
                            textAlign: TextAlign.left,
                            style:
                            TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                      ),
                      Expanded(
                          child: ListView.builder(
                            itemCount: ingredients.length,
                            itemBuilder: (context, index) {
                              if (index < ingredients.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8, bottom: 8, left: 24,),
                                  child: Container(

                                    child: Row(
                                      children: [
                                        const Icon(Icons.arrow_right), // Leading icon
                                        const SizedBox(
                                            width:
                                            8), // Add some space between the icon and text
                                        Expanded(
                                          // Wrap the Text widget with Expanded
                                          child: Text(
                                            ingredients[index],
                                            // Adjust the style as needed
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox(); // Placeholder widget or empty container
                              }
                            },
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context){
                                return InstructionPage(index: docID,);
                              }
                          )
                      );
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color.fromRGBO(238, 90, 37, 1),
                      ),
                      child: const Center(
                        child: Text('Start Cooking',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: Colors.white
                          ),),
                      ),
                    ),
                  ),
                )
              ],
            );
          }
          else{
            return Center(child: CircularProgressIndicator(color: Colors.white,));
          }
        },
      ),

    );
  }
}

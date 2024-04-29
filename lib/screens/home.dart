import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook/components/RecipeList.dart';
import 'package:cookbook/components/StickyTextWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cookbook/constant/image.dart';

import '../auth/firebaseFunctions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  final FirestoreServices _firestoreService = FirestoreServices();
  final user = FirebaseAuth.instance.currentUser!;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String greetUser() {
    var now = DateTime.now();

    var currentHour = now.hour;

    if (currentHour >= 5 && currentHour < 12) {
      return "Good morning!";
    } else if (currentHour >= 12 && currentHour < 17) {
      return "Good afternoon!";
    } else if (currentHour >= 17 && currentHour < 22) {
      return "Good evening!";
    } else {
      return "Good night!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        //header and search bar
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(back_ground),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Text("${greetUser()} ",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(user.displayName ?? 'User',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "What Would you like to cook today?",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  textAlign: TextAlign.start,
                  textDirection: TextDirection.ltr,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: 'Search Recipes',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Color(0xddEE5A25),),
                    filled: true,
                    fillColor: const Color(0xffFFEDED),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide.none
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        //recommend line
        const StickyTextWidget(header: 'Recommended Recipes'),

        //recipe list
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestoreService.getAllRecipes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('No Recipes'));
              } else {
                List recipesList = snapshot.data!.docs;

                // filter recipes based on search query with name amd cuisine
                List filteredRecipes = recipesList.where((recipe) {
                  String name = recipe['name'].toLowerCase();
                  String cuisine = recipe['cuisine'].toLowerCase();
                  String query = _searchQuery.toLowerCase();
                  return name.contains(query) || cuisine.contains(query);
                }).toList();

                if (filteredRecipes.isEmpty) {
                  return Center(
                    child: Text('No Recipe(s) Found', style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontWeight: FontWeight.bold)
                    ),),
                  );
                }

                return GridView.builder(
                  itemCount: filteredRecipes.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 1,
                    childAspectRatio: 1 / 1.5,
                  ),
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = filteredRecipes[index];
                    String docID = document.id;

                    Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                    String recipeName = data['name'];
                    String recipeCuisine = data['cuisine'];
                    String recipeDuration = data['durations'];
                    double recipeRatings =
                    (data['averageRating'] ?? 0).toDouble();
                    double formattedRating = double.parse(recipeRatings.toStringAsFixed(1));
                    String imageUrl = data['imageUrl'];
                    List<String> ingredients = List<String>.from(data['ingredients']);
                    String description = data['description'];
                    List<String> instructions =
                    List<String>.from(data['instructions']);
                    List<String> stepTitle = List<String>.from(data['stepTitle']);
                    bool isFavorite = data['isFavorite'];

                    return RecipeList(
                      name: recipeName,
                      cuisine: recipeCuisine,
                      durations: recipeDuration,
                      ratings: formattedRating,
                      imageUrl: imageUrl,
                      docID: docID,
                      description: description,
                      ingredients: ingredients,
                      instructions: instructions,
                      isFavorite: isFavorite,
                      stepTitle: stepTitle,
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    ));
  }
}

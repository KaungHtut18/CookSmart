import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook/auth/firebaseFunctions.dart';
import 'package:cookbook/screens/recipePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/constant/color.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({Key? key}) : super(key: key);

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "My Favorites",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getUserWishlist(user!.uid),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No Favorite(s) Yet',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            );
          } else {
            final items = snapshot.data!.docs;
            return ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.all(12),
              itemBuilder: (context, index) {
                DocumentSnapshot document = items[index];

                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                bool update = data['isFavorite'];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailPage(index: document.id),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: data['imageUrl'],height: 40,
                          placeholder: (context, url) => CircularProgressIndicator(color: Colors.white,),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        title: Text(
                          data['name'],
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          data['cuisine'],
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            setState(() {
                              update = !update;
                            });
                            // remove from wishlist functionality
                            FirestoreServices.removeFromWishlist(userId: user.uid, recipeId: document.id);
                            // FirestoreServices.updateFavorite(update, document.id);
                            // print(update);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

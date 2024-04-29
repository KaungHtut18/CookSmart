import 'package:flutter/material.dart';
import 'package:cookbook/screens/bottomNav.dart';
import '../auth/firebaseFunctions.dart'; // Import your FirestoreServices class

class FeedBackPage extends StatefulWidget {
  final String recipeId;
  const FeedBackPage({required this.recipeId, Key? key}) : super(key: key);

  @override
  _FeedBackPageState createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  int _rating = 0;

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  void _submitFeedback() {
    // Call the updateRecipeRatings method from your FirestoreServices class
    FirestoreServices.updateRecipeRatings(recipeId: widget.recipeId, newRating: _rating);

    // Show a dialog with a thank you message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(child: Icon(Icons.star, size: 80, color: Colors.amberAccent,),),
          content: Text('Thanks for your feedback.', textAlign: TextAlign.center,),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.black),),
              onPressed: () {
                // Navigate to the desired screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNav(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Image.asset("images/feedback.png"),
            ),
            const Text(
              "Give Feedback",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 1; i <= 5; i++)
                    GestureDetector(
                      onTap: () {
                        _setRating(i);
                      },
                      child: Icon(
                        i <= _rating ? Icons.star : Icons.star_outline,
                        size: 35,
                        color: Colors.amberAccent,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: MaterialButton(
                color: const Color.fromRGBO(238, 90, 37, 1),
                height: 40,
                onPressed: _submitFeedback,
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook/auth/firebaseFunctions.dart';
import 'package:cookbook/screens/feedBack.dart';
import 'package:cookbook/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InstructionPage extends StatefulWidget {
  final index;
  const InstructionPage({
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  State<InstructionPage> createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {
  final FirestoreServices fireStoreService = FirestoreServices();
  late DocumentSnapshot document;
  late List<bool> isTapped;

  @override
  void initState() {
    super.initState();
    isTapped = [];
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
        title: const Text(
          "Instruction",
          style: TextStyle(
              fontSize: 20,
              color: Color.fromRGBO(238, 90, 37, 1),
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromRGBO(255, 238, 232, 1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStoreService.getAllRecipes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot> recipeList =
            snapshot.data!.docs.cast<QueryDocumentSnapshot>();
            document = recipeList.firstWhere((doc) => doc.id == widget.index);
            String docID = document.id;

            Map<String, dynamic> data =
            document.data() as Map<String, dynamic>;
            List<String> instructions =
            List<String>.from(data['instructions']);
            List<String> stepTitle = List<String>.from(data['stepTitle']);

            // Check if isTapped list is empty and initialize it with default values
            if (isTapped.isEmpty) {
              isTapped = List.generate(instructions.length, (index) => false);
            }

            bool allStepsCompleted = isTapped.every((element) => element);
            bool noSteps = instructions.isEmpty;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        if (noSteps)
                          Padding(
                            padding: const EdgeInsets.only(left: 24, right: 24),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: const Icon(Icons.check, color: Colors.white),
                            ),
                          ),
                        if (instructions.isNotEmpty)
                          for (int i = 0; i < instructions.length; i++)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isTapped[i] = !isTapped[i];
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 24, right: 24),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: isTapped[i]
                                          ? Colors.grey
                                          : const Color.fromRGBO(238, 90, 37, 1),
                                      child: isTapped[i]
                                          ? const Icon(Icons.check, color: Colors.white)
                                          : Text(
                                        '${i + 1}',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 24),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 2),
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(stepTitle[i], style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),),
                                            const SizedBox(height: 10,),
                                            Text(
                                              instructions[i],
                                              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (i != instructions.length - 1)
                                      Container(
                                        height: 30,
                                        width: 2,
                                        color: Colors.black,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                        if (instructions.isNotEmpty)
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.black,
                          ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          child: CircleAvatar(
                              backgroundColor: allStepsCompleted
                                  ? const Color.fromRGBO(238, 90, 37, 1)
                                  : Colors.grey,
                              child: const Icon(Icons.check, color: Colors.white)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 10.0),
                          child: GestureDetector(
                            onTap: noSteps || allStepsCompleted
                                ? () {
                              // Handle Done button tap
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context){
                                        return FeedBackPage(recipeId: widget.index,);
                                      }
                                  )
                              );
                            }
                                : null, // Disable button if all steps are not completed
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: allStepsCompleted
                                    ? const Color.fromRGBO(238, 90, 37, 1)
                                    : Colors.grey,
                              ),
                              child: const Center(
                                child: Text('Done',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: Colors.white
                                  ),),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

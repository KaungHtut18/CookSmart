import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookbook/auth/auth_service.dart';
import 'package:cookbook/components/CustomButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/constant/color.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final user = FirebaseAuth.instance.currentUser!;
    final imageUrl = user.photoURL;

    //generate random numbers as user id
    String extractNumericPart(String uid) {
      return uid.replaceAll(
          RegExp(r'[^0-9]'), '');
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 100, left: 100, right: 100, bottom: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        color: Colors.grey[350]
                    ),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: imageUrl,fit: BoxFit.fill,
                      placeholder: (context, url) => CircularProgressIndicator(color: Colors.white,),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                        : const Center(child: Icon(Icons.cookie, size: 50, color: primaryColor,),),
                  ),
                ),
              ),
              Center(
                child: Text(
                  user.displayName!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 24.0),
                child: const Divider(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  'Personal Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User ID',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Text(
                          'E-mail',
                          style: TextStyle(color: Colors.grey[600]),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('cs_${extractNumericPart(user.uid)}'),
                        const SizedBox(
                          height: 24,
                        ),
                        Text(user.email!)
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, right: 24.0, bottom: 24.0),
                child: const Divider(),
              ),
              CustomButton(
                label: 'Logout',
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text("Confirm Logout"),
                          content:
                          const Text("Are you sure you want to Logout?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.black),
                                )),
                            TextButton(
                                onPressed: () async {
                                  await auth.signout();
                                  // user.delete();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Okay",
                                  style: TextStyle(color: Colors.black),
                                )),
                          ],
                        );
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cookbook/auth/wrapper.dart';
import 'package:cookbook/model/favorite_state.dart';
import 'package:cookbook/screens/OnBoardingScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

int? isViewed;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt('onBoard');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => FavoriteState(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'cooksmart',
          home: isViewed != 0 ? OnBoardingScreen() : Wrapper(),
        ),);
  }
}



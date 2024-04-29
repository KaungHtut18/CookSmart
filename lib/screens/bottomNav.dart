import 'package:cookbook/screens/home.dart';
import 'package:cookbook/screens/favoritePage.dart';
import 'package:cookbook/screens/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:cookbook/constant/color.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  
  List<Widget> widgetOptions = <Widget>[
    const Home(),
    const LikesPage(),
    const ProfilePage()
  ];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: widgetOptions[_selectedIndex],
      bottomNavigationBar: Container(
        height: 75,
        color: const Color.fromRGBO(255, 238, 232, 1),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: GNav(
            onTabChange: _onItemTapped,
            selectedIndex: _selectedIndex,
            gap: 10,
            tabBackgroundColor: tabBGColor,
            activeColor: primaryColor,
            color: iconColor,
            padding: const EdgeInsets.all(8.0),
            backgroundColor: secondaryColor,
            tabs: const [
              GButton(
                icon: Icons.home_rounded,
                text: 'Home',
                iconSize: 30,
              ),
              GButton(
                icon: Icons.favorite_rounded,
                text: 'Likes',
                iconSize: 30,
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
                iconSize: 30,
              )
            ],
          ),
        ),
      ), 
    );
  }
}

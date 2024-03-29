import 'package:area/setupuser.dart';
import 'package:flutter/material.dart';

import 'package:area/my_applets/my_applets_page.dart';
import 'package:area/search_page.dart';
import 'package:area/create/create_page.dart';
import 'package:area/activity_page.dart';
import 'package:area/profile_page.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  PageController pageController = PageController();
  final USerInfo user = new USerInfo();

  void onTapped(int index) async {
      setState(() {
        _selectedIndex = index;
      });
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutExpo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          MyAppletsPage(),
          SearchPage(false, false),
          CreatePage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Mes applets'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explorer'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Créer'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        onTap: onTapped,
      ),
    );
  }
}

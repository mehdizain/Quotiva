import 'package:flutter/material.dart';
import 'package:myfirst/home/daily_tab.dart';
import 'package:myfirst/home/my_quotes_tab.dart';
import 'package:myfirst/home/favourites_tab.dart';
import 'package:myfirst/home/profile_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    DailyTab(),
    MyQuotesPage(),
    FavoritesTab(),
    ProfileTab(), // <-- NEW
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quote Explorer",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.indigo[900],
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: Colors.indigo[900]?.withOpacity(0.3),
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo[700]!, Colors.indigo[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo[900]!.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.today, size: 24),
              label: 'Daily',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore, size: 24),
              label: 'My Quotes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark, size: 24),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 24),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

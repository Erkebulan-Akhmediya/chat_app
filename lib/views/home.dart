import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
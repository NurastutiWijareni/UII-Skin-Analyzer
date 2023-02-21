import 'package:flutter/material.dart';

import './home_screen.dart';
import './profile/profile_screen.dart';
import './history/history_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static const routeName = '/home';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const HistoryScreen(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  final List<Map<String, dynamic>> _bottomNavBarItem = const [
    {
      'text': 'Beranda',
      'icon': Icons.home,
    },
    {
      'text': 'Riwayat',
      'icon': Icons.bookmark,
    },
    {
      'text': 'Profil',
      'icon': Icons.person,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, right: 12.0, left: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/icons/logo-home.png'),
                Image.asset('assets/icons/logo-uii.png'),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFEFF5FF),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        width: double.infinity,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFEFF5FF),
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: false,
        selectedLabelStyle: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
        //* https://fireship.io/snippets/dart-how-to-get-the-index-on-array-loop-map/
        items: _bottomNavBarItem.asMap().entries.map(
          (entry) {
            return BottomNavigationBarItem(
              label: entry.value['text'],
              icon: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: (_selectedIndex == entry.key) ? const Color(0xFF62BBE2) : Colors.transparent),
                child: Icon(entry.value['icon'], color: (_selectedIndex == entry.key) ? Colors.white : const Color(0xFF62BBE2)),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

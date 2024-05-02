import 'package:bir_lig_app/presentation/screens/homePage.dart';
import 'package:bir_lig_app/presentation/screens/myLeaguesPage.dart';
import 'package:bir_lig_app/presentation/screens/playerPage.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  List<Widget> body = const [HomePage(), MyLeaguesPage(), PlayerPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(height: 100, child: Image.asset('assets/appstore.png')),
      ),
      body: Center(
        child: body[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Anasayfa',
              activeIcon: Icon(Icons.home)),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined),
              label: 'Liglerim',
              activeIcon: Icon(Icons.people)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Hesap',
              activeIcon: Icon(Icons.person)),
        ],
      ),
    );
  }
}

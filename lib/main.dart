import 'package:tracky/pages/new_item.dart';
import 'package:tracky/pages/profile.dart';
import 'package:tracky/pages/tracked_items.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedPageIndex = 0;

  final List _pages = [
    const TrackedItemsPage(),
    const NewItemPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tracky',
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
            // leading: ,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/logo64.png'),
                  width: 32,
                  height: 32,
                ),
                SizedBox(width: 8),
                Text('Tracky', style: TextStyle(fontSize: 16)),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: const Color(0xffE0E0E0),
                height: 1.0,
              ),
            )),
        body: _pages[_selectedPageIndex],
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          fixedColor: Colors.black,
          currentIndex: _selectedPageIndex,
          iconSize: 27,
          onTap: (value) {
            setState(() {
              _selectedPageIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.space_dashboard),
              icon: Icon(Icons.space_dashboard_outlined),
              label: 'Tracked Items',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.add_box),
              icon: Icon(Icons.add_box_outlined),
              label: 'Tracked Items',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

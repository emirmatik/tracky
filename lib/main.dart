import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tracky/components/styled_text.dart';
import 'package:tracky/core/app_themes.dart';
import 'package:tracky/firebase_options.dart';
import 'package:tracky/pages/new_item.dart';
import 'package:tracky/pages/profile.dart';
import 'package:tracky/pages/tracked_items.dart';
import 'package:tracky/pages/login.dart';
import 'package:provider/provider.dart';
import 'package:tracky/core/user_provider.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: const Main(),
  ));
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedPageIndex = 1;

  final List _pages = [
    const TrackedItemsPage(),
    const NewItemPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tracky',
      theme: CommonThemes.lightTheme,
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
              StyledText(text: 'Tracky', type: 'h4'),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: const Color(0xffE0E0E0),
              height: 1.0,
            ),
          ),
        ),
        body: user != null ? _pages[_selectedPageIndex] : const LoginPage(),
        bottomNavigationBar: user != null
            ? BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                fixedColor: Colors.black,
                currentIndex: 1,
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
              )
            : null,
      ),
    );
  }
}

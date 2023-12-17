import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracky/components/styled_text.dart';
import 'package:tracky/core/app_themes.dart';
import 'package:tracky/core/firebase_options.dart';
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

  await dotenv.load();

  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: const Main(),
  ));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Main extends StatefulWidget {
  const Main({super.key});

  static dynamic updateAppTheme;
  static dynamic theme = 'light';

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedPageIndex = 0;
  bool isUserLoading = true;
  bool isSettingUpConfigs = true;
  String theme = 'light';

  final List _pages = [
    const TrackedItemsPage(),
    const NewItemPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();

    Main.updateAppTheme = (appTheme) async {
      Main.theme = appTheme;

      setState(() {
        theme = appTheme;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app-theme', appTheme);
    };

    configureInitialTheme();

    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        _selectedPageIndex = 0;
        isUserLoading = false;
      }

      Provider.of<UserProvider>(context, listen: false).setUser(user);

      if (isUserLoading || user != null) {
        setState(() {
          if (isUserLoading) {
            isUserLoading = false;
          }

          if (user != null && navigatorKey.currentState!.canPop()) {
            navigatorKey.currentState?.pop();
          }
        });
      }
    });
  }

  void configureInitialTheme() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('app-theme')) {
      await prefs.setString('app-theme', 'light');
    }

    setState(() {
      String appTheme = prefs.getString('app-theme') ?? theme;

      theme = appTheme;
      isSettingUpConfigs = false;

      Main.theme = appTheme;
    });
  }

  Widget _mainScreen() {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                surfaceTintColor:
                    theme == 'light' ? Colors.white : darkBackground,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/logo64-$theme.png'),
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 8),
                    const StyledText(text: 'Tracky', type: 'h4'),
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1.0),
                  child: Container(
                    color: theme == 'light'
                        ? const Color(0xffE0E0E0)
                        : const Color.fromARGB(255, 63, 63, 63),
                    height: 1.0,
                  ),
                ),
              )
            ];
          },
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: _pages[_selectedPageIndex],
            ),
          ),
        ),
      ),
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
    );
  }

  Widget _authScreen() {
    return const Scaffold(
      body: LoginPage(),
    );
  }

  Widget _loadingScreen() {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tracky',
      navigatorKey: navigatorKey,
      theme:
          theme == 'light' ? CommonThemes.lightTheme : CommonThemes.darkTheme,
      themeMode: theme == 'light' ? ThemeMode.light : ThemeMode.dark,
      themeAnimationDuration: const Duration(milliseconds: 300),
      darkTheme: CommonThemes.darkTheme,
      home: (isUserLoading || isSettingUpConfigs)
          ? _loadingScreen()
          : user == null
              ? _authScreen()
              : _mainScreen(),
    );
  }
}

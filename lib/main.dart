import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'main_navigation.dart';
import 'views/auth/complete_profile_screen.dart';
import 'views/intro/intro_screen.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('themeBox');
  await Hive.openBox('stockBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('themeBox').listenable(),
      builder: (context, box, _) {
        final bool isDark = box.get('isDarkMode', defaultValue: false);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Stock App',
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepPurple,
            scaffoldBackgroundColor: Colors.white,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.pink,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.white,
              elevation: 8,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.pinkAccent,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.black,
              elevation: 8,
            ),
          ),
          home: const RootHandler(),
        );
      },
    );
  }
}

class RootHandler extends StatelessWidget {
  const RootHandler({super.key});

  Future<bool> _isProfileComplete(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    final data = doc.data();
    return data != null && data['nickname'] != null && data['age'] != null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          final uid = FirebaseAuth.instance.currentUser!.uid;
          return FutureBuilder<bool>(
            future: _isProfileComplete(uid),
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (profileSnapshot.data == true) {
                return const MainScreen();
              } else {
                return CompleteProfileScreen(uid: uid);
              }
            },
          );
        } else {
          return const IntroScreen();
        }
      },
    );
  }
}

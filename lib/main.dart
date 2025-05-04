import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singify/screens/splash_screen.dart';
import 'package:singify/screens/home_screen.dart';
import 'package:singify/screens/favorites_screen.dart';
import 'package:singify/screens/genres_screen.dart';
import 'package:singify/screens/genre_details_screen.dart';
import 'package:singify/screens/search_screen.dart';
import 'package:singify/screens/profile_screen.dart';
import 'package:singify/services/favorites_service.dart';
import 'package:singify/utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesService()),
      ],
      child: MaterialApp(
        title: 'Singify',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
          '/search': (context) => const SearchScreen(),
          '/genres': (context) => const GenresScreen(),
          '/favorites': (context) => const FavoritesScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
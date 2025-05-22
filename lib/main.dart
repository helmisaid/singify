import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singify/screens/splash_screen.dart';
import 'package:singify/screens/home_screen.dart';
import 'package:singify/screens/favorites_screen.dart';
import 'package:singify/screens/genres_screen.dart';
import 'package:singify/screens/genre_details_screen.dart';
import 'package:singify/screens/search_screen.dart';
import 'package:singify/screens/profile_screen.dart';
import 'package:singify/screens/settings_screen.dart';
import 'package:singify/screens/login_screen.dart';
import 'package:singify/services/favorites_service.dart';
import 'package:singify/services/auth/auth_repository.dart';
import 'package:singify/utils/theme.dart';
import 'package:singify/screens/player_screen.dart';
import 'package:singify/screens/album_screen.dart';
import 'package:singify/screens/artist_screen.dart';

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
        Provider(
            create: (_) =>
                AuthRepository()),
      ],
      child: MaterialApp(
        title: 'Singify',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        initialRoute: '/login',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
          '/search': (context) => const SearchScreen(),
          '/genres': (context) => const GenresScreen(),
          '/genre_details': (context) => const GenreDetailsScreen(),
          '/favorites': (context) => const FavoritesScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/login': (context) => const LoginScreen(),
          '/player': (context) => const PlayerScreen(),
          '/artist': (context) => const ArtistScreen(),
        '/album': (context) => const AlbumScreen(),
        },
      ),
    );
  }
}

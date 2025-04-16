import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singify/screens/splash_screen.dart';
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
        home: const SplashScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart'; 
import 'package:hive_flutter/hive_flutter.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'notification_helper.dart'; 
import 'models/spell_favorite.dart'; 
import 'screens/home_screen.dart';
import 'screens/login_screen.dart'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(SpellFavoriteAdapter());

  await Hive.openBox<SpellFavorite>('favorites');

  await initNotification();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  
  runApp(MainApp(isLoggedIn: isLoggedIn));
}


class MainApp extends StatelessWidget {
 
  final bool isLoggedIn;

  const MainApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? HomeScreen() : LoginScreen(),
    );
  }
}

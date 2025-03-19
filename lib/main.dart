import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpaper_app/custom_scroll_behaviour.dart';
import 'package:wallpaper_app/main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      scrollBehavior: CustomScrollBehaviour(),
      home: MainPage(),
    );
  }
}

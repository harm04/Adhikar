import 'package:adhikar/common/widgets/bottom_nav_bar.dart';
import 'package:adhikar/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adhikar',
      debugShowCheckedModeBanner: false,
      theme:AppTheme.theme, 
      home: const BottomNavBar(),
    );
  }
}


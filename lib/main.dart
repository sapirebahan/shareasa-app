
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/home/pages/home_page.dart';

void main() {
  runApp(const ShareasaApp());
}

class ShareasaApp extends StatelessWidget {
  const ShareasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shareasa',
      theme: AppTheme.lightTheme,
      home: HomePage(),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/pages/login_page.dart';
import 'features/home/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://obthnjnaaftzzrsywtqk.supabase.co',
    publishableKey: 'sb_publishable_SnCHTjSVwjS3VCo_38w0aw_ov6kfhau',
  );

  runApp(const ShareasaApp());
}

class ShareasaApp extends StatelessWidget {
  const ShareasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final currentSession = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shareasa',
      theme: AppTheme.lightTheme,
      home: currentSession != null ? const HomePage() : const LoginPage(),
    );
  }
}

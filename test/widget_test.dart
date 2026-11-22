import 'package:flutter_test/flutter_test.dart';
<<<<<<< HEAD

import 'package:shareasa_app/core/theme/app_theme.dart';

void main() {
  testWidgets('App theme smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: Center(child: Text('Shareasa')),
        ),
      ),
    );

    expect(find.text('Shareasa'), findsOneWidget);
=======
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shareasa_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    try {
      await Supabase.initialize(
        url: 'https://obthnjnaaftzzrsywtqk.supabase.co',
        publishableKey: 'sb_publishable_SnCHTjSVwjS3VCo_38w0aw_ov6kfhau',
      );
    } catch (_) {}
  });

  testWidgets('ShareasaApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ShareasaApp());
    await tester.pump();
>>>>>>> 45d6d85ca492a3d5aa9dc37ee87f77b8d4264cb8
  });
}

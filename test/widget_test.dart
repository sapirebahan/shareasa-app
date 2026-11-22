import 'package:flutter_test/flutter_test.dart';
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
  });
}

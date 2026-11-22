import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shareasa_app/features/home/pages/home_page.dart';

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

  testWidgets('Test HomePage BottomNavigationBar on mobile and desktop', (WidgetTester tester) async {
    // 1. Mobile screen (390 x 844)
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );
    await tester.pump();

    // Verify BottomNavigationBar exists
    final bottomNavFinder = find.byType(BottomNavigationBar);
    expect(bottomNavFinder, findsOneWidget);

    final rect = tester.getRect(bottomNavFinder);
    debugPrint('Mobile BottomNav rect: $rect');
    expect(rect.bottom, equals(844.0));
    expect(rect.top, equals(844.0 - 56.0));

    // Verify all 4 tabs exist
    expect(find.text('Beranda'), findsWidgets);
    expect(find.text('Katalog'), findsWidgets);
    expect(find.text('Riwayat'), findsWidgets);
    expect(find.text('Profil'), findsWidgets);

    // 2. Test tapping Katalog tab (index 1)
    await tester.tap(find.text('Katalog').last);
    await tester.pump();
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    debugPrint('Navigated to Katalog tab successfully, bottomNav still visible!');

    // 3. Test tapping Riwayat tab (index 2)
    await tester.tap(find.text('Riwayat').last);
    await tester.pump();
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    debugPrint('Navigated to Riwayat tab successfully, bottomNav still visible!');

    // 4. Test tapping Profil tab (index 3)
    await tester.tap(find.text('Profil').last);
    await tester.pump();
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    debugPrint('Navigated to Profil tab successfully, bottomNav still visible!');

    // 5. Test tapping Beranda tab (index 0)
    await tester.tap(find.text('Beranda').last);
    await tester.pump();
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    debugPrint('Navigated back to Beranda tab successfully, bottomNav still visible!');

    // 6. Test on desktop screen size (1200 x 800)
    tester.view.physicalSize = const Size(1200, 800);
    await tester.pump();
    final desktopRect = tester.getRect(bottomNavFinder);
    debugPrint('Desktop BottomNav rect: $desktopRect');
    expect(desktopRect.bottom, equals(800.0));
    expect(desktopRect.top, equals(800.0 - 56.0));
  });
}

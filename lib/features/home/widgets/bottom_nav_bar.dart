import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ShareasaBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ShareasaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 8,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: AppTheme.primary,
      unselectedItemColor: Colors.grey.shade500,
      selectedFontSize: 12,
      unselectedFontSize: 11,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.2,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          activeIcon: Icon(Icons.home_rounded, size: 26),
          label: 'Beranda',
          tooltip: 'Beranda Utama',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.storefront_rounded),
          activeIcon: Icon(Icons.storefront_rounded, size: 26),
          label: 'Katalog',
          tooltip: 'Katalog Makanan UMKM',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_rounded),
          activeIcon: Icon(Icons.history_rounded, size: 26),
          label: 'Riwayat',
          tooltip: 'Riwayat Donasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          activeIcon: Icon(Icons.person_rounded, size: 26),
          label: 'Profil',
          tooltip: 'Profil Saya',
        ),
      ],
    );
  }
}

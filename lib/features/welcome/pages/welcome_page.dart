import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../home/pages/home_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Future<void> _handleStart(BuildContext context) async {
    try {
      // Tandai metadata pengguna bahwa sudah pernah melihat welcome screen
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'has_seen_welcome': true}),
      );
    } catch (_) {
      // Abaikan jika offline / update metadata gagal
    }

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Logo Shareasa sebagai identitas utama
                  Center(
                    child: Image.asset(
                      'assets/images/logo_shareasa.png',
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. Hero Image Utama
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.darkBrown.withOpacity(0.12),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/welcome_shareasa.jpeg',
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/welcome_shareasa.jpg',
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, err2, st2) => Container(
                                  height: 250,
                                  color: Colors.orange.shade100,
                                  child: const Icon(
                                    Icons.soup_kitchen_rounded,
                                    size: 60,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              );
                            },
                          ),
                          // Gradient halus di bagian bawah foto
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.45),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Badge Tematik di atas foto
                          Positioned(
                            bottom: 12,
                            left: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.92),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.volunteer_activism_rounded,
                                    size: 14,
                                    color: AppTheme.primary,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Komunitas Berbagi Makanan',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.darkBrown,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // 3. Highlight Kartu / Pills Tematik
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFeatureBadge(
                        Icons.restaurant_rounded,
                        'Dukung UMKM',
                        AppTheme.primary,
                        Colors.orange.shade50,
                      ),
                      const SizedBox(width: 10),
                      _buildFeatureBadge(
                        Icons.soup_kitchen_rounded,
                        'Donasi Porsi',
                        AppTheme.green,
                        Colors.green.shade50,
                      ),
                      const SizedBox(width: 10),
                      _buildFeatureBadge(
                        Icons.favorite_rounded,
                        'Bantu Sesama',
                        const Color(0xFFE56A54),
                        Colors.red.shade50,
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // 4. Judul
                  const Text(
                    'Selamat Datang di Shareasa!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBrown,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 5. Deskripsi
                  Text(
                    'Berbagi makanan, hadirkan kebahagiaan. Mulai langkah kecilmu untuk berbagi bersama UMKM lokal.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppTheme.darkBrown.withOpacity(0.75),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 6. Tombol Utama "Mulai Sekarang"
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => _handleStart(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: AppTheme.primary.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Mulai Sekarang',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Footer catatan santun
                  Text(
                    'Satu porsi berharga untuk senyuman bersama ✨',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.darkBrown.withOpacity(0.55),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureBadge(
    IconData icon,
    String label,
    Color color,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

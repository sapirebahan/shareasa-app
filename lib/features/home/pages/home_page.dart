import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/pages/login_page.dart';
<<<<<<< HEAD
import '../../umkm/pages/umkm_detail_page.dart';
import '../../orders/pages/orders_page.dart';
import '../../orders/pages/history_page.dart';
import '../../profile/pages/profile_page.dart';
=======
import '../../umkm/pages/katalog_page.dart';
import '../widgets/bottom_nav_bar.dart';
>>>>>>> 45d6d85ca492a3d5aa9dc37ee87f77b8d4264cb8

class HomePage extends StatefulWidget {
  final int initialIndex;

  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
<<<<<<< HEAD
  int _selectedIndex = 0;
=======
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }
>>>>>>> 45d6d85ca492a3d5aa9dc37ee87f77b8d4264cb8

  // Mengambil data UMKM dari Supabase
  Future<List<Map<String, dynamic>>> _getUmkm() async {
    final response = await Supabase.instance.client
        .from('umkm')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // Mengambil produk untuk mengetahui harga termurah setiap UMKM
  Future<double?> _getHargaTermurah(dynamic umkmId) async {
    final response = await Supabase.instance.client
        .from('products')
        .select('harga')
        .eq('umkm_id', umkmId)
        .order('harga', ascending: true)
        .limit(1);

    if (response.isEmpty) return null;

    return (response.first['harga'] as num).toDouble();
  }

  // Fungsi Logout dengan Dialog Konfirmasi
  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppTheme.primary),
            SizedBox(width: 8),
            Text(
              'Keluar Akun',
              style: TextStyle(
                color: AppTheme.darkBrown,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin logout dari aplikasi Shareasa?',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(
<<<<<<< HEAD
        index: _selectedIndex,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                // HEADER
=======
        index: _currentIndex,
        children: [
          // 0. TAB BERANDA / DASHBOARD
          _buildDashboardView(),

          // 1. TAB KATALOG UMKM
          KatalogPage(
            isEmbedded: true,
            onTabSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),

          // 2. TAB RIWAYAT
          _buildRiwayatView(),

          // 3. TAB PROFIL
          _buildProfilView(),
        ],
      ),

      // BOTTOM NAVIGATION BAR RESPONSIF & SELALU TERLIHAT
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
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
        elevation: 8,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
      ),
    );
  }

  // ==========================================
  // VIEW TAB 0: DASHBOARD / BERANDA UTAMA
  // ==========================================
  Widget _buildDashboardView() {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER LOGO & PROFIL
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo_shareasa.png',
                        height: 44,
                        fit: BoxFit.contain,
                      ),
                      PopupMenuButton<String>(
                        tooltip: 'Menu Akun',
                        offset: const Offset(0, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onSelected: (value) {
                          if (value == 'logout') {
                            _handleLogout();
                          } else if (value == 'profile') {
                            setState(() {
                              _currentIndex = 3;
                            });
                          }
                        },
                        itemBuilder: (context) {
                          final userEmail = Supabase.instance.client.auth.currentUser?.email ?? 'Sahabat Shareasa';
                          return [
                            PopupMenuItem(
                              enabled: false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Masuk sebagai:',
                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    userEmail,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.darkBrown,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Divider(height: 16),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'profile',
                              child: Row(
                                children: [
                                  Icon(Icons.person_outline_rounded, color: AppTheme.darkBrown, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Lihat Profil',
                                    style: TextStyle(color: AppTheme.darkBrown, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'logout',
                              child: Row(
                                children: [
                                  Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Keluar (Logout)',
                                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ];
                        },
                        child: CircleAvatar(
                          radius: 23,
                          backgroundColor: Colors.orange.shade100,
                          child: const Icon(
                            Icons.person,
                            color: AppTheme.primary,
                            size: 26,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Salam & Slogan
                  const Text(
                    'Halo, Sahabat Shareasa! 👋',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Berbagi Kebaikan,\nMulai dari Makanan.',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBrown,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // BANNER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Satu Pesanan,\nBanyak Kebahagiaan ❤️',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Pesan produk dari UMKM dan kirimkan '
                          'kebaikan kepada mereka yang membutuhkan.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Mulai Berbagi',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // STATISTIK
                  const Text(
                    'Dampak Kebaikanmu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBrown,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _buildStatCard(
                        icon: Icons.restaurant,
                        title: 'Produk Dibagikan',
                        value: '0',
                        color: Colors.orange.shade100,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        icon: Icons.volunteer_activism,
                        title: 'Total Donasi',
                        value: 'Rp0',
                        color: Colors.green.shade100,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // UMKM PILIHAN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'UMKM Pilihan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkBrown,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _currentIndex = 1;
                          });
                        },
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _getUmkm(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(25),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return _buildMessage(
                          'Gagal mengambil data UMKM.\n${snapshot.error}',
                        );
                      }

                      final umkmList = snapshot.data ?? [];

                      if (umkmList.isEmpty) {
                        return _buildMessage(
                          'Belum ada UMKM tersedia.\n'
                          'Tambahkan data melalui Supabase.',
                        );
                      }

                      return Column(
                        children: umkmList.map((umkm) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _currentIndex = 1;
                                });
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: FutureBuilder<double?>(
                                future: _getHargaTermurah(umkm['id']),
                                builder: (context, hargaSnapshot) {
                                  final harga = hargaSnapshot.data;

                                  return _buildUmkmCard(
                                    name: umkm['nama_umkm'] ?? 'UMKM Tanpa Nama',
                                    category: umkm['kategori'] ?? 'Kategori belum tersedia',
                                    price: hargaSnapshot.connectionState == ConnectionState.waiting
                                        ? 'Memuat harga...'
                                        : harga != null
                                            ? 'Mulai ${_formatRupiah(harga)}'
                                            : 'Produk belum tersedia',
                                    icon: Icons.storefront,
                                  );
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // VIEW TAB 2: RIWAYAT AKTIVITAS & DONASI
  // ==========================================
  Widget _buildRiwayatView() {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Logo & Badge Riwayat
>>>>>>> 45d6d85ca492a3d5aa9dc37ee87f77b8d4264cb8
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_shareasa.png',
                      height: 44,
                      fit: BoxFit.contain,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.green.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.green.withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.history_rounded, size: 14, color: AppTheme.green),
                          SizedBox(width: 5),
                          Text(
                            'Riwayat Aktivitas',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  'Riwayat Berbagi & Donasi 📜',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBrown,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pantau jejak kebaikan dan makanan berkah yang telah kamu salurkan.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.darkBrown.withOpacity(0.75),
                  ),
                ),

                const SizedBox(height: 30),

                // Card Empty State Riwayat
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          size: 48,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Belum Ada Riwayat Donasi',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkBrown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Setiap porsi makanan dari UMKM lokal yang kamu bagikan untuk sesama akan tercatat rapi di sini.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.darkBrown.withOpacity(0.7),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 22),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _currentIndex = 1;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 1,
                        ),
                        icon: const Icon(Icons.storefront_rounded, size: 18),
                        label: const Text(
                          'Jelajahi Menu Makanan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Tips Panduan Berbagi
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange.shade100),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.tips_and_updates_outlined, color: AppTheme.primary, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tahukah Kamu?',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkBrown,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Satu porsi makanan yang kamu beli dari UMKM mitra secara otomatis diantarkan kepada mereka yang membutuhkan di sekitarmu.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.darkBrown.withOpacity(0.75),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
<<<<<<< HEAD
                      );
                    }

                    if (snapshot.hasError) {
                      return _buildMessage(
                        'Gagal mengambil data UMKM.\n${snapshot.error}',
                      );
                    }

                    final umkmList = snapshot.data ?? [];

                    if (umkmList.isEmpty) {
                      return _buildMessage(
                        'Belum ada UMKM tersedia.\n'
                        'Tambahkan data melalui Supabase.',
                      );
                    }

                    return Column(
                      children: umkmList.map((umkm) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FutureBuilder<double?>(
                            future: _getHargaTermurah(umkm['id']),
                            builder: (context, hargaSnapshot) {
                              final harga = hargaSnapshot.data;

                              return _buildUmkmCard(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => UmkmDetailPage(
                                        umkmId: umkm['id'].toString(),
                                        umkmName:
                                            (umkm['nama_umkm'] ??
                                                    'UMKM Tanpa Nama')
                                                .toString(),
                                      ),
                                    ),
                                  );
                                },
                                name: umkm['nama_umkm'] ??
                                    'UMKM Tanpa Nama',
                                category: umkm['kategori'] ??
                                    'Kategori belum tersedia',
                                price: hargaSnapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? 'Memuat harga...'
                                    : harga != null
                                        ? 'Mulai ${_formatRupiah(harga)}'
                                        : 'Produk belum tersedia',
                                icon: Icons.storefront,
                              );
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
=======
                      ),
                    ],
                  ),
>>>>>>> 45d6d85ca492a3d5aa9dc37ee87f77b8d4264cb8
                ),
                  ],
                ),
              ),
            ),
          ),
          const OrdersPage(),
          const HistoryPage(),
          const ProfilePage(),
        ],
      ),
    );
  }

<<<<<<< HEAD
      // NAVIGASI BAWAH
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Beranda',
=======
  // ==========================================
  // VIEW TAB 3: PROFIL PENGGUNA & AKUN
  // ==========================================
  Widget _buildProfilView() {
    final userEmail = Supabase.instance.client.auth.currentUser?.email ?? 'Sahabat Shareasa';

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Logo & Badge Profil
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_shareasa.png',
                      height: 44,
                      fit: BoxFit.contain,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_outline_rounded, size: 14, color: AppTheme.primary),
                          SizedBox(width: 5),
                          Text(
                            'Profil Akun',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Card Identitas Akun
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.orange.shade50,
                        child: const Icon(
                          Icons.person_rounded,
                          size: 38,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userEmail,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkBrown,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.green.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.verified_rounded, size: 12, color: AppTheme.green),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      'Donatur Terverifikasi',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Menu Pengaturan & Informasi
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildProfileMenuItem(
                        icon: Icons.mark_email_read_outlined,
                        title: 'Email Terdaftar',
                        subtitle: userEmail,
                        showArrow: false,
                      ),
                      const Divider(height: 1, indent: 60),
                      _buildProfileMenuItem(
                        icon: Icons.shield_outlined,
                        title: 'Keamanan Akun',
                        subtitle: 'Kata sandi & perlindungan data aktif',
                        showArrow: true,
                      ),
                      const Divider(height: 1, indent: 60),
                      _buildProfileMenuItem(
                        icon: Icons.volunteer_activism_outlined,
                        title: 'Misi Kebaikan Shareasa',
                        subtitle: 'Pemberdayaan UMKM & pembagian makanan',
                        showArrow: true,
                      ),
                      const Divider(height: 1, indent: 60),
                      _buildProfileMenuItem(
                        icon: Icons.info_outline_rounded,
                        title: 'Versi Aplikasi',
                        subtitle: 'Shareasa App v1.0.0',
                        showArrow: false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Tombol Keluar (Logout)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _handleLogout,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text(
                      'Keluar dari Akun',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
>>>>>>> 45d6d85ca492a3d5aa9dc37ee87f77b8d4264cb8
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool showArrow,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppTheme.darkBrown,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: showArrow ? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey) : null,
    );
  }

  // FORMAT RUPIAH
  String _formatRupiah(double harga) {
    return 'Rp${harga.toStringAsFixed(0)}';
  }

  // PESAN STATUS
  Widget _buildMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    );
  }

  // WIDGET STATISTIK
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: AppTheme.darkBrown),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkBrown,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET KARTU UMKM
  Widget _buildUmkmCard({
    required String name,
    required String category,
    required String price,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 35,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.green,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

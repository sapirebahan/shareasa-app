

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
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
                      onSelected: (value) async {
                        if (value == 'logout') {
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

                          if (confirm == true && context.mounted) {
                            await Supabase.instance.client.auth.signOut();
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginPage()),
                                (route) => false,
                              );
                            }
                          }
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
                        radius: 25,
                        backgroundColor: Colors.orange.shade100,
                        child: const Icon(
                          Icons.person,
                          color: AppTheme.primary,
                          size: 30,
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
                        onPressed: () {},
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
                    const Text(
                      'UMKM Pilihan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkBrown,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _getUmkm(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
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
                          child: FutureBuilder<double?>(
                            future: _getHargaTermurah(umkm['id']),
                            builder: (context, hargaSnapshot) {
                              final harga = hargaSnapshot.data;

                              return _buildUmkmCard(
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
                ),
              ],
            ),
          ),
        ),
      ),

      // NAVIGASI BAWAH
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
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
  }) {
    return Container(
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
    );
  }
}

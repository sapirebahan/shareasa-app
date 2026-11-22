import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/food_item.dart';

class FoodDetailPage extends StatefulWidget {
  final FoodItem food;

  const FoodDetailPage({super.key, required this.food});

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  int _porsiCount = 1;

  void _increment() {
    setState(() {
      _porsiCount++;
    });
  }

  void _decrement() {
    if (_porsiCount > 1) {
      setState(() {
        _porsiCount--;
      });
    }
  }

  void _showOrderSuccessDialog() {
    final total = widget.food.harga * _porsiCount;
    final totalStr = 'Rp${total.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.green.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.volunteer_activism_rounded,
                color: AppTheme.green,
                size: 44,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Niat Kebaikan Dicatat! ✨',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Anda memilih $_porsiCount porsi "${widget.food.nama}" dari ${widget.food.namaUmkm} dengan total donasi $totalStr.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.darkBrown.withOpacity(0.75),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.orange.shade100),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppTheme.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Sistem pembayaran dan penyaluran otomatis akan segera aktif pada pembaruan berikutnya.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.darkBrown.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Colors.white),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Terima kasih telah mendukung ${widget.food.namaUmkm}!',
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: AppTheme.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 1,
                ),
                child: const Text(
                  'Mengerti & Kembali',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    final totalHarga = food.harga * _porsiCount;
    final totalStr = 'Rp${totalHarga.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // APP BAR DENGAN FOTO MAKANAN
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppTheme.primary,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppTheme.darkBrown),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: IconButton(
                    icon: const Icon(Icons.share_outlined, size: 20, color: AppTheme.darkBrown),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tautan ${food.nama} disalin untuk dibagikan!'),
                          backgroundColor: AppTheme.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    food.fotoUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: Colors.orange.shade50,
                        child: const Center(
                          child: CircularProgressIndicator(color: AppTheme.primary, strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.orange.shade100,
                        child: const Center(
                          child: Icon(Icons.restaurant_menu_rounded, size: 60, color: AppTheme.primary),
                        ),
                      );
                    },
                  ),
                  // Gradient shadow bawah foto
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Badge kategori di sudut kiri bawah foto
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            food.kategori,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (food.badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppTheme.green,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified_rounded, color: Colors.white, size: 12),
                                const SizedBox(width: 4),
                                Text(
                                  food.badge!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // KONTEN DETAIL MAKANAN
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAMA MAKANAN & HARGA
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          food.nama,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkBrown,
                            height: 1.25,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        food.hargaFormatted,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // STATS: RATING, TERJUAL, PORSI
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${food.rating}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkBrown,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.volunteer_activism_rounded, color: AppTheme.primary, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${food.jumlahDonasi}+ tersalurkan',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.darkBrown.withOpacity(0.75),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inventory_2_outlined, color: Colors.grey.shade600, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            food.porsiTersedia,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // KARTU UMKM
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: const Icon(
                            Icons.storefront_rounded,
                            color: AppTheme.primary,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    food.namaUmkm,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.darkBrown,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.check_circle_rounded, color: AppTheme.green, size: 14),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 13, color: Colors.grey.shade600),
                                  const SizedBox(width: 2),
                                  Text(
                                    food.lokasi,
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.green.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'UMKM Mitra',
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

                  const SizedBox(height: 20),

                  // DESKRIPSI MENU
                  const Text(
                    'Deskripsi Makanan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    food.deskripsi,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.darkBrown.withOpacity(0.8),
                      height: 1.55,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // NILAI BERBAGI SHAREASA
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.volunteer_activism_rounded, color: AppTheme.primary, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Kenapa Berbagi Melalui Shareasa?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkBrown,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildBenefitRow(Icons.restaurant_rounded, 'Dukungan nyata perputaran ekonomi bagi UMKM kuliner lokal.'),
                        const SizedBox(height: 6),
                        _buildBenefitRow(Icons.verified_rounded, 'Makanan disiapkan segar, higienis, dan terjamin kelezatannya.'),
                        const SizedBox(height: 6),
                        _buildBenefitRow(Icons.favorite_rounded, 'Langsung dinikmati penerima manfaat yang membutuhkan.'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100), // Spacing untuk bottom bar
                ],
              ),
            ),
          ),
        ],
      ),

      // BOTTOM BAR PEMESANAN / DONASI
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Pengatur jumlah porsi
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade100),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      color: AppTheme.darkBrown,
                      onPressed: _decrement,
                    ),
                    Text(
                      '$_porsiCount',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkBrown,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      color: AppTheme.primary,
                      onPressed: _increment,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Total dan Tombol
              Expanded(
                child: ElevatedButton(
                  onPressed: _showOrderSuccessDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.volunteer_activism_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Donasikan ($totalStr)',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: AppTheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.darkBrown.withOpacity(0.85),
            ),
          ),
        ),
      ],
    );
  }
}

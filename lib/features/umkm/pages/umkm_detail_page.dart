import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../product/pages/product_detail_page.dart';

class UmkmDetailPage extends StatefulWidget {
  final String umkmId;
  final String umkmName;

  const UmkmDetailPage({
    super.key,
    required this.umkmId,
    required this.umkmName,
  });

  @override
  State<UmkmDetailPage> createState() => _UmkmDetailPageState();
}

class _UmkmDetailPageState extends State<UmkmDetailPage> {
  late final Future<Map<String, dynamic>?> _umkmFuture;
  late final Future<List<Map<String, dynamic>>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _umkmFuture = _getUmkm();
    _productsFuture = _getProducts();
  }

  Future<Map<String, dynamic>?> _getUmkm() async {
    final response = await Supabase.instance.client
        .from('umkm')
        .select()
        .eq('id', widget.umkmId)
        .maybeSingle();

    return response == null
        ? null
        : Map<String, dynamic>.from(response);
  }

  Future<List<Map<String, dynamic>>> _getProducts() async {
    final response = await Supabase.instance.client
        .from('products')
        .select()
        .eq('umkm_id', widget.umkmId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String _formatRupiah(num value) {
    return 'Rp${value.toStringAsFixed(0)}';
  }

  Widget _buildFallbackImage({double height = 180}) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.orange.shade50,
      child: const Icon(
        Icons.storefront,
        size: 64,
        color: AppTheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.darkBrown),
        title: Text(
          widget.umkmName,
          style: const TextStyle(
            color: AppTheme.darkBrown,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<Map<String, dynamic>?>(
                future: _umkmFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return _buildMessage(
                      'Gagal mengambil informasi UMKM.',
                    );
                  }

                  final umkm = snapshot.data;
                  if (umkm == null) {
                    return _buildMessage('Informasi UMKM tidak ditemukan.');
                  }

                  final name = (umkm['nama_umkm'] ?? widget.umkmName).toString();
                  final category =
                      (umkm['kategori'] ?? 'Kategori belum tersedia').toString();
                  final description =
                      (umkm['deskripsi'] ?? 'Deskripsi belum tersedia').toString();
                  final address =
                      (umkm['alamat'] ?? 'Alamat belum tersedia').toString();
                  final phone = (umkm['no_hp'] as String?);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: _buildFallbackImage(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkBrown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Tentang UMKM',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkBrown,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: AppTheme.darkBrown.withOpacity(0.75),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildInfoRow(Icons.location_on_outlined, address),
                      if (phone != null && phone.trim().isNotEmpty)
                        _buildInfoRow(Icons.phone_outlined, phone),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Produk UMKM',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBrown,
                ),
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return _buildMessage('Gagal mengambil daftar produk.');
                  }

                  final products = snapshot.data ?? [];
                  if (products.isEmpty) {
                    return _buildMessage(
                      'Belum ada produk tersedia untuk UMKM ini.',
                    );
                  }

                  return Column(
                    children: products.map((product) {
                      final name =
                          (product['nama_produk'] ?? 'Produk Tanpa Nama').toString();
                      final description =
                          (product['deskripsi'] ?? '').toString();
                      final price = (product['harga'] as num?)?.toDouble() ?? 0;
                      final fotoUrl = product['foto_url'] as String?;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailPage(product: product),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: fotoUrl != null &&
                                          fotoUrl.trim().isNotEmpty
                                      ? Image.network(
                                          fotoUrl,
                                          width: 82,
                                          height: 82,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              _buildFallbackImage(height: 82)
                                                  .withWidth(82),
                                        )
                                      : _buildFallbackImage(height: 82)
                                          .withWidth(82),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.darkBrown,
                                        ),
                                      ),
                                      if (description.isNotEmpty) ...[
                                        const SizedBox(height: 5),
                                        Text(
                                          description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 8),
                                      Text(
                                        _formatRupiah(price),
                                        style: const TextStyle(
                                          fontSize: 13,
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
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.darkBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      ),
    );
  }
}

extension _WidgetSizeExtension on Widget {
  Widget withWidth(double width) {
    return SizedBox(width: width, child: this);
  }
}

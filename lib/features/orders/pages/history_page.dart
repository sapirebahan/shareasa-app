import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_theme.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Map<String, dynamic>>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _getHistory();
  }

  Future<List<Map<String, dynamic>>> _getHistory() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];

    final response = await Supabase.instance.client
        .from('orders')
        .select()
        .eq('donor_id', user.id)
        .inFilter('status', ['disalurkan', 'dibatalkan'])
        .order('created_at', ascending: false);

    final orders = (response as List)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    for (final order in orders) {
      final productId = order['product_id'];
      if (productId == null) continue;

      try {
        final product = await Supabase.instance.client
            .from('products')
            .select('nama_produk, foto_url, harga')
            .eq('id', productId)
            .maybeSingle();
        order['_product'] =
            product == null ? null : Map<String, dynamic>.from(product);
      } catch (_) {
        order['_product'] = null;
      }
    }

    return orders;
  }

  String _formatRupiah(num value) {
    return 'Rp${value.toStringAsFixed(0)}';
  }

  String _statusLabel(String status) {
    return status == 'disalurkan' ? 'Sudah Disalurkan' : 'Dibatalkan';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                'Riwayat',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBrown,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _historyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return _buildMessage(
                      'Riwayat pesanan belum dapat dimuat karena sistem database belum mengizinkan akses pesanan.',
                    );
                  }

                  final orders = snapshot.data ?? [];
                  if (orders.isEmpty) {
                    return _buildMessage(
                      'Belum ada riwayat pesanan.',
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final product =
                          order['_product'] as Map<String, dynamic>?;
                      final name = product == null
                          ? 'Produk tidak tersedia'
                          : (product['nama_produk'] ?? 'Produk Tanpa Nama')
                              .toString();
                      final quantity =
                          (order['jumlah'] as num?)?.toInt() ?? 0;
                      final total =
                          (order['total_harga'] as num?)?.toDouble() ?? 0;
                      final status =
                          (order['status'] ?? 'dibatalkan').toString();
                      final fotoUrl = product?['foto_url'] as String?;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
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
                                      width: 74,
                                      height: 74,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _buildFallbackImage(),
                                    )
                                  : _buildFallbackImage(),
                            ),
                            const SizedBox(width: 12),
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
                                    'Jumlah: $quantity',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    _formatRupiah(total),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.green,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: status == 'disalurkan'
                                          ? Colors.green.shade50
                                          : Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _statusLabel(status),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: status == 'disalurkan'
                                            ? AppTheme.green
                                            : Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      width: 74,
      height: 74,
      color: Colors.orange.shade50,
      child: const Icon(
        Icons.restaurant,
        color: AppTheme.primary,
      ),
    );
  }

  Widget _buildMessage(String message) {
    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
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
      ),
    );
  }
}

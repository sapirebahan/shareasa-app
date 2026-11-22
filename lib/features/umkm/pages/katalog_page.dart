import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/pages/home_page.dart';
import '../models/food_item.dart';
import 'food_detail_page.dart';

class KatalogPage extends StatefulWidget {
  final String? initialCategory;
  final bool isEmbedded;
  final ValueChanged<int>? onTabSelected;

  const KatalogPage({
    super.key,
    this.initialCategory,
    this.isEmbedded = false,
    this.onTabSelected,
  });

  @override
  State<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage> {
  final TextEditingController _searchController = TextEditingController();
  late String _selectedCategory;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'Semua';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FoodItem> get _filteredFoods {
    return FoodItem.dummyFoods.where((food) {
      // Filter Kategori
      final matchesCategory = _selectedCategory == 'Semua' ||
          food.kategori.toLowerCase() == _selectedCategory.toLowerCase();

      // Filter Pencarian (Nama Makanan atau Nama UMKM)
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          food.nama.toLowerCase().contains(query) ||
          food.namaUmkm.toLowerCase().contains(query) ||
          food.deskripsi.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Makanan Berat':
        return Icons.restaurant_rounded;
      case 'Snack':
        return Icons.cookie_outlined;
      case 'Minuman':
        return Icons.local_cafe_outlined;
      case 'Paket Makanan':
        return Icons.inventory_2_outlined;
      default:
        return Icons.fastfood_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredFoods = _filteredFoods;

    final content = SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: CustomScrollView(
            slivers: [
              // 1. HEADER DENGAN LOGO SHAREASA & SAPAAN
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Baris Header: Logo & Tombol Kembali jika relevan
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              if (!widget.isEmbedded && Navigator.canPop(context)) ...[
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                      size: 20, color: AppTheme.darkBrown),
                                  onPressed: () => Navigator.pop(context),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 12),
                              ],
                                Image.asset(
                                  'assets/images/logo_shareasa.png',
                                  height: 42,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Row(
                                    children: [
                                      Icon(Icons.soup_kitchen_rounded,
                                          color: AppTheme.primary, size: 30),
                                      SizedBox(width: 6),
                                      Text(
                                        'Shareasa',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.darkBrown,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppTheme.green.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppTheme.green.withValues(alpha: 0.3)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.volunteer_activism_rounded,
                                      size: 14, color: AppTheme.green),
                                  SizedBox(width: 5),
                                  Text(
                                    'Katalog UMKM',
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

                        const SizedBox(height: 18),

                        // Sapaan Singkat
                        const Text(
                          'Mau Berbagi Apa Hari Ini? 🍲',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkBrown,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pilih aneka sajian lezat dari UMKM lokal untuk berbagi berkah bersama.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.darkBrown.withValues(alpha: 0.75),
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // 2. SEARCH BAR
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Cari makanan lezat atau nama UMKM...',
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: AppTheme.primary,
                                size: 22,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded,
                                          size: 18, color: Colors.grey),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          _searchQuery = '';
                                        });
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Colors.orange.shade100, width: 0.8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: AppTheme.primary, width: 1.5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // 3. KATEGORI FILTER
                        const Text(
                          'Kategori Makanan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkBrown,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                // Kategori Chips Horizontal
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 42,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: FoodItem.kategoriList.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = FoodItem.kategoriList[index];
                        final isSelected = _selectedCategory == cat;

                        return ChoiceChip(
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 6),
                          avatar: Icon(
                            _getCategoryIcon(cat),
                            size: 16,
                            color: isSelected ? Colors.white : AppTheme.primary,
                          ),
                          label: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.darkBrown,
                            ),
                          ),
                          backgroundColor: Colors.white,
                          selectedColor: AppTheme.primary,
                          elevation: isSelected ? 1 : 0,
                          pressElevation: 1,
                          side: BorderSide(
                            color: isSelected
                                ? AppTheme.primary
                                : Colors.orange.shade100,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Status Hasil Pencarian / Filter
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daftar Menu (${filteredFoods.length})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkBrown,
                          ),
                        ),
                        if (_selectedCategory != 'Semua' ||
                            _searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {
                                _selectedCategory = 'Semua';
                                _searchQuery = '';
                              });
                            },
                            child: const Text(
                              'Reset Filter',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // 4. DAFTAR MAKANAN (GRID RESPONSIF)
                if (filteredFoods.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.search_off_rounded,
                                size: 50,
                                color: AppTheme.primary.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Makanan Tidak Ditemukan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkBrown,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Coba gunakan kata kunci lain atau pilih kategori yang berbeda.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.darkBrown.withValues(alpha: 0.65),
                              ),
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton.icon(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _selectedCategory = 'Semua';
                                  _searchQuery = '';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.refresh_rounded, size: 16),
                              label: const Text('Tampilkan Semua Makanan'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverLayoutBuilder(
                      builder: (context, constraints) {
                        // Tentukan jumlah kolom responsif berdasarkan lebar layar
                        final width = constraints.crossAxisExtent;
                        int crossAxisCount = 2; // Mobile default 2 kolom
                        double childAspectRatio = 0.68;

                        if (width >= 900) {
                          crossAxisCount = 4;
                          childAspectRatio = 0.74;
                        } else if (width >= 600) {
                          crossAxisCount = 3;
                          childAspectRatio = 0.72;
                        }

                        return SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: childAspectRatio,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final food = filteredFoods[index];
                              return _buildFoodCard(food);
                            },
                            childCount: filteredFoods.length,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

    if (widget.isEmbedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
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
          if (widget.onTabSelected != null) {
            widget.onTabSelected!(index);
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => HomePage(initialIndex: index),
              ),
              (route) => false,
            );
          }
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

  // WIDGET KARTU MAKANAN
  Widget _buildFoodCard(FoodItem food) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FoodDetailPage(food: food),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO MAKANAN DENGAN BADGE
            Expanded(
              flex: 5,
              child: Stack(
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
                          child: CircularProgressIndicator(
                            color: AppTheme.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.orange.shade100,
                        child: const Center(
                          child: Icon(
                            Icons.restaurant_menu_rounded,
                            size: 32,
                            color: AppTheme.primary,
                          ),
                        ),
                      );
                    },
                  ),
                  // Kategori tag di foto
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        food.kategori,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Badge tambahan jika ada
                  if (food.badge != null)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          food.badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // INFORMASI MAKANAN
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama Makanan
                        Text(
                          food.nama,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkBrown,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Nama UMKM
                        Row(
                          children: [
                            Icon(
                              Icons.storefront_rounded,
                              size: 13,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                food.namaUmkm,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Harga & Tombol Aksi
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              food.hargaFormatted,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.green,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                size: 13,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

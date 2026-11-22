class FoodItem {
  final String id;
  final String nama;
  final String namaUmkm;
  final double harga;
  final String kategori;
  final String deskripsi;
  final String fotoUrl;
  final double rating;
  final int jumlahDonasi;
  final String porsiTersedia;
  final String lokasi;
  final String? badge;

  const FoodItem({
    required this.id,
    required this.nama,
    required this.namaUmkm,
    required this.harga,
    required this.kategori,
    required this.deskripsi,
    required this.fotoUrl,
    this.rating = 4.8,
    this.jumlahDonasi = 85,
    this.porsiTersedia = '15 porsi tersedia',
    this.lokasi = 'Surabaya',
    this.badge,
  });

  String get hargaFormatted {
    final str = harga.toInt().toString();
    return 'Rp${str.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  static const List<String> kategoriList = [
    'Semua',
    'Makanan Berat',
    'Snack',
    'Minuman',
    'Paket Makanan',
  ];

  static const List<FoodItem> dummyFoods = [
    FoodItem(
      id: 'f1',
      nama: 'Nasi Ayam Bakar Madu',
      namaUmkm: 'Dapur Berkah Bu Siti',
      harga: 18000,
      kategori: 'Makanan Berat',
      deskripsi:
          'Ayam bakar empuk bumbu madu khas Nusantara, disajikan dengan nasi hangat, sambal terasi segar, tahu, tempe, dan lalapan renyah. Siap dibagikan untuk saudara kita yang membutuhkan.',
      fotoUrl:
          'https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?auto=format&fit=crop&w=600&q=80',
      rating: 4.9,
      jumlahDonasi: 142,
      porsiTersedia: '20 porsi tersedia',
      lokasi: 'Sukolilo, Surabaya',
      badge: 'Favorit Donatur',
    ),
    FoodItem(
      id: 'f2',
      nama: 'Nasi Rendang Padang Asli',
      namaUmkm: 'RM Minang Saiyo',
      harga: 24000,
      kategori: 'Makanan Berat',
      deskripsi:
          'Daging rendang sapi pilihan dimasak perlahan dengan rempah Minang autentik dan santan kental, disajikan lengkap dengan sayur nangka gurih dan sambal ijo.',
      fotoUrl:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
      rating: 4.9,
      jumlahDonasi: 98,
      porsiTersedia: '15 porsi tersedia',
      lokasi: 'Gubeng, Surabaya',
      badge: 'Pilihan Utama',
    ),
    FoodItem(
      id: 'f3',
      nama: 'Soto Ayam Lamongan Gurih',
      namaUmkm: 'Soto Cak Har Barokah',
      harga: 16000,
      kategori: 'Makanan Berat',
      deskripsi:
          'Kuah kuning soto ayam kaya rempah harum dengan taburan koya renyah, suwiran ayam kampung empuk, soun, tauge, telur rebus, dan sambal cabai rawit.',
      fotoUrl:
          'https://images.unsplash.com/photo-1572656631137-7935297eff55?auto=format&fit=crop&w=600&q=80',
      rating: 4.8,
      jumlahDonasi: 110,
      porsiTersedia: '25 porsi tersedia',
      lokasi: 'Mulyorejo, Surabaya',
    ),
    FoodItem(
      id: 'f4',
      nama: 'Martabak Manis Cokelat Keju',
      namaUmkm: 'Martabak Bangka 88',
      harga: 22000,
      kategori: 'Snack',
      deskripsi:
          'Martabak manis tebal berpori sempurna dengan olesan mentega wangi, taburan keju cheddar melimpah dan cokelat meses berkualitas. Cocok untuk takjil dan camilan sore.',
      fotoUrl:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=600&q=80',
      rating: 4.7,
      jumlahDonasi: 76,
      porsiTersedia: '12 porsi tersedia',
      lokasi: 'Rungkut, Surabaya',
      badge: 'Camilan Populer',
    ),
    FoodItem(
      id: 'f5',
      nama: 'Pisang Goreng Wijen Madu',
      namaUmkm: 'Kedai Camilan Bu Yanti',
      harga: 12000,
      kategori: 'Snack',
      deskripsi:
          'Pisang raja matang manis berbalut tepung renyah bertopping biji wijen harum dan siraman madu murni. Renyah di luar dan lumer di dalam.',
      fotoUrl:
          'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?auto=format&fit=crop&w=600&q=80',
      rating: 4.8,
      jumlahDonasi: 95,
      porsiTersedia: '30 porsi tersedia',
      lokasi: 'Wonokromo, Surabaya',
    ),
    FoodItem(
      id: 'f6',
      nama: 'Tahu Walik Krispi Sambal Petis',
      namaUmkm: 'Snack Barokah UMKM',
      harga: 10000,
      kategori: 'Snack',
      deskripsi:
          'Tahu kulit goreng dibalik dan diisi adonan bakso ayam cincang berbumbu gurih, digoreng garing keemasan dengan cocolan petis khas Jawa Timur.',
      fotoUrl:
          'https://images.unsplash.com/photo-1541529086526-db283c563270?auto=format&fit=crop&w=600&q=80',
      rating: 4.6,
      jumlahDonasi: 64,
      porsiTersedia: '18 porsi tersedia',
      lokasi: 'Tegalsari, Surabaya',
    ),
    FoodItem(
      id: 'f7',
      nama: 'Es Teh Tarik Rempah Segar',
      namaUmkm: 'Kedai Minuman Segar',
      harga: 6000,
      kategori: 'Minuman',
      deskripsi:
          'Seduhan teh hitam wangi yang ditarik hingga berbusa lembut, dipadukan susu kental manis dan es batu dingin menyegarkan tenggorokan setelah seharian beraktivitas.',
      fotoUrl:
          'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=600&q=80',
      rating: 4.7,
      jumlahDonasi: 210,
      porsiTersedia: '40 cup tersedia',
      lokasi: 'Genteng, Surabaya',
      badge: 'Terlaris',
    ),
    FoodItem(
      id: 'f8',
      nama: 'Kopi Susu Gula Aren Asli',
      namaUmkm: 'Kopi Karsa Sahabat',
      harga: 14000,
      kategori: 'Minuman',
      deskripsi:
          'Espresso biji kopi lokal Nusantara dipadu susu segar creamy dan manis gurih gula aren murni. Memberikan energi positif dan kehangatan rasa.',
      fotoUrl:
          'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?auto=format&fit=crop&w=600&q=80',
      rating: 4.9,
      jumlahDonasi: 88,
      porsiTersedia: '25 cup tersedia',
      lokasi: 'Tambaksari, Surabaya',
    ),
    FoodItem(
      id: 'f9',
      nama: 'Jus Alpukat Kocok Berkah',
      namaUmkm: 'Rumah Jus Sehat Alami',
      harga: 12000,
      kategori: 'Minuman',
      deskripsi:
          'Buah alpukat mentega segar pilihan dikocok kental dengan susu cokelat manis legit dan es serut dingin. Menyehatkan dan kaya nutrisi bagi penerima donasi.',
      fotoUrl:
          'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?auto=format&fit=crop&w=600&q=80',
      rating: 4.8,
      jumlahDonasi: 70,
      porsiTersedia: '15 cup tersedia',
      lokasi: 'Sawahan, Surabaya',
    ),
    FoodItem(
      id: 'f10',
      nama: 'Paket Nasi Kotak Berkah Jumat',
      namaUmkm: 'Katering Berkah Peduli',
      harga: 20000,
      kategori: 'Paket Makanan',
      deskripsi:
          'Paket komplit nasi kotak berkah: Nasi putih pulen, ayam bakar manis, telur balado, tumis buncis wortel, kerupuk udang, buah pisang, dan air mineral.',
      fotoUrl:
          'https://images.unsplash.com/photo-1589302168068-964664d93dc0?auto=format&fit=crop&w=600&q=80',
      rating: 5.0,
      jumlahDonasi: 320,
      porsiTersedia: '50 paket tersedia',
      lokasi: 'Rungkut, Surabaya',
      badge: 'Paket Terfavorit',
    ),
    FoodItem(
      id: 'f11',
      nama: 'Paket Hemat Berbagi UMKM',
      namaUmkm: 'Warung Pojok Barokah',
      harga: 25000,
      kategori: 'Paket Makanan',
      deskripsi:
          'Paket lengkap kenyang: Nasi ayam geprek krispi sambal bawang pedas nikmat, tahu tempe goreng, lalapan segar, plus 1 cup Es Teh Tarik manis.',
      fotoUrl:
          'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=600&q=80',
      rating: 4.9,
      jumlahDonasi: 180,
      porsiTersedia: '35 paket tersedia',
      lokasi: 'Sukolilo, Surabaya',
    ),
    FoodItem(
      id: 'f12',
      nama: 'Paket Snack Box Pengajian & Panti',
      namaUmkm: 'Dapur Ummi Berkah',
      harga: 15000,
      kategori: 'Paket Makanan',
      deskripsi:
          'Paket praktis 3 macam jajanan pasar berkualitas (Lemper ayam pulen, bolu gulung keju lembut, pastel renyah telur sayur) plus air mineral gelas.',
      fotoUrl:
          'https://images.unsplash.com/photo-1559620192-032c4bc4674e?auto=format&fit=crop&w=600&q=80',
      rating: 4.8,
      jumlahDonasi: 145,
      porsiTersedia: '40 kotak tersedia',
      lokasi: 'Mulyorejo, Surabaya',
      badge: 'Pilihan Donasi',
    ),
  ];
}

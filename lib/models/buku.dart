class Buku {
  final int? id;
  final String judul;
  final String pengarang;
  final String penerbit;
  final String isbn;
  final String kategori;
  final int stok;
  final int stokTersedia;
  final String lokasi; // Rak/Lokasi di perpustakaan
  final String sinopsis;
  final String? coverUrl;
  final DateTime tahunTerbit;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Buku({
    this.id,
    required this.judul,
    required this.pengarang,
    required this.penerbit,
    required this.isbn,
    required this.kategori,
    required this.stok,
    required this.stokTersedia,
    required this.lokasi,
    required this.sinopsis,
    this.coverUrl,
    required this.tahunTerbit,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'pengarang': pengarang,
      'penerbit': penerbit,
      'isbn': isbn,
      'kategori': kategori,
      'stok': stok,
      'stokTersedia': stokTersedia,
      'lokasi': lokasi,
      'sinopsis': sinopsis,
      'coverUrl': coverUrl,
      'tahunTerbit': tahunTerbit.toIso8601String(),
      'isActive': isActive ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Buku.fromMap(Map<String, dynamic> map) {
    return Buku(
      id: map['id'],
      judul: map['judul'] ?? '',
      pengarang: map['pengarang'] ?? '',
      penerbit: map['penerbit'] ?? '',
      isbn: map['isbn'] ?? '',
      kategori: map['kategori'] ?? '',
      stok: map['stok'] ?? 0,
      stokTersedia: map['stokTersedia'] ?? 0,
      lokasi: map['lokasi'] ?? '',
      sinopsis: map['sinopsis'] ?? '',
      coverUrl: map['coverUrl'],
      tahunTerbit: DateTime.parse(map['tahunTerbit'] ?? DateTime.now().toIso8601String()),
      isActive: (map['isActive'] ?? 1) == 1,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Buku copyWith({
    int? id,
    String? judul,
    String? pengarang,
    String? penerbit,
    String? isbn,
    String? kategori,
    int? stok,
    int? stokTersedia,
    String? lokasi,
    String? sinopsis,
    String? coverUrl,
    DateTime? tahunTerbit,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Buku(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      pengarang: pengarang ?? this.pengarang,
      penerbit: penerbit ?? this.penerbit,
      isbn: isbn ?? this.isbn,
      kategori: kategori ?? this.kategori,
      stok: stok ?? this.stok,
      stokTersedia: stokTersedia ?? this.stokTersedia,
      lokasi: lokasi ?? this.lokasi,
      sinopsis: sinopsis ?? this.sinopsis,
      coverUrl: coverUrl ?? this.coverUrl,
      tahunTerbit: tahunTerbit ?? this.tahunTerbit,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

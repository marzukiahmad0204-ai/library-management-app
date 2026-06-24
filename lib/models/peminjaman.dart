class Peminjaman {
  final int? id;
  final int userId;
  final int bukuId;
  final DateTime tanggalPinjam;
  final DateTime tanggalKembaliDiharapkan;
  final DateTime? tanggalKembaliAktual;
  final String status; // 'dipinjam', 'dikembalikan', 'hilang', 'terlambat'
  final int? denda; // Denda dalam Rupiah
  final bool sudahBayarDenda;
  final String? catatan;
  final DateTime createdAt;
  final DateTime updatedAt;

  Peminjaman({
    this.id,
    required this.userId,
    required this.bukuId,
    required this.tanggalPinjam,
    required this.tanggalKembaliDiharapkan,
    this.tanggalKembaliAktual,
    this.status = 'dipinjam',
    this.denda,
    this.sudahBayarDenda = false,
    this.catatan,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isTerlambat {
    if (tanggalKembaliAktual == null) {
      return DateTime.now().isAfter(tanggalKembaliDiharapkan);
    }
    return tanggalKembaliAktual!.isAfter(tanggalKembaliDiharapkan);
  }

  int get hariTerlambat {
    final kembaliDate = tanggalKembaliAktual ?? DateTime.now();
    if (kembaliDate.isBefore(tanggalKembaliDiharapkan)) return 0;
    return kembaliDate.difference(tanggalKembaliDiharapkan).inDays;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'bukuId': bukuId,
      'tanggalPinjam': tanggalPinjam.toIso8601String(),
      'tanggalKembaliDiharapkan': tanggalKembaliDiharapkan.toIso8601String(),
      'tanggalKembaliAktual': tanggalKembaliAktual?.toIso8601String(),
      'status': status,
      'denda': denda,
      'sudahBayarDenda': sudahBayarDenda ? 1 : 0,
      'catatan': catatan,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Peminjaman.fromMap(Map<String, dynamic> map) {
    return Peminjaman(
      id: map['id'],
      userId: map['userId'] ?? 0,
      bukuId: map['bukuId'] ?? 0,
      tanggalPinjam: DateTime.parse(map['tanggalPinjam'] ?? DateTime.now().toIso8601String()),
      tanggalKembaliDiharapkan: DateTime.parse(map['tanggalKembaliDiharapkan'] ?? DateTime.now().toIso8601String()),
      tanggalKembaliAktual: map['tanggalKembaliAktual'] != null ? DateTime.parse(map['tanggalKembaliAktual']) : null,
      status: map['status'] ?? 'dipinjam',
      denda: map['denda'],
      sudahBayarDenda: (map['sudahBayarDenda'] ?? 0) == 1,
      catatan: map['catatan'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Peminjaman copyWith({
    int? id,
    int? userId,
    int? bukuId,
    DateTime? tanggalPinjam,
    DateTime? tanggalKembaliDiharapkan,
    DateTime? tanggalKembaliAktual,
    String? status,
    int? denda,
    bool? sudahBayarDenda,
    String? catatan,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Peminjaman(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bukuId: bukuId ?? this.bukuId,
      tanggalPinjam: tanggalPinjam ?? this.tanggalPinjam,
      tanggalKembaliDiharapkan: tanggalKembaliDiharapkan ?? this.tanggalKembaliDiharapkan,
      tanggalKembaliAktual: tanggalKembaliAktual ?? this.tanggalKembaliAktual,
      status: status ?? this.status,
      denda: denda ?? this.denda,
      sudahBayarDenda: sudahBayarDenda ?? this.sudahBayarDenda,
      catatan: catatan ?? this.catatan,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

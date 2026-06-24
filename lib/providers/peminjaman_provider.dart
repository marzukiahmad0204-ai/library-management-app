import 'package:flutter/material.dart';
import '../models/peminjaman.dart';
import '../models/buku.dart';
import '../database/db_helper.dart';

class PeminjamanProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Peminjaman> _peminjamanList = [];
  List<Peminjaman> _peminjamanAktif = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Peminjaman> get peminjamanList => _peminjamanList;
  List<Peminjaman> get peminjamanAktif => _peminjamanAktif;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAllPeminjaman() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _peminjamanList = await _dbHelper.getAllPeminjaman();
      _peminjamanAktif = await _dbHelper.getPeminjamanAktif();
      _isLoading = false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> loadUserPeminjaman(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _peminjamanList = await _dbHelper.getPeminjamanByUserId(userId);
      _isLoading = false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<bool> createPeminjaman(int userId, int bukuId) async {
    try {
      final buku = await _dbHelper.getBukuById(bukuId);
      if (buku == null || buku.stokTersedia <= 0) {
        _errorMessage = 'Stok buku tidak tersedia';
        notifyListeners();
        return false;
      }

      final peminjaman = Peminjaman(
        userId: userId,
        bukuId: bukuId,
        tanggalPinjam: DateTime.now(),
        tanggalKembaliDiharapkan: DateTime.now().add(const Duration(days: 7)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _dbHelper.insertPeminjaman(peminjaman);

      // Update stok buku
      final updatedBuku = buku.copyWith(stokTersedia: buku.stokTersedia - 1);
      await _dbHelper.updateBuku(updatedBuku);

      await loadAllPeminjaman();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> returnBuku(int peminjamanId) async {
    try {
      final peminjaman = _peminjamanList.firstWhere(
        (p) => p.id == peminjamanId,
        orElse: () => throw Exception('Peminjaman tidak ditemukan'),
      );

      final buku = await _dbHelper.getBukuById(peminjaman.bukuId);
      if (buku == null) throw Exception('Buku tidak ditemukan');

      // Calculate fine if late
      int? fine;
      if (peminjaman.isTerlambat) {
        fine = peminjaman.hariTerlambat * 5000; // 5000 per hari
      }

      // Update peminjaman
      final updatedPeminjaman = peminjaman.copyWith(
        status: 'dikembalikan',
        tanggalKembaliAktual: DateTime.now(),
        denda: fine,
      );
      await _dbHelper.updatePeminjaman(updatedPeminjaman);

      // Update stok buku
      final updatedBuku = buku.copyWith(stokTersedia: buku.stokTersedia + 1);
      await _dbHelper.updateBuku(updatedBuku);

      await loadAllPeminjaman();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}

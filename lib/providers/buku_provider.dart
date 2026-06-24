import 'package:flutter/material.dart';
import '../models/buku.dart';
import '../database/db_helper.dart';

class BukuProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Buku> _bukuList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Buku> get bukuList => _bukuList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAllBuku() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bukuList = await _dbHelper.getAllBuku();
      _isLoading = false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> searchBuku(String query) async {
    if (query.isEmpty) {
      await loadAllBuku();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bukuList = await _dbHelper.searchBuku(query);
      _isLoading = false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> addBuku(Buku buku) async {
    try {
      await _dbHelper.insertBuku(buku);
      await loadAllBuku();
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  Future<void> updateBuku(Buku buku) async {
    try {
      await _dbHelper.updateBuku(buku);
      await loadAllBuku();
    } catch (e) {
      _errorMessage = e.toString();
    }
  }
}

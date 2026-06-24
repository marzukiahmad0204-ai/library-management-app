import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user.dart';
import '../database/db_helper.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String _userKey = 'current_user';
  final String _authKey = 'is_authenticated';

  // Getters
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isAdmin => _currentUser?.role == 'admin';
  bool get isSiswa => _currentUser?.role == 'siswa';
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool(_authKey) ?? false;
    final userJson = prefs.getString(_userKey);

    if (_isAuthenticated && userJson != null) {
      try {
        final userData = jsonDecode(userJson);
        _currentUser = User.fromMap(userData);
        notifyListeners();
      } catch (e) {
        _logout();
      }
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Validate input
      if (email.isEmpty || password.isEmpty) {
        _errorMessage = 'Email dan password tidak boleh kosong';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Get user from database
      final user = await _dbHelper.getUserByEmail(email);

      if (user == null) {
        _errorMessage = 'Email tidak ditemukan';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (!user.isActive) {
        _errorMessage = 'Akun Anda telah dinonaktifkan';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Hash password and compare
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();
      if (user.password != hashedPassword) {
        _errorMessage = 'Password salah';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Update last login
      await _dbHelper.updateLastLogin(user.id!);

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_authKey, true);
      await prefs.setString(_userKey, jsonEncode(user.toMap()));

      _currentUser = user;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String? nisn,
    String? kelas,
    String? jurusan,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Validate input
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        _errorMessage = 'Semua field harus diisi';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password != confirmPassword) {
        _errorMessage = 'Password tidak cocok';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.length < 6) {
        _errorMessage = 'Password minimal 6 karakter';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Check if email exists
      final existingUser = await _dbHelper.getUserByEmail(email);
      if (existingUser != null) {
        _errorMessage = 'Email sudah terdaftar';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Hash password
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();

      // Create new user
      final newUser = User(
        name: name,
        email: email,
        password: hashedPassword,
        role: 'siswa',
        nisn: nisn,
        kelas: kelas,
        jurusan: jurusan,
        createdAt: DateTime.now(),
      );

      await _dbHelper.insertUser(newUser);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_authKey);
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _logout();
  }
}

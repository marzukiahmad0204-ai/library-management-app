import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user.dart';
import '../models/buku.dart';
import '../models/peminjaman.dart';

class DatabaseHelper {
  static const String databaseName = 'library_management.db';
  static const int databaseVersion = 1;

  // Table names
  static const String tableUsers = 'users';
  static const String tableBuku = 'buku';
  static const String tablePeminjaman = 'peminjaman';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Users Table
    await db.execute('''
      CREATE TABLE $tableUsers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        nisn TEXT,
        kelas TEXT,
        jurusan TEXT,
        isActive INTEGER NOT NULL DEFAULT 1,
        createdAt TEXT NOT NULL,
        lastLogin TEXT
      )
    ''');

    // Create Buku Table
    await db.execute('''
      CREATE TABLE $tableBuku (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        judul TEXT NOT NULL,
        pengarang TEXT NOT NULL,
        penerbit TEXT NOT NULL,
        isbn TEXT UNIQUE NOT NULL,
        kategori TEXT NOT NULL,
        stok INTEGER NOT NULL,
        stokTersedia INTEGER NOT NULL,
        lokasi TEXT NOT NULL,
        sinopsis TEXT,
        coverUrl TEXT,
        tahunTerbit TEXT NOT NULL,
        isActive INTEGER NOT NULL DEFAULT 1,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Create Peminjaman Table
    await db.execute('''
      CREATE TABLE $tablePeminjaman (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        bukuId INTEGER NOT NULL,
        tanggalPinjam TEXT NOT NULL,
        tanggalKembaliDiharapkan TEXT NOT NULL,
        tanggalKembaliAktual TEXT,
        status TEXT NOT NULL,
        denda INTEGER,
        sudahBayarDenda INTEGER NOT NULL DEFAULT 0,
        catatan TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY(userId) REFERENCES $tableUsers(id),
        FOREIGN KEY(bukuId) REFERENCES $tableBuku(id)
      )
    ''');

    // Insert default admin user
    await _insertDefaultAdmin(db);
  }

  Future<void> _insertDefaultAdmin(Database db) async {
    final hashedPassword = sha256.convert(utf8.encode('admin123')).toString();
    await db.insert(
      tableUsers,
      {
        'name': 'Administrator',
        'email': 'admin@library.com',
        'password': hashedPassword,
        'role': 'admin',
        'isActive': 1,
        'createdAt': DateTime.now().toIso8601String(),
      },
    );
  }

  // USER OPERATIONS
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(tableUsers, user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      tableUsers,
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final result = await db.query(
      tableUsers,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<List<User>> getAllSiswa() async {
    final db = await database;
    final result = await db.query(
      tableUsers,
      where: 'role = ? AND isActive = ?',
      whereArgs: ['siswa', 1],
      orderBy: 'name ASC',
    );
    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      tableUsers,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> updateLastLogin(int userId) async {
    final db = await database;
    return await db.update(
      tableUsers,
      {'lastLogin': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // BUKU OPERATIONS
  Future<int> insertBuku(Buku buku) async {
    final db = await database;
    return await db.insert(tableBuku, buku.toMap());
  }

  Future<List<Buku>> getAllBuku() async {
    final db = await database;
    final result = await db.query(
      tableBuku,
      where: 'isActive = ?',
      whereArgs: [1],
      orderBy: 'judul ASC',
    );
    return result.map((map) => Buku.fromMap(map)).toList();
  }

  Future<List<Buku>> searchBuku(String query) async {
    final db = await database;
    final result = await db.query(
      tableBuku,
      where: '(judul LIKE ? OR pengarang LIKE ? OR kategori LIKE ?) AND isActive = ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', 1],
      orderBy: 'judul ASC',
    );
    return result.map((map) => Buku.fromMap(map)).toList();
  }

  Future<Buku?> getBukuById(int id) async {
    final db = await database;
    final result = await db.query(
      tableBuku,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Buku.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateBuku(Buku buku) async {
    final db = await database;
    return await db.update(
      tableBuku,
      buku.toMap(),
      where: 'id = ?',
      whereArgs: [buku.id],
    );
  }

  // PEMINJAMAN OPERATIONS
  Future<int> insertPeminjaman(Peminjaman peminjaman) async {
    final db = await database;
    return await db.insert(tablePeminjaman, peminjaman.toMap());
  }

  Future<List<Peminjaman>> getPeminjamanByUserId(int userId) async {
    final db = await database;
    final result = await db.query(
      tablePeminjaman,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'tanggalPinjam DESC',
    );
    return result.map((map) => Peminjaman.fromMap(map)).toList();
  }

  Future<List<Peminjaman>> getAllPeminjaman() async {
    final db = await database;
    final result = await db.query(
      tablePeminjaman,
      orderBy: 'tanggalPinjam DESC',
    );
    return result.map((map) => Peminjaman.fromMap(map)).toList();
  }

  Future<List<Peminjaman>> getPeminjamanAktif() async {
    final db = await database;
    final result = await db.query(
      tablePeminjaman,
      where: 'status = ?',
      whereArgs: ['dipinjam'],
      orderBy: 'tanggalKembaliDiharapkan ASC',
    );
    return result.map((map) => Peminjaman.fromMap(map)).toList();
  }

  Future<int> updatePeminjaman(Peminjaman peminjaman) async {
    final db = await database;
    return await db.update(
      tablePeminjaman,
      peminjaman.toMap(),
      where: 'id = ?',
      whereArgs: [peminjaman.id],
    );
  }

  Future<void> deleteDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    await sqflite.deleteDatabase(path);
    _database = null;
  }
}

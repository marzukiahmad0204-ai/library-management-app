class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String role; // 'admin' atau 'siswa'
  final String? nisn; // Nomor Induk Siswa Nasional
  final String? kelas;
  final String? jurusan;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLogin;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.nisn,
    this.kelas,
    this.jurusan,
    this.isActive = true,
    required this.createdAt,
    this.lastLogin,
  });

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'nisn': nisn,
      'kelas': kelas,
      'jurusan': jurusan,
      'isActive': isActive ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  // Create from Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? 'siswa',
      nisn: map['nisn'],
      kelas: map['kelas'],
      jurusan: map['jurusan'],
      isActive: (map['isActive'] ?? 1) == 1,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      lastLogin: map['lastLogin'] != null ? DateTime.parse(map['lastLogin']) : null,
    );
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? role,
    String? nisn,
    String? kelas,
    String? jurusan,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      nisn: nisn ?? this.nisn,
      kelas: kelas ?? this.kelas,
      jurusan: jurusan ?? this.jurusan,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}

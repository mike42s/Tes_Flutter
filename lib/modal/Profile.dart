import 'package:shared_preferences/shared_preferences.dart';

class Profile {
  String nama;
  String noktp;
  String fotodriver;
  String password;

  Profile({
    required this.nama,
    required this.noktp,
    required this.fotodriver,
    required this.password,
  });
  Map<String, dynamic> toJson() => {
        "nama": nama,
        "noktp": noktp,
        "fotodriver": fotodriver,
        "password": password
      };
  Map<String, dynamic> toJsonDatabase() => {
        // "id": id,
        "nama": nama,
        "noktp": noktp,
        "fotodriver": fotodriver,
        "password": password
      };
  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
      nama: json["nama"],
      noktp: json["noktp"],
      fotodriver: json["fotodriver"],
      password: json["password"]);
}

class ProfileManager {
  static const String _namaKey = 'nama';
  static const String _noktpKey = 'noktp';
  static const String _fotodriverKey = 'fotodriver';
  static const String _passwordKey = 'password';

  static Future<void> deleteAllSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> saveProfile(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_namaKey, profile.nama);
    await prefs.setString(_noktpKey, profile.noktp);
    await prefs.setString(_fotodriverKey, profile.fotodriver);
    await prefs.setString(_passwordKey, profile.password);
  }

  static Future<Profile?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final nama = prefs.getString(_namaKey);
    final noktp = prefs.getString(_noktpKey);
    final fotodriver = prefs.getString(_fotodriverKey);
    final password = prefs.getString(_passwordKey);

    if (nama == null ||
        noktp == null ||
        fotodriver == null ||
        password == null) {
      return null;
    }

    return Profile(
      nama: nama,
      noktp: noktp,
      fotodriver: fotodriver,
      password: password,
    );
  }
}

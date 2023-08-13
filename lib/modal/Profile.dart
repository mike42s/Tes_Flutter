class Profile {
  int id;
  String nama;
  String noktp;
  String fotodriver;
  String password;

  Profile({
    required this.id,
    required this.nama,
    required this.noktp,
    required this.fotodriver,
    required this.password,
  });
  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "noktp": noktp,
        "fotodriver": fotodriver,
        "password": password
      };
  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
      id: json["id"],
      nama: json["nama"],
      noktp: json["noktp"],
      fotodriver: json["fotodriver"],
      password: json["password"]);
}

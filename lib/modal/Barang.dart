class PengirimanBarangModal {
  int id;
  List<String> fotoPengirimanBarang;
  double latitudeA;
  double latitudeB;
  double longitudeA;
  double longitudeB;
  double selisihlokasi;
  String noktpdriver;
  DateTime createdat;

  PengirimanBarangModal({
    required this.id,
    required this.fotoPengirimanBarang,
    required this.latitudeA,
    required this.latitudeB,
    required this.longitudeA,
    required this.longitudeB,
    required this.selisihlokasi,
    required this.noktpdriver,
    required this.createdat,
  });
  Map<String, dynamic> toJson() => {
        "id": id,
        "fotoPengirimanBarang": fotoPengirimanBarang.toString(),
        "latitudeA": latitudeA.toString(),
        "latitudeB": latitudeB.toString(),
        "longitudeA": longitudeA.toString(),
        "longitudeB": longitudeB.toString(),
        "selisihlokasi": selisihlokasi.toString(),
        "noktpdriver": noktpdriver.toString(),
        "createdat": createdat.toString(),
      };
  Map<String, dynamic> toJsonDatabase() => {
        "fotoPengirimanBarang": fotoPengirimanBarang.toString(),
        "latitudeA": latitudeA.toString(),
        "longitudeA": longitudeA.toString(),
        "latitudeB": latitudeB.toString(),
        "longitudeB": longitudeB.toString(),
        "selisihlokasi": selisihlokasi.toString(),
        "noktpdriver": noktpdriver.toString(),
        "createdat": createdat.toIso8601String(),
      };
  factory PengirimanBarangModal.fromJson(Map<String, dynamic> json) {
    final y = (json["fotoPengirimanBarang"] as String);
    String result = y.substring(1, y.length - 1);
    final _result = result.split(',').map((item) => item.trim()).toList();
    final x = PengirimanBarangModal(
      id: json["id"],
      fotoPengirimanBarang: _result,
      latitudeA: double.parse(json["latitudeA"]),
      latitudeB: double.parse(json["latitudeB"]),
      longitudeA: double.parse(json["longitudeA"]),
      longitudeB: double.parse(json["longitudeB"]),
      selisihlokasi: double.parse(json["selisihlokasi"]),
      noktpdriver: json["noktpdriver"],
      createdat: DateTime.parse(json["createdat"]),
    );
    return x;
  }
}

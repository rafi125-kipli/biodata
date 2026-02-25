class Msiswa {
  String id, nis, nama, tplahir, tglahir, kelamin, agama, alamat;

  Msiswa({
    required this.id,
    required this.nis,
    required this.nama,
    required this.tplahir,
    required this.tglahir,
    required this.kelamin,
    required this.agama,
    required this.alamat,
  });

  factory Msiswa.fromJson(Map<String, dynamic> json) {
    return Msiswa(
      id: json['id'].toString(),
      nis: json['nis'] ?? '',
      nama: json['nama'] ?? '',
      tplahir: json['tplahir'] ?? '',
      tglahir: json['tglahir'] ?? '',
      kelamin: json['kelamin'] ?? '',
      agama: json['agama'] ?? '',
      alamat: json['alamat'] ?? '',
    );
  }
}
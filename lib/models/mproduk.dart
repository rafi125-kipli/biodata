class Mproduk {
  String id, nama_produk, harga, stok, foto;

  Mproduk({
    required this.id,
    required this.nama_produk,
    required this.harga,
    required this.stok,
    required this.foto,
  });

  factory Mproduk.fromJson(Map<String, dynamic> json) {
    return Mproduk(
      id: json['id'].toString(),
      nama_produk: json['nama_produk'] ?? '', 
      harga: json['harga'].toString(),
      stok: json['stok'].toString(),
      foto: json['foto'] ?? '',
    );
  }
}
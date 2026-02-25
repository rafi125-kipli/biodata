import 'package:flutter/material.dart';

class DetailSiswa extends StatelessWidget {
  final Map data;
  const DetailSiswa({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Biodata Siswa"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
    
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  _itemDetail("NIS", data['nis'], Icons.assignment_ind),
                  _itemDetail("Nama Lengkap", data['nama'], Icons.person),
                  _itemDetail("Tempat Lahir", data['tplahir'], Icons.location_city),
                  _itemDetail("Tanggal Lahir", data['tglahir'], Icons.calendar_month),
                  _itemDetail("Jenis Kelamin", data['kelamin'], Icons.wc),
                  _itemDetail("Agama", data['agama'], Icons.mosque),
                  _itemDetail("Alamat", data['alamat'], Icons.home),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemDetail(String label, String? nilai, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(nilai ?? "-", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
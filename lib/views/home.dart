import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/api.dart';
import 'add_siswa.dart';
import 'edit_siswa.dart';
import 'detail_siswa.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listSiswa = [];
  bool _isLoading = true;

  // 1. FUNGSI AMBIL DATA DARI SERVER
  Future _getSiswa() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(BaseUrl.lihatSiswa));
      if (response.statusCode == 200) {
        setState(() {
          _listSiswa = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error ambil data: $e");
      setState(() => _isLoading = false);
    }
  }

  // 2. FUNGSI HAPUS DATA
  Future _hapusData(String id) async {
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.hapusSiswa),
        body: {"id": id},
      );
      if (response.statusCode == 200) {
        _getSiswa(); // Refresh data setelah hapus
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data berhasil dihapus"), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      debugPrint("Error hapus: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getSiswa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Siswa", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 2,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _getSiswa,
              child: _listSiswa.isEmpty
                  ? const Center(child: Text("Belum ada data siswa"))
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 10, bottom: 80),
                      itemCount: _listSiswa.length,
                      itemBuilder: (context, i) {
                        final siswa = _listSiswa[i];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            onTap: () {
                              // Klik pada baris untuk lihat detail
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DetailSiswa(data: siswa)),
                              );
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade50,
                              child: const Icon(Icons.person, color: Colors.blue),
                            ),
                            title: Text(
                              siswa['nama'] ?? "Tanpa Nama",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("NIS: ${siswa['nis']}\nAlamat: ${siswa['alamat']}", 
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Tombol Edit
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.orange),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EditSiswa(data: siswa)),
                                    ).then((value) => _getSiswa());
                                  },
                                ),
                                // Tombol Hapus
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _showKonfirmasiHapus(siswa['id'].toString()),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSiswa()),
          ).then((value) => _getSiswa());
        },
        label: const Text("Tambah Siswa", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Dialog Konfirmasi sebelum benar-benar menghapus
  void _showKonfirmasiHapus(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Data"),
        content: const Text("Apakah Pak Imam yakin ingin menghapus data ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _hapusData(id);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; 
import '../models/api.dart';

class AddSiswa extends StatefulWidget {
  const AddSiswa({super.key});

  @override
  State<AddSiswa> createState() => _AddSiswaState();
}

class _AddSiswaState extends State<AddSiswa> {
  final _nisController = TextEditingController();
  final _namaController = TextEditingController();
  final _tplahirController = TextEditingController();
  final _tglahirController = TextEditingController();
  final _alamatController = TextEditingController();
  
  String? _kelamin;
  String? _agama;
  bool _isLoading = false;

  Future<void> _pilihTanggal(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _tglahirController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future _simpan() async {
    if (_nisController.text.isEmpty || _namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("NIS dan Nama tidak boleh kosong!")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.tambahSiswa),
        body: {
          "nis": _nisController.text.trim(),
          "nama": _namaController.text.trim(),
          "tplahir": _tplahirController.text.trim(),
          "tglahir": _tglahirController.text.trim(),
          "kelamin": _kelamin ?? "",
          "agama": _agama ?? "",
          "alamat": _alamatController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['status'] == 'success') {
          if (!mounted) return;
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data Berhasil Ditambah!"), backgroundColor: Colors.green),
          );
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Siswa"), backgroundColor: Colors.blue),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _inputField(_nisController, "NIS", Icons.assignment_ind, TextInputType.number),
              _inputField(_namaController, "Nama Lengkap", Icons.person, TextInputType.text),
              _inputField(_tplahirController, "Tempat Lahir", Icons.location_city, TextInputType.text),
              
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  controller: _tglahirController,
                  readOnly: true, 
                  onTap: () => _pilihTanggal(context), 
                  decoration: const InputDecoration(
                    labelText: "Tanggal Lahir",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_month), 
                  ),
                ),
              ),
              
              _dropdownField("Jenis Kelamin", Icons.wc, ["Laki-laki", "Perempuan"], (v) => _kelamin = v),
              const SizedBox(height: 15),
              _dropdownField("Agama", Icons.mosque, ["Islam", "Kristen", "Katolik", "Hindu", "Budha"], (v) => _agama = v),
              
              const SizedBox(height: 15),
              _inputField(_alamatController, "Alamat", Icons.home, TextInputType.multiline, maxLines: 3),
              
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _simpan, 
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text("SIMPAN DATA", style: TextStyle(color: Colors.white, fontSize: 16)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              )
            ],
          ),
    );
  }

  Widget _inputField(TextEditingController cont, String label, IconData icon, TextInputType type, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: cont, 
        keyboardType: type,
        maxLines: maxLines, 
        decoration: InputDecoration(
          labelText: label, 
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder()
        )
      ),
    );
  }

  Widget _dropdownField(String label, IconData icon, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label, 
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder()
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) => setState(() => onChanged(v)),
    );
  }
}
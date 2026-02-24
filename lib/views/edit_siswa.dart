import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Untuk format tanggal
import '../models/api.dart';

class EditSiswa extends StatefulWidget {
  final Map data;
  const EditSiswa({super.key, required this.data});

  @override
  State<EditSiswa> createState() => _EditSiswaState();
}

class _EditSiswaState extends State<EditSiswa> {
  late TextEditingController _nis, _nama, _tplahir, _tglahir, _alamat;
  String? _kelamin, _agama;

  final List<String> _listKelamin = ["Laki-laki", "Perempuan"];
  final List<String> _listAgama = ["Islam", "Kristen", "Katolik", "Hindu", "Budha"];

  @override
  void initState() {
    super.initState();
    _nis = TextEditingController(text: widget.data['nis']?.toString());
    _nama = TextEditingController(text: widget.data['nama']?.toString());
    _tplahir = TextEditingController(text: widget.data['tplahir']?.toString());
    _tglahir = TextEditingController(text: widget.data['tglahir']?.toString());
    _alamat = TextEditingController(text: widget.data['alamat']?.toString());
    _kelamin = _listKelamin.contains(widget.data['kelamin']) ? widget.data['kelamin'] : null;
    _agama = _listAgama.contains(widget.data['agama']) ? widget.data['agama'] : null;
  }

  Future<void> _pilihTanggal(BuildContext context) async {
    DateTime awal = DateTime.tryParse(_tglahir.text) ?? DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: awal,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.blue),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _tglahir.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future _update() async {
    if (_nis.text.isEmpty || _nama.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("NIS dan Nama tidak boleh kosong!"), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      final response = await http.post(Uri.parse(BaseUrl.editSiswa), body: {
        "id": widget.data['id'].toString(), 
        "nis": _nis.text.trim(),
        "nama": _nama.text.trim(),
        "tplahir": _tplahir.text.trim(),
        "tglahir": _tglahir.text.trim(),
        "kelamin": _kelamin ?? "",
        "agama": _agama ?? "",
        "alamat": _alamat.text.trim(),
      });

      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.pop(context, true); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data Berhasil Diperbarui!"), backgroundColor: Colors.blue),
        );
      }
    } catch (e) {
      debugPrint("Error Update: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Data Siswa", style: TextStyle(color: Colors.white)), 
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _inputField(_nis, "NIS", Icons.assignment_ind),
          _inputField(_nama, "Nama Lengkap", Icons.person),
          _inputField(_tplahir, "Tempat Lahir", Icons.location_city),

          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TextFormField(
              controller: _tglahir,
              readOnly: true,
              onTap: () => _pilihTanggal(context),
              decoration: const InputDecoration(
                labelText: "Tanggal Lahir",
                prefixIcon: Icon(Icons.calendar_month, color: Colors.blue),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          
          _dropdownField("Jenis Kelamin", Icons.wc, _listKelamin, _kelamin, (v) => _kelamin = v),
          const SizedBox(height: 15),
          _dropdownField("Agama", Icons.mosque, _listAgama, _agama, (v) => _agama = v),
          
          const SizedBox(height: 15),
          _inputField(_alamat, "Alamat", Icons.home, maxLines: 3),
          
          const SizedBox(height: 25),
          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
              onPressed: _update, 
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text("SIMPAN PERUBAHAN", 
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _inputField(TextEditingController cont, String label, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: cont, 
        maxLines: maxLines, 
        decoration: InputDecoration(
          labelText: label, 
          prefixIcon: Icon(icon, color: Colors.blue),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _dropdownField(String label, IconData icon, List<String> items, String? currentVal, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: currentVal,
      decoration: InputDecoration(
        labelText: label, 
        prefixIcon: Icon(icon, color: Colors.blue),
        border: const OutlineInputBorder(),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) => setState(() => onChanged(v)),
    );
  }
}
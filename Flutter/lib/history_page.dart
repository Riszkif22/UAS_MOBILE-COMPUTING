import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getHistory();
  }

  Future<void> _getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    try {
      final response = await http.get(Uri.parse('https://rilah.ujangkedu.my.id/api/get_history.php?user_id=$userId'));
      if (response.statusCode == 200) {
        setState(() {
          _history = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // --- FITUR 1: UPDATE UKURAN BAJU ---
  Future<void> _updateShirtSize(String id, String newSize) async {
    try {
      final response = await http.post(
        Uri.parse('https://rilah.ujangkedu.my.id/api/update_shirt_size.php'),
        body: {'id': id, 'shirt_size': newSize},
      );

      if(response.statusCode == 200) {
        _getHistory(); // Refresh data agar tampilan berubah
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ukuran baju berhasil diubah")));
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal mengubah data")));
    }
  }

  void _showEditDialog(Map data) {
    String selectedSize = data['shirt_size'] ?? 'M'; // Default value jika null
    final List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("Ganti Ukuran Baju"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Pilih ukuran baru untuk event ini:"),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      value: sizes.contains(selectedSize) ? selectedSize : sizes[0],
                      items: sizes.map((String size) {
                        return DropdownMenuItem<String>(
                          value: size,
                          child: Text(size),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() => selectedSize = newValue!);
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                    onPressed: () {
                      Navigator.pop(context);
                      _updateShirtSize(data['id'], selectedSize);
                    },
                    child: const Text("Simpan", style: TextStyle(color: Colors.white)),
                  ),
                ],
              );
            }
        );
      },
    );
  }

  // --- FITUR 2: VIEW DETAIL ---
  void _showDetailDialog(Map data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(data['title'] ?? 'Event', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              _detailRow(Icons.confirmation_number, "Nama BIB", data['bib_name'] ?? '-'),
              _detailRow(Icons.straighten, "Jarak", data['distance'] ?? '-'),
              _detailRow(Icons.checkroom, "Ukuran Baju", data['shirt_size'] ?? '-'),
              _detailRow(Icons.contact_phone, "Kontak Darurat", data['emergency_contact'] ?? '-'),
              _detailRow(Icons.calendar_today, "Tanggal Event", data['event_date'] ?? 'Belum ditentukan'),
              _detailRow(Icons.access_time, "Tanggal Daftar", data['reg_date'] ?? '-'),
              const Divider(),
              const Text("Deskripsi:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(data['description'] ?? 'Tidak ada deskripsi', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tutup")),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _deleteHistory(String id) async {
    try {
      await http.post(
        Uri.parse('https://rilah.ujangkedu.my.id/api/delete_history.php'),
        body: {'id': id},
      );
      _getHistory();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Riwayat berhasil dihapus")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menghapus data")));
    }
  }

  void _confirmDelete(String id, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Riwayat?"),
        content: Text("Apakah Anda yakin ingin membatalkan pendaftaran '$title'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteHistory(id);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return _history.isEmpty
        ? const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text("Belum ada lomba yang diikuti", style: TextStyle(color: Colors.grey)),
        ],
      ),
    )
        : ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final item = _history[index];

        // --- PERBAIKAN TAMPILAN (Handle Null) ---
        String bib = item['bib_name'] ?? '-';
        String size = item['shirt_size'] ?? '-';
        // ----------------------------------------

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () => _showDetailDialog(item),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Ikon Lari
                  const CircleAvatar(
                    backgroundColor: Colors.black87,
                    child: Icon(Icons.run_circle, color: Colors.white),
                  ),
                  const SizedBox(width: 15),

                  // Info Utama
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title'] ?? 'Event', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 5),
                        // Tampilkan Data dengan Handling Null
                        Text("BIB: $bib", style: const TextStyle(fontSize: 13, color: Colors.grey)),
                        Text("Size: $size", style: TextStyle(fontSize: 13, color: Colors.blueGrey[700], fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                  // Tombol Aksi
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: "Ganti Ukuran Baju",
                        onPressed: () => _showEditDialog(item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: "Batalkan Pendaftaran",
                        onPressed: () => _confirmDelete(item['id'], item['title'] ?? 'Item ini'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
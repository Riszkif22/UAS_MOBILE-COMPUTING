import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_form_event.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _lomba = [];
  String _role = "user";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkRole();
    _getData();
  }

  void _checkRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getString('role') ?? "user";
    });
  }

  Future<void> _getData() async {
    try {
      final response = await http.get(Uri.parse('https://rilah.ujangkedu.my.id/api/get_lomba.php'));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        setState(() {
          // HAPUS .reversed KARENA DI PHP SUDAH DI-ORDER BY DESC
          _lomba = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteEvent(String id) async {
    try {
      await http.post(
          Uri.parse('https://rilah.ujangkedu.my.id/api/admin_delete_event.php'),
          body: {'id': id}
      );
      _getData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event berhasil dihapus")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menghapus data")));
      }
    }
  }

  void _confirmDelete(String id, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Event?"),
        content: Text("Apakah Anda yakin ingin menghapus event '$title'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteEvent(id);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- FITUR 2 & 3: Form Pendaftaran (Dropdown Baju & Validasi Angka) ---
  void _showRegistrationForm(String categoryId, String title) {
    final bibController = TextEditingController();
    final contactController = TextEditingController();
    String? selectedSize; // Variabel untuk menyimpan pilihan ukuran baju

    // List Pilihan Ukuran Baju
    final List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];

    showDialog(
      context: context,
      builder: (context) {
        // Gunakan StatefulBuilder agar Dropdown bisa direfresh state-nya di dalam Dialog
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text("Daftar: $title"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                          controller: bibController,
                          decoration: const InputDecoration(labelText: "Nama di BIB")
                      ),
                      const SizedBox(height: 15),

                      // --- DROPDOWN UKURAN BAJU ---
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: "Ukuran Baju", border: OutlineInputBorder()),
                        value: selectedSize,
                        items: sizes.map((String size) {
                          return DropdownMenuItem<String>(
                            value: size,
                            child: Text(size),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() => selectedSize = newValue);
                        },
                      ),

                      const SizedBox(height: 15),

                      // --- INPUT KONTAK DARURAT (ANGKA SAJA) ---
                      TextField(
                          controller: contactController,
                          keyboardType: TextInputType.number, // Keyboard angka muncul
                          decoration: const InputDecoration(
                              labelText: "Kontak Darurat",
                              hintText: "Contoh: 08123456789"
                          )
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
                  // ... (Kode sebelumnya di atas tetap sama)

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                    onPressed: () async {
                      // 1. VALIDASI: Data Kosong
                      if (bibController.text.isEmpty || selectedSize == null || contactController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Harap isi semua data!")));
                        return;
                      }

                      // 2. VALIDASI: Harus Angka
                      if (!RegExp(r'^[0-9]+$').hasMatch(contactController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kontak darurat harus berupa angka!"), backgroundColor: Colors.red));
                        return;
                      }

                      // 3. VALIDASI BARU: Minimal 12 Angka (Tambahkan ini)
                      if (contactController.text.length < 12) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Nomor kontak darurat minimal 12 angka!"),
                                backgroundColor: Colors.red
                            )
                        );
                        return; // Stop proses jika kurang dari 12
                      }

                      // --- Jika lolos semua validasi, lanjut kirim ke API ---
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String? userId = prefs.getString('user_id');

                      await http.post(
                        Uri.parse('https://rilah.ujangkedu.my.id/api/register_lomba.php'),
                        body: {
                          'user_id': userId,
                          'category_id': categoryId,
                          'bib_name': bibController.text,
                          'shirt_size': selectedSize,
                          'emergency_contact': contactController.text
                        },
                      );

                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pendaftaran Berhasil!')));
                      }
                    },
                    child: const Text("DAFTAR", style: TextStyle(color: Colors.white)),
                  ),

// ... (Kode sesudahnya tetap sama)
                ],
              );
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _role == 'admin'
          ? FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminFormEvent()));
          _getData();
        },
      )
          : null,

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _lomba.isEmpty
          ? const Center(child: Text("Belum ada event tersedia"))
          : ListView.builder(
        itemCount: _lomba.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bagian Gambar (Menggunakan AspectRatio agar tidak terpotong)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      _lomba[index]['image_url'],
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, error, stackTrace) => Container(color: Colors.grey[200], child: const Icon(Icons.broken_image)),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(_lomba[index]['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                          Chip(label: Text(_lomba[index]['distance']), backgroundColor: Colors.orange[100]),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(
                              _lomba[index]['event_date'] ?? 'Belum ditentukan',
                              style: const TextStyle(color: Colors.grey, fontSize: 13)
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(_lomba[index]['description'], maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 15),

                      _role == 'admin'
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            label: const Text("Edit"),
                            onPressed: () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => AdminFormEvent(eventData: _lomba[index])));
                              _getData();
                            },
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            icon: const Icon(Icons.delete, color: Colors.white),
                            label: const Text("Hapus", style: TextStyle(color: Colors.white)),
                            onPressed: () => _confirmDelete(_lomba[index]['id'], _lomba[index]['title']),
                          ),
                        ],
                      )
                          : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                          onPressed: () => _showRegistrationForm(_lomba[index]['id'], _lomba[index]['title']),
                          child: const Text("DAFTAR SEKARANG", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
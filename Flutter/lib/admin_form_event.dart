import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdminFormEvent extends StatefulWidget {
  final Map? eventData;
  const AdminFormEvent({super.key, this.eventData});

  @override
  State<AdminFormEvent> createState() => _AdminFormEventState();
}

class _AdminFormEventState extends State<AdminFormEvent> {
  final _titleController = TextEditingController();
  // _distController tidak lagi digunakan untuk input manual, tapi untuk menyimpan nilai pilihan
  final _descController = TextEditingController();
  final _urlTextController = TextEditingController();
  final _dateController = TextEditingController();

  XFile? _pickedImage;
  bool _isLoading = false;

  // --- FITUR BARU: Variabel Pilihan Jarak ---
  String _selectedDistance = "";
  final List<String> _distanceOptions = ["5KM", "10KM", "21KM", "42KM"];

  @override
  void initState() {
    super.initState();
    if (widget.eventData != null) {
      _titleController.text = widget.eventData!['title'];
      _descController.text = widget.eventData!['description'];
      _urlTextController.text = widget.eventData!['image_url'];
      _dateController.text = widget.eventData!['event_date'] ?? '';

      // Load jarak yang sudah ada (jika edit)
      setState(() {
        _selectedDistance = widget.eventData!['distance'];
      });
    }
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
        _urlTextController.text = "";
      });
    }
  }

  Future<void> _saveData() async {
    // Validasi Input (Termasuk Jarak)
    if (_titleController.text.isEmpty || _dateController.text.isEmpty || _selectedDistance.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Judul, Tanggal, dan Jarak wajib diisi")));
      return;
    }

    setState(() => _isLoading = true);

    String url = widget.eventData == null
        ? 'https://rilah.ujangkedu.my.id/api/admin_add_event.php'
        : 'https://rilah.ujangkedu.my.id/api/admin_edit_event.php';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['title'] = _titleController.text;
      request.fields['distance'] = _selectedDistance; // Kirim data pilihan chip
      request.fields['description'] = _descController.text;
      request.fields['event_date'] = _dateController.text;
      request.fields['image_url_text'] = _urlTextController.text;

      if (widget.eventData != null) {
        request.fields['id'] = widget.eventData!['id'];
      }

      if (_pickedImage != null) {
        request.files.add(await http.MultipartFile.fromPath('image', _pickedImage!.path));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Berhasil Disimpan!")));
          Navigator.pop(context, true);
        }
      } else {
        throw Exception("Gagal menyimpan data");
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.eventData == null ? "Tambah Event" : "Edit Event")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
          children: [
            // Upload Gambar
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                  child: _pickedImage != null
                      ? Image.file(File(_pickedImage!.path), fit: BoxFit.cover)
                      : (widget.eventData != null && _urlTextController.text.isNotEmpty)
                      ? Image.network(_urlTextController.text, fit: BoxFit.cover, errorBuilder: (c,o,s) => const Icon(Icons.broken_image))
                      : const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_a_photo, size: 50, color: Colors.grey), Text("Upload Gambar")]),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Judul Lomba", border: OutlineInputBorder())),
            const SizedBox(height: 15),

            TextField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                    labelText: "Tanggal Lomba",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today)
                )
            ),
            const SizedBox(height: 20),

            // --- FITUR PILIHAN JARAK (ChoiceChip) ---
            const Text("Pilih Kategori Jarak:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Wrap(
                spacing: 10.0, // Jarak horizontal antar tombol
                runSpacing: 5.0, // Jarak vertical jika turun baris
                children: _distanceOptions.map((String distance) {
                  return ChoiceChip(
                    label: Text(distance),
                    selected: _selectedDistance == distance,
                    selectedColor: Colors.orangeAccent,
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                        color: _selectedDistance == distance ? Colors.white : Colors.black
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedDistance = selected ? distance : "";
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            // ----------------------------------------

            const SizedBox(height: 15),
            TextField(controller: _descController, maxLines: 3, decoration: const InputDecoration(labelText: "Deskripsi", border: OutlineInputBorder())),
            const SizedBox(height: 30),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                    onPressed: _isLoading ? null : _saveData,
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("SIMPAN DATA", style: TextStyle(color: Colors.white))
                )
            )
          ],
        ),
      ),
    );
  }
}
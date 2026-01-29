import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'welcome_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ... (Variabel state tetap sama) ...
  String _name = "";
  String _role = "";
  String? _photoUrl;
  XFile? _pickedFile;
  Uint8List? _webImageBytes;
  final _nameController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? "User";
      _role = prefs.getString('role') ?? "user";
      _photoUrl = prefs.getString('photo_url');
    });
  }

  void _confirmSave() {
    // ... (Kode konfirmasi simpan tetap sama) ...
    if (_passController.text.isNotEmpty && _passController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Konfirmasi Password tidak cocok!")));
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Simpan Perubahan?"),
        content: const Text("Apakah Anda yakin ingin menyimpan perubahan pada profil Anda?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateProfile();
            },
            child: const Text("Ya, Simpan"),
          ),
        ],
      ),
    );
  }

  // --- UPDATE BAGIAN INI ---
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Keluar"),
        content: const Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (mounted) {
                // 2. GANTI TUJUAN KE WelcomePage()
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                      (route) => false,
                );
              }
            },
            child: const Text("Keluar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _updateProfile() async {
    setState(() => _isUpdating = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id') ?? '';

    try {
      var request = http.MultipartRequest('POST', Uri.parse('https://rilah.ujangkedu.my.id/api/update_profile.php'));
      request.fields['user_id'] = userId;
      request.fields['full_name'] = _nameController.text;
      request.fields['password'] = _passController.text;

      if (_pickedFile != null && !kIsWeb) {
        request.files.add(await http.MultipartFile.fromPath('image', _pickedFile!.path));
      }

      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          await prefs.setString('name', data['name']);
          if (data['photo_url'] != null) {
            await prefs.setString('photo_url', data['photo_url']);
            setState(() => _photoUrl = data['photo_url']);
          }
          setState(() => _name = data['name']);

          if(mounted) {
            Navigator.pop(context); // Tutup Modal
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profil Berhasil Diupdate!")));
          }
        }
      }
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  void _showEditModal() {
    // ... (Kode modal edit tetap sama, copy dari sebelumnya) ...
    _nameController.text = _name;
    _passController.text = "";
    _confirmPassController.text = "";
    _pickedFile = null;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return StatefulBuilder(
              builder: (context, setS) {
                ImageProvider img;
                if (kIsWeb && _webImageBytes != null) { img = MemoryImage(_webImageBytes!); }
                else if (!kIsWeb && _pickedFile != null) { img = FileImage(File(_pickedFile!.path)); }
                else if (_photoUrl != null && _photoUrl!.isNotEmpty) { img = NetworkImage("$_photoUrl?t=${DateTime.now().millisecondsSinceEpoch}"); }
                else { img = const NetworkImage('https://i.pravatar.cc/150?img=12'); }

                return Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
                  child: Column(
                    children: [
                      Container(margin: const EdgeInsets.only(top: 12), width: 60, height: 5, decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10))),
                      Padding(padding: const EdgeInsets.all(24), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Edit Profil", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close))])),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(24),
                          children: [
                            Center(
                                child: GestureDetector(
                                    onTap: () async {
                                      final picker = ImagePicker();
                                      final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
                                      if (picked != null) {
                                        if (kIsWeb) { final b = await picked.readAsBytes(); setS(() { _pickedFile = picked; _webImageBytes = b; }); }
                                        else { setS(() => _pickedFile = picked); }
                                      }
                                    },
                                    child: CircleAvatar(radius: 50, backgroundImage: img, child: const Align(alignment: Alignment.bottomRight, child: CircleAvatar(radius: 15, backgroundColor: Colors.blueGrey, child: Icon(Icons.camera_alt, size: 15, color: Colors.white))))
                                )
                            ),
                            const SizedBox(height: 20),
                            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder())),
                            const SizedBox(height: 15),
                            const Text("Ganti Password (Opsional)", style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            TextField(controller: _passController, obscureText: true, decoration: const InputDecoration(labelText: "Password Baru", border: OutlineInputBorder())),
                            const SizedBox(height: 10),
                            TextField(controller: _confirmPassController, obscureText: true, decoration: const InputDecoration(labelText: "Konfirmasi Password Baru", border: OutlineInputBorder())),
                            const SizedBox(height: 30),
                            _isUpdating
                                ? const Center(child: CircularProgressIndicator())
                                : SizedBox(height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey), onPressed: _confirmSave, child: const Text("SIMPAN PERUBAHAN", style: TextStyle(color: Colors.white)))),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... (Kode build tetap sama) ...
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[300],
              backgroundImage: (_photoUrl != null && _photoUrl!.isNotEmpty)
                  ? NetworkImage("$_photoUrl?t=${DateTime.now().millisecondsSinceEpoch}")
                  : null,
              child: (_photoUrl == null || _photoUrl!.isEmpty)
                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                  : null,
            ),
            const SizedBox(height: 20),
            Text(_name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Role: ${_role.toUpperCase()}", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            SizedBox(width: double.infinity, height: 50, child: OutlinedButton.icon(onPressed: _showEditModal, icon: const Icon(Icons.edit), label: const Text("EDIT PROFIL"))),
            const SizedBox(height: 15),
            SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: _confirmLogout, // Tombol Logout disini juga pakai fungsi baru
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text("KELUAR APLIKASI", style: TextStyle(color: Colors.white))
                )
            ),
          ],
        ),
      ),
    );
  }
}
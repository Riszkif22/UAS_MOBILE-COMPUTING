import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  List _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  // 1. Ambil Data User dari API
  Future<void> _getUsers() async {
    try {
      final response = await http.get(Uri.parse('https://rilah.ujangkedu.my.id/api/get_all_users.php'));

      if (response.statusCode == 200) {
        setState(() {
          _users = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  // 2. Fungsi Hapus User
  Future<void> _deleteUser(String id) async {
    try {
      await http.post(
        Uri.parse('https://rilah.ujangkedu.my.id/api/admin_delete_user.php'),
        body: {'id': id},
      );

      _getUsers(); // Refresh data setelah hapus

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User berhasil dihapus")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menghapus user")));
      }
    }
  }

  // 3. Dialog Konfirmasi Hapus
  void _confirmDelete(String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus User?"),
        content: Text("Apakah Anda yakin ingin menghapus akun '$name'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(id);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _users.isEmpty
          ? const Center(child: Text("Tidak ada data user"))
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];

          // --- LOGIKA PROTEKSI ADMIN ---
          // Cek apakah user ini adalah admin
          bool isAdmin = user['role'] == 'admin';
          // -----------------------------

          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blueGrey,
                backgroundImage: (user['photo_url'] != null && user['photo_url'] != "")
                    ? NetworkImage(user['photo_url'])
                    : null,
                child: (user['photo_url'] == null || user['photo_url'] == "")
                    ? Text(
                  user['username'][0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                )
                    : null,
              ),
              title: Text(
                  user['full_name'] ?? 'No Name',
                  style: const TextStyle(fontWeight: FontWeight.bold)
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("@${user['username']}"),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: isAdmin ? Colors.red[100] : Colors.green[100],
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text(
                      user['role'].toString().toUpperCase(),
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isAdmin ? Colors.red : Colors.green
                      ),
                    ),
                  )
                ],
              ),
              // --- BAGIAN TOMBOL HAPUS ---
              // Jika Admin, tampilkan Icon Kunci (atau kosongkan).
              // Jika User biasa, tampilkan Tombol Sampah.
              trailing: isAdmin
                  ? const Icon(Icons.verified_user, color: Colors.grey) // Tanda akun terlindungi
                  : IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(user['id'], user['username']),
              ),
              // ---------------------------
            ),
          );
        },
      ),
    );
  }
}
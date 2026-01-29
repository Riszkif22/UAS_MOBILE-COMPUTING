import 'package:flutter/material.dart';

class AppOverviewPage extends StatelessWidget {
  const AppOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Overview Aplikasi"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Center(
              child: Column(
                children: [
                  const Icon(Icons.run_circle_outlined, size: 80, color: Colors.orange),
                  const SizedBox(height: 10),
                  const Text(
                    "Rilah Marathon",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 1. Deskripsi
            _buildSectionTitle("1. Deskripsi"),
            _buildCard(
              child: const Text(
                "Rilah Marathon adalah aplikasi mobile berbasis Flutter yang dirancang untuk mempermudah pelari dalam mendaftar dan memantau event lomba lari. Visi kami adalah menyehatkan masyarakat melalui olahraga lari yang menyenangkan dan terorganisir.",
                style: TextStyle(fontSize: 15, height: 1.5),
                textAlign: TextAlign.justify,
              ),
            ),

            // 2. Kategori
            _buildSectionTitle("2. Kategori Lomba"),
            _buildCard(
              child: Column(
                children: [
                  _buildListTile(Icons.directions_run, "5K Fun Run", "Cocok untuk pemula."),
                  _buildListTile(Icons.timer, "10K Challenger", "Tantangan jarak menengah."),
                  _buildListTile(Icons.bolt, "21K Half Marathon", "Uji ketahanan fisik."),
                  _buildListTile(Icons.emoji_events, "42K Full Marathon", "Untuk pelari profesional."),
                ],
              ),
            ),

            // 3. Fitur User
            _buildSectionTitle("3. Fitur Pengguna (Runner)"),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBullet("Authentication: Login & Register Akun."),
                  _buildBullet("Event Discovery: Melihat daftar lomba lengkap."),
                  _buildBullet("Registrasi: Form pendaftaran (BIB, Ukuran Baju)."),
                  _buildBullet("Riwayat: Pantau history & batalkan pendaftaran."),
                  _buildBullet("Profil: Update foto, nama, & password."),
                ],
              ),
            ),

            // 4. Fitur Admin
            _buildSectionTitle("4. Fitur Admin"),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBullet("Manajemen Event (CRUD): Tambah, Edit, Hapus."),
                  _buildBullet("Upload Gambar: Upload banner lomba dari galeri."),
                  _buildBullet("Manajemen Tanggal: Atur jadwal pelaksanaan lomba."),
                ],
              ),
            ),

            // 5. Spesifikasi Teknis
            _buildSectionTitle("5. Spesifikasi"),
            _buildCard(
              child: Table(
                columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
                border: TableBorder(horizontalInside: BorderSide(color: Colors.grey.shade300)),
                children: const [
                  TableRow(children: [
                    Padding(padding: EdgeInsets.all(8.0), child: Text("Frontend", style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8.0), child: Text("Flutter (Dart)")),
                  ]),
                  TableRow(children: [
                    Padding(padding: EdgeInsets.all(8.0), child: Text("Backend", style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8.0), child: Text("PHP")),
                  ]),
                  TableRow(children: [
                    Padding(padding: EdgeInsets.all(8.0), child: Text("Database", style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8.0), child: Text("MySQL")),
                  ]),
                  TableRow(children: [
                    Padding(padding: EdgeInsets.all(8.0), child: Text("Storage", style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8.0), child: Text("Shared Preferences (Local) & Hosting (Images)")),
                  ]),
                ],
              ),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
                onPressed: () => Navigator.pop(context),
                child: const Text("TUTUP", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Judul Section
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      ),
    );
  }

  // Widget Helper untuk Kartu Putih
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, spreadRadius: 1),
        ],
      ),
      child: child,
    );
  }

  // Widget Helper untuk Item List
  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Widget Helper untuk Bullet Point
  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15, height: 1.4))),
        ],
      ),
    );
  }
}
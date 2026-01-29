import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'history_page.dart';
import 'about_page.dart';
import 'profile_page.dart';
import 'welcome_page.dart';
import 'admin_users_page.dart'; // <--- PENTING: Import file baru

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  String role = "user";
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  // Cek Role User/Admin untuk menentukan Menu
  void _checkRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role') ?? "user";

      // --- UPDATE STRUKTUR MENU ADMIN ---
      if (role == 'admin') {
        _pages = [
          const HomePage(),        // Index 0: Manage Events
          const AdminUsersPage(),  // Index 1: Manage Users (MENU BARU)
          const AboutPage(),       // Index 2: About
          const ProfilePage(),     // Index 3: Profile
        ];
      } else {
        _pages = [
          const HomePage(),        // Index 0: Home
          const HistoryPage(),     // Index 1: History
          const AboutPage(),       // Index 2: About
          const ProfilePage(),     // Index 3: Profile
        ];
      }
    });
  }

  // Fungsi Logout dengan Konfirmasi
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Keluar"),
        content: const Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal")
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // Hapus sesi login
              if (mounted) {
                // Kembali ke WelcomePage
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                      (route) => false,
                );
              }
            },
            child: const Text("Ya, Keluar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Konfirmasi ketika tombol Back ditekan di HP
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tutup Aplikasi?'),
        content: const Text('Apakah anda yakin ingin menutup aplikasi?'),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Tidak')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Ya')),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (_pages.isEmpty) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    // --- LOGIKA JUDUL APPBAR (DIPERBARUI) ---
    String title = "Rilah Marathon";

    if (role == 'admin') {
      if (_currentIndex == 1) title = "Kelola User"; // Judul halaman Users
      if (_currentIndex == 2) title = "Tentang Aplikasi";
      if (_currentIndex == 3) title = "Profil Saya";
    } else {
      if (_currentIndex == 1) title = "Riwayat Lomba";
      if (_currentIndex == 2) title = "Tentang Aplikasi";
      if (_currentIndex == 3) title = "Profil Saya";
    }

    // Index halaman profil sekarang sama-sama di index 3 untuk kedua role
    int profileIndex = 3;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          automaticallyImplyLeading: false,
          elevation: 2,
          backgroundColor: Colors.white.withOpacity(0.9),
          actions: [
            // Sembunyikan tombol logout jika sedang di halaman Profil
            if (_currentIndex != profileIndex)
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: "Keluar Akun",
                onPressed: _confirmLogout,
              )
          ],
        ),

        // --- BAGIAN BACKGROUND IMAGE ---
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const NetworkImage(
                  'https://rilah.ujangkedu.my.id/images/2.jpeg'
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.92),
                BlendMode.lighten,
              ),
            ),
          ),
          child: _pages[_currentIndex],
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: Colors.orange[800],
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: role == 'admin'
              ? const [
            // Menu Admin (4 Item)
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Manage'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'), // Icon Menu User
            BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]
              : const [
            // Menu User (4 Item)
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_page.dart';
import 'register_account_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('https://rilah.ujangkedu.my.id/api/login.php'),
        body: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      );

      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', data['user_id'].toString());
        await prefs.setString('name', data['name']);
        await prefs.setString('role', data['role']);

        if (data['photo_url'] != null && data['photo_url'].toString().isNotEmpty && data['photo_url'] != "null") {
          await prefs.setString('photo_url', data['photo_url']);
        } else {
          await prefs.remove('photo_url');
        }

        if (mounted) {
          // Navigasi ke Dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );

          _showPremiumTopNotification(context, "Login Berhasil!", "Selamat Datang, ${data['name']}");
          // ---------------------------------------------
        }
      } else {
        if (mounted) {
          // Tampilkan error di atas juga
          _showPremiumTopNotification(context, "Login Gagal", "Cek username atau password Anda", isError: true);
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- WIDGET KHUSUS NOTIFIKASI ATAS (PREMIUM DESIGN) ---
  void _showPremiumTopNotification(BuildContext context, String title, String message, {bool isError = false}) {
    // Menghitung posisi agar muncul di atas layar
    // Mengambil tinggi layar dikurangi offset tertentu
    final double topMargin = MediaQuery.of(context).size.height - 250;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.up,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent, // Transparan agar kita bisa custom bentuknya
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        // Margin ini yang membuat snackbar "terlempar" ke atas
        margin: EdgeInsets.only(
          bottom: topMargin,
          left: 20,
          right: 20,
        ),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            // Gradient Warna Premium
            gradient: LinearGradient(
              colors: isError
                  ? [const Color(0xFFFF512F), const Color(0xFFDD2476)] // Merah Error
                  : [const Color(0xFF00BFA5), const Color(0xFF00C853)], // Hijau Sukses
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1532444458054-01a7dd3e9fca?q=80&w=1000&auto=format&fit=crop'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. GRADIENT OVERLAY
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),

          // 3. FORM LOGIN
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.directions_run, size: 70, color: Colors.white),
                  const SizedBox(height: 10),
                  const Text(
                    "WELCOME TO RILAH MARATHON",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5
                    ),
                  ),
                  const SizedBox(height: 40),

                  // INPUT USERNAME
                  _buildPremiumTextField(
                    controller: _usernameController,
                    icon: Icons.person_outline,
                    label: "Username",
                  ),

                  const SizedBox(height: 20),

                  // INPUT PASSWORD
                  _buildPremiumTextField(
                    controller: _passwordController,
                    icon: Icons.lock_outline,
                    label: "Password",
                    isPassword: true,
                  ),

                  const SizedBox(height: 40),

                  // TOMBOL LOGIN
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.orange)
                      : Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
                      ),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFFFF512F).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: _login,
                      child: const Text("LOGIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // LINK REGISTER
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterAccountPage()));
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Belum punya akun? ",
                        style: TextStyle(color: Colors.white70),
                        children: [
                          TextSpan(
                            text: "Daftar disini",
                            style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET HELPER
  Widget _buildPremiumTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    bool isPassword = false
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white30),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}